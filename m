From: James Hartley <James.Hartley@imgtec.com>
Subject: RE: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Tue, 10 Mar 2015 09:54:49 +0000
Message-ID: <72BC0C8BD7BB6F45988A99382E5FBAE54446310E@hhmail02.hh.imgtec.org>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
 <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
 <1582962.nmzkjGWQFm@tauon> <20150310093707.GA17289@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"Andrew Bresticker (abrestic@chromium.org)" <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:46483 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbCJJyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 05:54:51 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Resend with correct email address for Andrew Bresticker.

> -----Original Message-----
> From: James Hartley
> Sent: 10 March 2015 09:53
> To: 'Herbert Xu'; Stephan Mueller
> Cc: robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> galak@codeaurora.org; andrew.bresticker@chromium.org; Ezequiel Garcia;
> linux-crypto@vger.kernel.org
> Subject: RE: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
> accelerator
> 
> 
> > -----Original Message-----
> > From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> > Sent: 10 March 2015 09:37
> > To: Stephan Mueller
> > Cc: James Hartley; robh+dt@kernel.org; pawel.moll@arm.com;
> > mark.rutland@arm.com; galak@codeaurora.org;
> > andrew.bresticker@chromium.org; Ezequiel Garcia; linux-
> > crypto@vger.kernel.org
> > Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
> > accelerator
> >
> > On Mon, Mar 09, 2015 at 07:35:57AM +0100, Stephan Mueller wrote:
> > >
> > > >+static struct ahash_alg img_algs[] = {
> > > >+	{
> > > >+		.init = img_hash_init,
> > > >+		.update = img_hash_update,
> > > >+		.final = img_hash_final,
> > > >+		.finup = img_hash_finup,
> > > >+		.digest = img_hash_digest,
> > > >+		.halg = {
> > > >+			.digestsize = MD5_DIGEST_SIZE,
> > > >+			.base = {
> > > >+				.cra_name = "md5",
> > > >+				.cra_driver_name = "img-md5",
> > > >+				.cra_priority = 301,
> > >
> > > Just curious: why do you use such odd priorities of 301 or 3000? IMHO,
> > > all you need is a priority of more than 100 to "beat" the generic C
> > > prios. Maybe you also need to beat the standard assembler
> > > implementations which are routinely at 200 for hashes. So, a prio of
> > > 300 should suffice, should it not?
> >
> > James, can you answer Stephan's question please?
> 
> Hi Herbert, and Stephan,
> 
> The difficulty here is that the driver was written by a summer placement
> student who has since left the company, and despite searching our internal
> commit logs I'm unable to find any reason why 301 and 3000 are used.  I am
> happy to set them to 300 if that is a sensible figure to use.
> 
> Thanks for the review Stephan!
> 
> >
> > Thanks,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> > http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
> James.
