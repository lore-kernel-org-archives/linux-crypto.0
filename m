From: Nick Terrell <terrelln@fb.com>
Subject: Re: [RESEND PATCH] crypto: Add zstd support
Date: Fri, 30 Mar 2018 19:23:06 +0000
Message-ID: <992742B1-A16C-4DFF-95BB-6FF09F7CCA4C@fb.com>
References: <20180321224929.3076350-1-terrelln@fb.com>
 <20180322043230.GD3181@jagdpanzerIV>
 <20180330171459.GB27856@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Geliang Tang <geliangtang@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180330171459.GB27856@gondor.apana.org.au>
Content-Language: en-US
Content-ID: <8082CBCA03CD0A478EFAABDE9CEB2431@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> On Mar 30, 2018, at 10:14 AM, Herbert Xu <herbert@gondor.apana.org.au> wr=
ote:
>=20
> On Thu, Mar 22, 2018 at 01:32:30PM +0900, Sergey Senozhatsky wrote:
>> On (03/21/18 15:49), Nick Terrell wrote:
>>> depends on CONFIG_CRYPTO_ZSTD, which isn't defined until this patch is =
in
>>=20
>> Yikes! How come I missed that... :)
>>=20
>>> [0] lkml.kernel.org/r/9c9416b2dff19f05fb4c35879aaa83d11ff72c92.15216261=
82.git.geliangtang@gmail.com
>>=20
>> Signed-off-by: Nick Terrell <terrelln@fb.com> ?
>=20
> Please resend with sign-off.

Sorry about that, resent as http://lkml.kernel.org/r/20180330191453.3535287=
-1-terrelln@fb.com.

>=20
> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__gondor.a=
pana.org.au_-7Eherbert_&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DHQM5IQdWO=
B8WaMoii2dYTw&m=3D9TJPOvcdtkpIjIAGJJ6-7fzehxatF48hBoFlxI0lAw8&s=3D79UWdDJu7=
MxUVoJ2mEANx31Yj5EYfAyJl8noCeBv-4c&e=3D
> PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__gondor.apa=
na.org.au_-7Eherbert_pubkey.txt&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DH=
QM5IQdWOB8WaMoii2dYTw&m=3D9TJPOvcdtkpIjIAGJJ6-7fzehxatF48hBoFlxI0lAw8&s=3D9=
Pll03qIuCxGGfTX0v5TkbxRUh7p76X1keoDqWC49UA&e=3D
