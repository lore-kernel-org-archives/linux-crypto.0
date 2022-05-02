Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6392C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 18:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbiEBSPF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 14:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbiEBSPF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 14:15:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467ADF2C
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 11:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB8166144D
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 18:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D703FC385AF;
        Mon,  2 May 2022 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651515094;
        bh=zzrXkz9pG9pqxiWh52xFbya/y73Z84xkuk20846MbhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RNw9zzBf2LscPWVecm8dJYV91hgvntZDW/ZEM7cWrvM8NFvCu+59+ys9EYMubhH0k
         HanKFcFhoioip2QeMDfl7Iz4Hj/ur5ee5CP13X6aqkTnktn0NGDijHhVcPKgi+BU0g
         EZ4iWqmT1AijJXGIsvb1cMsxWWf3ijvMplWr5L2k8dyhNA0HqT6BC+rV+yqobBusnj
         9sm1Gx+aayW93isjbHSpunRNHDxna023sUC1OiqW5XTXvR84mXgt2fP99eTiEj1oCY
         vvJi08JtTjYSSopfEQkWwxK2GZyp/ohzmEsktcsvvJvgo9N9/IXTsAsaSy3E8oYmpb
         Jd8OTnonv5SCQ==
Date:   Mon, 2 May 2022 11:11:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 7/8] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YnAe1DTtpLDUPwSc@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-8-nhuck@google.com>
 <Ym7r1vt4G1xX58Kv@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym7r1vt4G1xX58Kv@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 01, 2022 at 01:21:52PM -0700, Eric Biggers wrote:
> > +static int polyval_arm64_update(struct shash_desc *desc,
> > +			 const u8 *src, unsigned int srclen)
> > +{
> > +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> > +	struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> > +	u8 *pos;
> > +	unsigned int nblocks;
> > +	unsigned int n;
> > +
> > +	if (dctx->bytes) {
> > +		n = min(srclen, dctx->bytes);
> > +		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - dctx->bytes;
> > +
> > +		dctx->bytes -= n;
> > +		srclen -= n;
> > +
> > +		while (n--)
> > +			*pos++ ^= *src++;
> > +
> > +		if (!dctx->bytes)
> > +			internal_polyval_mul(dctx->buffer,
> > +				ctx->key_powers[NUM_KEY_POWERS-1]);
> > +	}
> > +
> > +	nblocks = srclen/POLYVAL_BLOCK_SIZE;
> > +	internal_polyval_update(ctx, src, nblocks, dctx->buffer);
> > +	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
> 
> This is executing a kernel_neon_begin()/kernel_neon_end() section of unbounded
> length.  To allow the task to be preempted occasionally, it needs to handle the
> input in chunks, e.g. 4K at a time, like the existing code for other algorithms
> does.  Something like the following would work:
> 
> @@ -122,13 +118,16 @@ static int polyval_arm64_update(struct shash_desc *desc,
>  				ctx->key_powers[NUM_KEY_POWERS-1]);
>  	}
>  
> -	nblocks = srclen/POLYVAL_BLOCK_SIZE;
> -	internal_polyval_update(ctx, src, nblocks, dctx->buffer);
> -	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
> +	while (srclen >= POLYVAL_BLOCK_SIZE) {
> +		/* Allow rescheduling every 4K bytes. */
> +		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
> +		internal_polyval_update(ctx, src, nblocks, dctx->buffer);
> +		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
> +		src += nblocks * POLYVAL_BLOCK_SIZE;
> +	}
>  
>  	if (srclen) {
>  		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
> -		src += nblocks*POLYVAL_BLOCK_SIZE;
>  		pos = dctx->buffer;
>  		while (srclen--)
>  			*pos++ ^= *src++;
> 

Also to be clear, this problem is specific to the "shash" API.  You don't need
to worry about it for "skcipher" algorithms such as xctr(*), as they have to
walk a scatterlist to get their data, and that happens a page at a time.

- Eric
