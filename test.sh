docker build -q -t ani .
docker run --rm --name ani -d -p 8080:8080 ani

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"opcode":230,"state":{"a":58,"b":1,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":1,"stackPointer":2,"cycles":0}}' \
  http://localhost:8080/api/v1/execute?operand=15`
EXPECTED='{"opcode":230,"state":{"a":10,"b":1,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":true,"carry":false},"programCounter":1,"stackPointer":2,"cycles":7}}'

docker kill ani

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mANI Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mANI Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi