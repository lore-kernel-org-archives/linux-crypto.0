Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6909FECAAD4
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 02:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiH0CrC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 22:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiH0CrC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 22:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7DFDAEFD
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 19:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1C961DA7
        for <linux-crypto@vger.kernel.org>; Sat, 27 Aug 2022 02:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C57CC433D7;
        Sat, 27 Aug 2022 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568420;
        bh=mangj+vb++MHHsg3fBqTxBLD1WQuU4hbCztJTRbTXXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tjelDWY4pJhdzMICcDQcZxLm05dETc9pD+vCEqdAwnSVMAQQpgeFdlwMkOXcjhWdZ
         m3gyWGvC07sRAx0/f43a2nXssw+aMBNeH1wlbtJqiBqd2U704nL+GCzxDtnPT46eRt
         h5B/TGduBKpIki2S3/vkDP1vegDp/twUlxzlecKWl97sT/Tl62B0XrSVIDpyIY2h1g
         lLoG2LWYI+sJs3D3A+2p08GDrGqRV6QJfUcTUR23H18FkkLHNbPxVDm7pMSJyS/hR3
         /FPY2e5VEXfiZxnXnotM6RBEIGjgoZNDbNWdDT7D3QWzaTO7tqQTHg7mVi8C3uDz9/
         wfgAa+vNPOD8g==
Date:   Fri, 26 Aug 2022 19:46:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, elliott@hpe.com
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Message-ID: <YwmFouIyIlOMqKb4@sol.localdomain>
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826053131.24792-3-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 26, 2022 at 05:31:30AM +0000, Taehee Yoo wrote:
> +static struct skcipher_alg aria_algs[] = {
> +	{
> +		.base.cra_name		= "__ecb(aria)",
> +		.base.cra_driver_name	= "__ecb-aria-avx",
> +		.base.cra_priority	= 400,
> +		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
> +		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
> +		.base.cra_ctxsize	= sizeof(struct aria_ctx),
> +		.base.cra_module	= THIS_MODULE,
> +		.min_keysize		= ARIA_MIN_KEY_SIZE,
> +		.max_keysize		= ARIA_MAX_KEY_SIZE,
> +		.setkey			= aria_avx_set_key,
> +		.encrypt		= aria_avx_ecb_encrypt,
> +		.decrypt		= aria_avx_ecb_decrypt,
> +	}
> +};

Why do you want ECB mode and nothing else?  At
https://lore.kernel.org/r/51ce6519-9f03-81b6-78b0-43c313705e74@gmail.com
you claimed that the use case for ARIA support in the kernel is kTLS.

So you are using ECB mode in TLS?

- Eric
