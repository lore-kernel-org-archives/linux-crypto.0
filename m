From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC PATCH 1/2] crypto: caam - properly set IV after {en,de}crypt
Date: Wed, 28 Jun 2017 08:32:12 +0000
Message-ID: <VI1PR0401MB2591CC6A245731D9D53D42A598DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170602122446.2427-2-david@sigma-star.at>
 <VI1PR0401MB2591177E3F43DEFA8AEA3D6D98C40@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6/19/2017 1:31 PM, Horia Geant=E3 wrote:=0A=
> On 6/2/2017 3:25 PM, David Gstir wrote:=0A=
>> Certain cipher modes like CTS expect the IV (req->info) of=0A=
>> ablkcipher_request (or equivalently req->iv of skcipher_request) to=0A=
>> contain the last ciphertext block when the {en,de}crypt operation is don=
e.=0A=
>> This is currently not the case for the CAAM driver which in turn breaks=
=0A=
>> e.g. cts(cbc(aes)) when the CAAM driver is enabled.=0A=
>>=0A=
>> This patch fixes the CAAM driver to properly set the IV after the=0A=
>> {en,de}crypt operation of ablkcipher finishes.=0A=
>>=0A=
>> Signed-off-by: David Gstir <david@sigma-star.at>=0A=
>> ---=0A=
>>  drivers/crypto/caam/caamalg.c | 26 ++++++++++++++++++++++++--=0A=
>>  1 file changed, 24 insertions(+), 2 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg=
.c=0A=
>> index 398807d1b77e..d13c1aee4427 100644=0A=
>> --- a/drivers/crypto/caam/caamalg.c=0A=
>> +++ b/drivers/crypto/caam/caamalg.c=0A=
>> @@ -882,10 +882,11 @@ static void ablkcipher_encrypt_done(struct device =
*jrdev, u32 *desc, u32 err,=0A=
>>  {=0A=
>>  	struct ablkcipher_request *req =3D context;=0A=
>>  	struct ablkcipher_edesc *edesc;=0A=
>> -#ifdef DEBUG=0A=
>>  	struct crypto_ablkcipher *ablkcipher =3D crypto_ablkcipher_reqtfm(req)=
;=0A=
>>  	int ivsize =3D crypto_ablkcipher_ivsize(ablkcipher);=0A=
>> +	int nents;=0A=
>>  =0A=
>> +#ifdef DEBUG=0A=
>>  	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);=0A=
>>  #endif=0A=
>>  =0A=
>> @@ -904,6 +905,19 @@ static void ablkcipher_encrypt_done(struct device *=
jrdev, u32 *desc, u32 err,=0A=
>>  #endif=0A=
[snip]=0A=
>> +	sg_pcopy_to_buffer(req->dst, nents, req->info, ivsize,=0A=
>> +			   req->nbytes - ivsize);=0A=
> =0A=
> scatterwalk_map_and_copy() should be used instead.=0A=
> =0A=
David, IIUC this is the only change needed in this patch (applies both=0A=
for encryption and decryption, of course).=0A=
Will you formally resubmit?=0A=
=0A=
Thanks,=0A=
Horia=0A=
