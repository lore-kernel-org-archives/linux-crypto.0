From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Thu, 30 Jun 2016 13:42:19 -0700
Message-ID: <1467319339.22178.256.camel@linux.intel.com>
References: <20160629144242.GE22818@mwanda>
	 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbcF3UmX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 16:42:23 -0400
In-Reply-To: <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2016-06-29 at 10:05 -0700, H. Peter Anvin wrote:
> On 06/29/16 07:42, Dan Carpenter wrote:
> >=20
> > >=20
> > > >=20
> > > > and | behave basically the same here but || is intended.=C2=A0=C2=
=A0It causes a
> > static checker warning to mix up bitwise and logical operations.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >=20
> > diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypt=
o/sha256-mb/sha256_mb.c
> > index c9d5dcc..4ec895a 100644
> > --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> > +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> > @@ -299,7 +299,7 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_s=
ubmit(struct sha256_ctx_mgr *mgr,
> > =C2=A0	=C2=A0* Or if the user's buffer contains less than a whole b=
lock,
> > =C2=A0	=C2=A0* append as much as possible to the extra block.
> > =C2=A0	=C2=A0*/
> > -	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SIZE=
)) {
> > +	if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK_SIZ=
E)) {
> > =C2=A0		/* Compute how many bytes to copy from user buffer into
> > =C2=A0		=C2=A0* extra block
> > =C2=A0		=C2=A0*/
> >=20
> As far as I know the | was an intentional optimization, so you may wa=
y
> to look at the generated code.
>=20
> 	-hpa
>=20

Yes, this is an intentional optimization. =C2=A0Is there any scenario w=
here things may
break with the compiler?

Tim
