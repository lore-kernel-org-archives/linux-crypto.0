From: Joe Perches <joe@perches.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Thu, 30 Jun 2016 04:16:26 -0700
Message-ID: <1467285386.24287.143.camel@perches.com>
References: <20160629144242.GE22818@mwanda>
	 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
	 <20160630075056.GR32247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160630075056.GR32247@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2016-06-30 at 10:50 +0300, Dan Carpenter wrote:
> On Wed, Jun 29, 2016 at 10:05:53AM -0700, H. Peter Anvin wrote:
> > On 06/29/16 07:42, Dan Carpenter wrote:
> > > > > and | behave basically the same here but || is intended.=A0=A0=
It causes a
> > > static checker warning to mix up bitwise and logical operations.
> > >=20
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > >=20
> > > diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/cry=
pto/sha256-mb/sha256_mb.c
[]
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
> I know how the rules work.=A0=A0I just thought it looked more like a =
typo
> than an optimization.=A0=A0It's normally a typo.=A0=A0It's hard to te=
ll the
> intent.

The compiler could potentially emit the same code when
optimizing but at least gcc 5.3 doesn't.

It's probably useful to add a comment for the specific intent
here rather than change a potentially useful static checker.
