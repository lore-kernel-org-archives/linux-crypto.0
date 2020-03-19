Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0863AC4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 03:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB03220782
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 03:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584588329;
	bh=XAFCfbjIK9ADzL+XcdVl/M3g06t2Qe974ZfWHzwYaCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q+f9HFBvhPGbFGRIqiv3bfm67WvpNzNafdFvyUcK4EKN9qcwg9KLGleiHXz4Qo35P
	 PSJ/RHgS27jF7stjTnOl0F8PnxaqGkfOId7Xp+Lw2CKFapYkZG6gJu59xxwxdtfdO4
	 vryP3RGcw/BRXXR6h6VOkRLzHlSc218B/lVOUypA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgCSDZ3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Mar 2020 23:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSDZ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Mar 2020 23:25:28 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8D920768;
        Thu, 19 Mar 2020 03:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584588328;
        bh=XAFCfbjIK9ADzL+XcdVl/M3g06t2Qe974ZfWHzwYaCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sbkt2ntR4wZ1jGNHJZ505dNozhNQ6OX1XZeHsk8b3X3ge6UGrjxD802sbmKHO1ybW
         BCz1zGuA5FuM8AxfEIZpKWHZp8s4AGfI4n1u4eFXs1vdqohU7r9X3eaG8YluS07nU5
         BrEZfwE8nqfQDU//as2A5m3dx7J0vxtjVSZdTNps=
Date:   Wed, 18 Mar 2020 20:25:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk
 through blocks
Message-ID: <20200319032526.GH2334@sol.localdomain>
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
 <20200319022732.166085-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319022732.166085-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 18, 2020 at 08:27:32PM -0600, Jason A. Donenfeld wrote:
> It also fixes up a bug in the (optional, costly) stride test that
> prevented it from running on arm64.
[...]
> diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
> index c391a91364e9..fa43deda2660 100644
> --- a/lib/crypto/chacha20poly1305-selftest.c
> +++ b/lib/crypto/chacha20poly1305-selftest.c
> @@ -9028,10 +9028,15 @@ bool __init chacha20poly1305_selftest(void)
>  	     && total_len <= 1 << 10; ++total_len) {
>  		for (i = 0; i <= total_len; ++i) {
>  			for (j = i; j <= total_len; ++j) {
> +				k = 0;
>  				sg_init_table(sg_src, 3);
> -				sg_set_buf(&sg_src[0], input, i);
> -				sg_set_buf(&sg_src[1], input + i, j - i);
> -				sg_set_buf(&sg_src[2], input + j, total_len - j);
> +				if (i)
> +					sg_set_buf(&sg_src[k++], input, i);
> +				if (j - i)
> +					sg_set_buf(&sg_src[k++], input + i, j - i);
> +				if (total_len - j)
> +					sg_set_buf(&sg_src[k++], input + j, total_len - j);
> +				sg_init_marker(sg_src, k);
>  				memset(computed_output, 0, total_len);
>  				memset(input, 0, total_len);

So with this test fix, does this test find the bug?

Apparently the empty scatterlist elements caused some problem?  What was
that problem exactly?  And what do you mean by this "prevented the test
from running on arm64"?  If there is a problem it seems we should
something else about about it, e.g. debug checks that work in consistent
way on all architectures, documenting what the function expects, or make
it just work properly with empty scatterlist elements.

- Eric
