From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Tue, 10 Mar 2015 20:37:07 +1100
Message-ID: <20150310093707.GA17289@gondor.apana.org.au>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
 <1425610707-9869-2-git-send-email-james.hartley@imgtec.com>
 <1582962.nmzkjGWQFm@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hartley <james.hartley@imgtec.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
	andrew.bresticker@chromium.org, ezequiel.garcia@imgtec.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55928 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbbCJJhn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 05:37:43 -0400
Content-Disposition: inline
In-Reply-To: <1582962.nmzkjGWQFm@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 09, 2015 at 07:35:57AM +0100, Stephan Mueller wrote:
>
> >+static struct ahash_alg img_algs[] = {
> >+	{
> >+		.init = img_hash_init,
> >+		.update = img_hash_update,
> >+		.final = img_hash_final,
> >+		.finup = img_hash_finup,
> >+		.digest = img_hash_digest,
> >+		.halg = {
> >+			.digestsize = MD5_DIGEST_SIZE,
> >+			.base = {
> >+				.cra_name = "md5",
> >+				.cra_driver_name = "img-md5",
> >+				.cra_priority = 301,
> 
> Just curious: why do you use such odd priorities of 301 or 3000? IMHO, 
> all you need is a priority of more than 100 to "beat" the generic C 
> prios. Maybe you also need to beat the standard assembler 
> implementations which are routinely at 200 for hashes. So, a prio of 300 
> should suffice, should it not?

James, can you answer Stephan's question please?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
