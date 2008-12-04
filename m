From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] Switch remaining algorithms to shash
Date: Thu, 4 Dec 2008 14:48:12 +0800
Message-ID: <20081204064812.GB18141@gondor.apana.org.au>
References: <12283498922490-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48298 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755359AbYLDGsP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 01:48:15 -0500
Content-Disposition: inline
In-Reply-To: <12283498922490-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 04, 2008 at 01:18:08AM +0100, Adrian-Ken Rueegsegger wrote:
> 
> The first patch removes the message schedule W from struct sha512_ctx
> since it gets calculated anew on each execution of sha512_transform. This
> reduces the size of sha512_ctx considerably and will allow it to be
> registered as a shash algorithm (it will pass the size check in
> crypto_register_shash (crypto/shash.c:490)).
> Herbert, could you explain why descsize must be smaller (or equal)
> than PAGE_SIZE / 8?

This is so that people can put it on the stack safely.  So moving
things out of the context and onto the stack because it's too big
is a no-no :)

Perhaps store in a static percpu area?

> The next two patches switch sha512 and wp512 to the new shash interface.

BTW, in order to add missing Kconfig dependencies on HASH I've
just rebased my tree and updated all the shash conversion patches.
So please resend them with the Kconfig bits added.

> The fourth patch is another try to convert michael_mic. The key values
> l and r are duplicated in the descriptor part since they are used and
> changed during the actual transformation. I would be gratefull for
> comments on this patch since I am not sure it's the proper way to do it.

Since they're read-only they should be obtained from the tfm context
when needed, just like crc32c.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
