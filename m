From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 1 Jul 2016 09:55:59 +0200
Message-ID: <20160701075559.GA11902@gmail.com>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35009 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbcGAH4E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 03:56:04 -0400
Content-Disposition: inline
In-Reply-To: <1467319339.22178.256.camel@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

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
> Yes, this is an intentional optimization. [...]

Please don't do intentional optimizations while mixing them with a very=
 ugly=20
coding style:

	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SIZE)) {

The extra, unnecessary parantheses around ctx->partial_block_buffer_len=
gth will=20
make the ordinary reader assume that the person who wrote the code was =
unsure=20
about basic C syntax details and typoed the '|' as well ...

Also, for heaven's (and readability's) sake, pick shorter structure fie=
ld names.=20
What's wrong with ctx->partial_block_buf_len?

Also, even if the '|' was intentional - wouldn't it result in better co=
de to use=20
'||'?

Plus:

> > > =A0		/* Compute how many bytes to copy from user buffer into
> > > =A0		=A0* extra block
> > > =A0		=A0*/

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
