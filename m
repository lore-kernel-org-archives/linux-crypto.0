Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5618C77B61
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 05:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjDYFl6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 01:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjDYFl6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 01:41:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F3D65BC;
        Mon, 24 Apr 2023 22:41:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1prBQr-001ztQ-9V; Tue, 25 Apr 2023 13:41:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Apr 2023 13:41:42 +0800
Date:   Tue, 25 Apr 2023 13:41:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Danny Tsen <dtsen@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH 2/5] Glue code for optmized Chacha20 implementation for
 ppc64le.
Message-ID: <ZEdoFv4tS69ELyNo@gondor.apana.org.au>
References: <20230424184726.2091-1-dtsen@linux.ibm.com>
 <20230424184726.2091-3-dtsen@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424184726.2091-3-dtsen@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 24, 2023 at 02:47:23PM -0400, Danny Tsen wrote:
>
> +static int chacha_p10_stream_xor(struct skcipher_request *req,
> +				 const struct chacha_ctx *ctx, const u8 *iv)
> +{
> +	struct skcipher_walk walk;
> +	u32 state[16];
> +	int err;
> +
> +	err = skcipher_walk_virt(&walk, req, false);
> +	if (err)
> +		return err;
> +
> +	chacha_init_generic(state, ctx->key, iv);
> +
> +	while (walk.nbytes > 0) {
> +		unsigned int nbytes = walk.nbytes;
> +
> +		if (nbytes < walk.total)
> +			nbytes = rounddown(nbytes, walk.stride);
> +
> +		if (!static_branch_likely(&have_p10) ||

You don't need the static branch in the Crypto API code since
the registration is already conditional.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
