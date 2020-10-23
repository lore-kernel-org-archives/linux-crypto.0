Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EE6C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2C020BED
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603491089;
	bh=oYDdkAGeOEwqEQlJ3M1O6TGp5eWuctvbDWvQg3nFwJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bKYhsfvTBKHrqvCWMGCmkUFUIwW10IGhUPHhjDZf9aRX1I786sw8K7GAwQp25or1j
	 xJ//nEhnB1B++Nco5w0gWVFsPn5B55azfYuX1Th+jj65uldeUKR+nCzPZ65lWWVo2G
	 CRrVKlFLj0JmcnFDMBzaMOgICa10AClqGyfh6UnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757043AbgJWWL3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 18:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757036AbgJWWL2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 18:11:28 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AAA720724;
        Fri, 23 Oct 2020 22:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603491088;
        bh=oYDdkAGeOEwqEQlJ3M1O6TGp5eWuctvbDWvQg3nFwJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xxb/GAjvsPxTRs76hmFkdHimX18DvXWGGDbMDdK7f2OEgLtOzJAp9fOMx79mW5KDW
         jrF+kplGKkYgHIb12ePKpXbDRPxWF5qKWHe+jO3D2Sf+yoFJccO/pd/9RPWaYrAw18
         eywmcxbINrfrNIQN0OFWYyur+NOhGakeNv7rhJsE=
Date:   Fri, 23 Oct 2020 15:11:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] crypto: lib/sha256 - Don't clear temporary
 variables
Message-ID: <20201023221126.GB180517@gmail.com>
References: <20201023192203.400040-1-nivedita@alum.mit.edu>
 <20201023192203.400040-3-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023192203.400040-3-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 23, 2020 at 03:22:00PM -0400, Arvind Sankar wrote:
> The assignments to clear a through h and t1/t2 are optimized out by the
> compiler because they are unused after the assignments.
> 
> Clearing individual scalar variables is unlikely to be useful, as they
> may have been assigned to registers, and even if stack spilling was
> required, there may be compiler-generated temporaries that are
> impossible to clear in any case.
> 
> So drop the clearing of a through h and t1/t2.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
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

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
