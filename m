From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: tcrypt: don't disable irqs and wait
Date: Wed, 26 Apr 2017 12:05:55 +0000
Message-ID: <VI1PR0401MB259167A209EFFF799BB1FF9B98110@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1493108740-1642-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gilad.benyossef@arm.com" <gilad.benyossef@arm.com>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:20160
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1951574AbdDZMF6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2017 08:05:58 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/25/2017 11:25 AM, Gilad Ben-Yossef wrote:=0A=
> The tcrypt AEAD cycles speed tests disables irqs during the test, which i=
s=0A=
> broken at the very least since commit=0A=
> '1425d2d17f7309c6 ("crypto: tcrypt - Fix AEAD speed tests")'=0A=
> adds a wait for completion as part of the test and probably since=0A=
> switching to the new AEAD API.=0A=
> =0A=
> While the result of taking a cycle count diff may not mean much on SMP=0A=
> systems if the task migrates, it's good enough for tcrypt being the quick=
=0A=
> & dirty dev tool it is. It's also what all the other (i.e. hash) cycle=0A=
> speed tests do.=0A=
> =0A=
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>=0A=
> Reported-by: Ofir Drang <ofir.drang@arm.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
I've also noticed this in CAAM accelerator - spin_unlock_bh() called=0A=
from caam_jr_enqueue() complains due to disabled interrupts:=0A=
WARNING: CPU: 4 PID: 2585 at kernel/softirq.c:161=0A=
.__local_bh_enable_ip+0x70/0xcc=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
> ---=0A=
>  crypto/tcrypt.c | 4 ----=0A=
>  1 file changed, 4 deletions(-)=0A=
> =0A=
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c=0A=
> index 9a11f3c..0dd6a43 100644=0A=
> --- a/crypto/tcrypt.c=0A=
> +++ b/crypto/tcrypt.c=0A=
> @@ -138,8 +138,6 @@ static int test_aead_cycles(struct aead_request *req,=
 int enc, int blen)=0A=
>  	int ret =3D 0;=0A=
>  	int i;=0A=
>  =0A=
> -	local_irq_disable();=0A=
> -=0A=
>  	/* Warm-up run. */=0A=
>  	for (i =3D 0; i < 4; i++) {=0A=
>  		if (enc)=0A=
> @@ -169,8 +167,6 @@ static int test_aead_cycles(struct aead_request *req,=
 int enc, int blen)=0A=
>  	}=0A=
>  =0A=
>  out:=0A=
> -	local_irq_enable();=0A=
> -=0A=
>  	if (ret =3D=3D 0)=0A=
>  		printk("1 operation in %lu cycles (%d bytes)\n",=0A=
>  		       (cycles + 4) / 8, blen);=0A=
> =0A=
=0A=
