Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7879AC388F7
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 04:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2B9223FB
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 04:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603342734;
	bh=hN7GiMRaOq0FOXfdA6xo4EAlbLaq+CosLc5jqhzgnvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QOyZe6y7N6NMSTYrJJdh0mlEUgourCy5upQEJ30gMka80uLf7rD4kQ+bnqoDnuWa0
	 +IF71BpxB7zr9hHzqKZ5IusdazJ1IL2BvTGttQb3PIL4zRBw/RtDNFIfhkkjYaC9oS
	 Ialvv2lQIeyPOIp7UAJtklLlXWTR6THb7Yz8G44w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507648AbgJVE6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 00:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507647AbgJVE6x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 00:58:53 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C333223C7;
        Thu, 22 Oct 2020 04:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603342732;
        bh=hN7GiMRaOq0FOXfdA6xo4EAlbLaq+CosLc5jqhzgnvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AWbhcZ7C04iuVaR0/RhfNSWB1YYayIzQXbZCg5sitAbKcayPqtKCY1r2NJ22CrSDT
         OXgIY04zLiM+FPK97mEZqMffcqp1HlmacPN3md38OuFuKxz8u8JAJIk5JZWcr2br+U
         wKXqRjMxAiQ3QDb7roMwfmQXuexgpgIfqucEeVRg=
Date:   Wed, 21 Oct 2020 21:58:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] crypto: lib/sha256 - Don't clear temporary
 variables
Message-ID: <20201022045850.GE857@sol.localdomain>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-3-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020203957.3512851-3-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 04:39:53PM -0400, Arvind Sankar wrote:
> The assignments to clear a through h and t1/t2 are optimized out by the
> compiler because they are unused after the assignments.
> 
> These variables shouldn't be very sensitive: t1/t2 can be calculated
> from a through h, so they don't reveal any additional information.
> Knowing a through h is equivalent to knowing one 64-byte block's SHA256
> hash (with non-standard initial value) which, assuming SHA256 is secure,
> doesn't reveal any information about the input.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

I don't entirely buy the second paragraph.  It could be the case that the input
is less than or equal to one SHA-256 block (64 bytes), in which case leaking
'a' through 'h' would reveal the final SHA-256 hash if the input length is
known.  And note that callers might consider either the input, the resulting
hash, or both to be sensitive information -- it depends.

> ---
>  lib/crypto/sha256.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index d43bc39ab05e..099cd11f83c1 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -202,7 +202,6 @@ static void sha256_transform(u32 *state, const u8 *input)
>  	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
>  
>  	/* clear any sensitive info... */
> -	a = b = c = d = e = f = g = h = t1 = t2 = 0;
>  	memzero_explicit(W, 64 * sizeof(u32));
>  }

Your change itself is fine, though.  As you mentioned, these assignments get
optimized out, so they weren't accomplishing anything.

The fact is, there just isn't any way to guarantee in C code that all sensitive
variables get cleared.

So we shouldn't (and generally don't) bother trying to clear individual u32's,
ints, etc. like this, but rather only structs and arrays, as clearing those is
more likely to work as intended.

- Eric
