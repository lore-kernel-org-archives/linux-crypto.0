From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 1 Jul 2016 12:13:30 +0200
Message-ID: <20160701101329.GA3833@gmail.com>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
 <20160701075559.GA11902@gmail.com>
 <20160701092806.GA13424@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36171 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcGALMC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 07:12:02 -0400
Content-Disposition: inline
In-Reply-To: <20160701092806.GA13424@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jul 01, 2016 at 09:55:59AM +0200, Ingo Molnar wrote:
> >
> > Plus:
> >=20
> > > > > =A0		/* Compute how many bytes to copy from user buffer into
> > > > > =A0		=A0* extra block
> > > > > =A0		=A0*/
> >=20
> > please use the customary (multi-line) comment style:
>=20
> This is the customary comment style of the networking stack and
> the crypto API.  So please don't change it.

Guys, do you even read your own code??

That 'standard' is not being enforced consistently at all. Even in this=
 very=20
series there's an example of that weird comment not being followed:

+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -304,7 +304,7 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_submit(st=
ruct sha1_ctx_mgr *mgr,
                /*
                 * Compute how many bytes to copy from user buffer into
                 * extra block

See how this comment block uses the standard coding style, while the ne=
xt patch=20
has this weird coding style:

-       if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SI=
ZE)) {
+       if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK_S=
IZE)) {
                /* Compute how many bytes to copy from user buffer into
                 * extra block
                 */

The networking code's "exceptionalism" regarding the standard comment s=
tyle is=20
super distracting and in this particular example it resulted in:

 - inconsistent comment styles next to each other,
 - the questionable '|' pattern hiding right next to:
 - pointless parantheses around the (ctx->partial_block_buffer_length),
 - which field name is also a misnomer.

So anyone doing security review of that weird '|' pattern first has to =
figure out=20
whether the 4 ugly code patterns amount to a security problem or not...

One thing that is more harmful that any of the coding styles: the incon=
sistent=20
coding style used by this code.

Btw., as a historic reference, there is nothing sacred about the 'netwo=
rking=20
comments coding style': I was there (way too many years ago) when that =
comment=20
style was introduced by Alan Cox's first TCP/IP code drop, and it was l=
ittle more=20
than just a random inconsistency that people are now treating as gospel=
=2E..

Thanks,

	Ingo
