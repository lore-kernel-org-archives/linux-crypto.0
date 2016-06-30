From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 1 Jul 2016 01:16:54 +0300
Message-ID: <20160630221654.GE32301@mwanda>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467319339.22178.256.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 30, 2016 at 01:42:19PM -0700, Tim Chen wrote:
> On Wed, 2016-06-29 at 10:05 -0700, H. Peter Anvin wrote:
> > On 06/29/16 07:42, Dan Carpenter wrote:
> > >=20
> > > >=20
> > > > >=20
> > > > > and | behave basically the same here but || is intended.=A0=A0=
It causes a
> > > static checker warning to mix up bitwise and logical operations.
> > >=20
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > >=20
> > > diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/cry=
pto/sha256-mb/sha256_mb.c
> > > index c9d5dcc..4ec895a 100644
> > > --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> > > +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> > > @@ -299,7 +299,7 @@ static struct sha256_hash_ctx *sha256_ctx_mgr=
_submit(struct sha256_ctx_mgr *mgr,
> > > =A0	=A0* Or if the user's buffer contains less than a whole block=
,
> > > =A0	=A0* append as much as possible to the extra block.
> > > =A0	=A0*/
> > > -	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SI=
ZE)) {
> > > +	if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK_S=
IZE)) {
> > > =A0		/* Compute how many bytes to copy from user buffer into
> > > =A0		=A0* extra block
> > > =A0		=A0*/
> > >=20
> > As far as I know the | was an intentional optimization, so you may =
way
> > to look at the generated code.
> >=20
> > 	-hpa
> >=20
>=20
> Yes, this is an intentional optimization. =A0Is there any scenario wh=
ere things may
> break with the compiler?

No.  I'm going to remove the warning from the static checker like I sai=
d
earlier.  It should only complain for && vs & typos, || vs | is
harmless.

regards,
dan carpenter
