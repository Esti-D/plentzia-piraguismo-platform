export const handler = async (event: any) => {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      status: "ok",
      service: "plentzia-piraguismo-platform"
    })
  };
};