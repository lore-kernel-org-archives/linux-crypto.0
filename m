From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v3] crypto: caam: Drop leading zero from input buffer
Date: Mon, 16 Apr 2018 13:16:20 +0000
Message-ID: <VI1PR0402MB34855AF031E6E5502A431BB298B00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1523801558-21647-1-git-send-email-festevam@gmail.com>
 <CABatt_y0saOjTm4pzfgV1Cpi=1P1FBQt2RLGQZyemhUou3k0PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Breno Matheus Lima <breno.lima@nxp.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Martin Townsend <mtownsend1973@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/15/2018 6:51 PM, Martin Townsend wrote:=0A=
> On Sun, Apr 15, 2018 at 3:12 PM, Fabio Estevam <festevam@gmail.com> wrote=
:=0A=
>> From: Fabio Estevam <fabio.estevam@nxp.com>=0A=
>>=0A=
>> imx6ul and imx7 report the following error:=0A=
>>=0A=
>> caam_jr 2142000.jr1: 40000789: DECO: desc idx 7:=0A=
>> Protocol Size Error - A protocol has seen an error in size. When=0A=
>> running RSA, pdb size N < (size of F) when no formatting is used; or=0A=
>> pdb size N < (F + 11) when formatting is used.=0A=
>>=0A=
>> ------------[ cut here ]------------=0A=
>> WARNING: CPU: 0 PID: 1 at crypto/asymmetric_keys/public_key.c:148=0A=
>> public_key_verify_signature+0x27c/0x2b0=0A=
>>=0A=
>> This error happens because the signature contains 257 bytes, including=
=0A=
>> a leading zero as the first element.=0A=
>>=0A=
>> Fix the problem by stripping off the leading zero from input data=0A=
>> before feeding it to the CAAM accelerator.=0A=
>>=0A=
>> Fixes: 8c419778ab57e497b5 ("crypto: caam - add support for RSA algorithm=
")=0A=
>> Cc: <stable@vger.kernel.org>=0A=
>> Reported-by: Martin Townsend <mtownsend1973@gmail.com>=0A=
>> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>=0A=
>> ---=0A=
>> Changes since v2:=0A=
>> - Check if the lenght is zero after calling caam_rsa_drop_leading_zeros(=
)=0A=
>>=0A=
>>  drivers/crypto/caam/caampkc.c | 45 +++++++++++++++++++++++++++++++++++-=
-------=0A=
>>  1 file changed, 37 insertions(+), 8 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc=
.c=0A=
>> index 7a897209..47467ff 100644=0A=
>> --- a/drivers/crypto/caam/caampkc.c=0A=
>> +++ b/drivers/crypto/caam/caampkc.c=0A=
>> @@ -166,6 +166,14 @@ static void rsa_priv_f3_done(struct device *dev, u3=
2 *desc, u32 err,=0A=
>>         akcipher_request_complete(req, err);=0A=
>>  }=0A=
>>=0A=
>> +static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)=
=0A=
>> +{=0A=
>> +       while (!**ptr && *nbytes) {=0A=
>> +               (*ptr)++;=0A=
>> +               (*nbytes)--;=0A=
>> +       }=0A=
>> +}=0A=
>> +=0A=
>>  static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,=
=0A=
>>                                          size_t desclen)=0A=
>>  {=0A=
>> @@ -178,7 +186,36 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akc=
ipher_request *req,=0A=
>>         int sgc;=0A=
>>         int sec4_sg_index, sec4_sg_len =3D 0, sec4_sg_bytes;=0A=
>>         int src_nents, dst_nents;=0A=
>> +       const u8 *temp;=0A=
>> +       void *buffer;=0A=
>> +       size_t len;=0A=
>> +=0A=
>> +       buffer =3D kzalloc(req->src_len, GFP_ATOMIC);=0A=
>> +       if (!buffer)=0A=
>> +               return ERR_PTR(-ENOMEM);=0A=
>> +=0A=
>> +       sg_copy_to_buffer(req->src, sg_nents(req->src),=0A=
>> +                         buffer, req->src_len);=0A=
>> +       temp =3D (u8 *)buffer;=0A=
>> +       len =3D req->src_len;=0A=
>>=0A=
>> +       /*=0A=
>> +        * Check if the buffer contains leading zeros and if=0A=
>> +        * it does, drop the leading zeros=0A=
>> +        */=0A=
>> +       if (temp[0] =3D=3D 0) {=0A=
>> +               caam_rsa_drop_leading_zeros(&temp, &len);=0A=
>> +               if (!len) {=0A=
>> +                       kfree(buffer);=0A=
>> +                       return ERR_PTR(-ENOMEM);=0A=
>> +               }=0A=
>> +=0A=
>> +               req->src_len =3D len;=0A=
>> +               sg_copy_from_buffer(req->src, sg_nents(req->src),=0A=
>> +                                   (void *)temp, req->src_len);=0A=
>> +       }=0A=
>> +=0A=
>> +       kfree(buffer);=0A=
>>         src_nents =3D sg_nents_for_len(req->src, req->src_len);=0A=
>>         dst_nents =3D sg_nents_for_len(req->dst, req->dst_len);=0A=
>>=0A=
>> @@ -683,14 +720,6 @@ static void caam_rsa_free_key(struct caam_rsa_key *=
key)=0A=
>>         memset(key, 0, sizeof(*key));=0A=
>>  }=0A=
>>=0A=
>> -static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)=
=0A=
>> -{=0A=
>> -       while (!**ptr && *nbytes) {=0A=
>> -               (*ptr)++;=0A=
>> -               (*nbytes)--;=0A=
>> -       }=0A=
>> -}=0A=
>> -=0A=
>>  /**=0A=
>>   * caam_read_rsa_crt - Used for reading dP, dQ, qInv CRT members.=0A=
>>   * dP, dQ and qInv could decode to less than corresponding p, q length,=
 as the=0A=
>> --=0A=
>> 2.7.4=0A=
>>=0A=
> =0A=
> Hi Fabio,=0A=
> =0A=
> just tried it and it works fine on my i.MX6UL board running linux-imx=0A=
> 4.9 (had to manually apply the patch as it doesn't have=0A=
> caam_rsa_drop_leading_zeros) so a=0A=
> Reviewed and Tested-By Martin Townsend=0A=
> =0A=
I've sent a fix that does not copy data back and forth, instead it counts t=
he=0A=
leading zeros and ffwds the S/G.=0A=
Please check it works in your case.=0A=
=0A=
Thanks,=0A=
Horia=0A=
