Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB271C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiLMTp1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiLMTp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2022 14:45:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EE0DFF6;
        Tue, 13 Dec 2022 11:45:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29836171D;
        Tue, 13 Dec 2022 19:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8EC433D2;
        Tue, 13 Dec 2022 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960725;
        bh=Rus8LKt6JC2vTsynj6VmjIXsVmtuWiGAxvSB33tcGtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FtnCt7NDom2YFBeiaXE07DgnEvo+e0z+9S42m7CDIRcmHqKGrsUyMH/yUuOQN7gCa
         bu/M4IALLygYoc+Tx2ovEk1nkkghHLG+S5k9RIZI71lx0nv11s9RawHc5Iv3gjDJML
         16uLLLO1WjeKBjCV1Gd+19LTqKZQNxvyN6iEIyoEOU6OdF495BwK9SRVT8dE5jzbOo
         HpvX014WRDFHwMbcFuMulVlQDT5rdoBZ8UcfWFjks3bohla5hDciiuK6y+Y3DBcrvm
         xjFvDppW4y0Dj19fs3ma16blEXCBDQtGqJ9ctpaxidhH3g964Mwksi16aSDeZL3IUE
         vFAhq+T+mO6Ww==
Date:   Tue, 13 Dec 2022 11:45:23 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Robert Elliott <elliott@hpe.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: arm/sha1 - Fix clang function cast warnings
Message-ID: <Y5jWUytRsZatKmCk@sol.localdomain>
References: <202211041904.f9S5gAGL-lkp@intel.com>
 <Y5FvChDBD/+uaFy8@gondor.apana.org.au>
 <CAMj1kXGkdp_cwOWeX_49Y5xTCH8Y7X-LnM8pJufCH3yw7anBWQ@mail.gmail.com>
 <Y5hXUlvSmHrP8PTN@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5hXUlvSmHrP8PTN@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 13, 2022 at 06:43:30PM +0800, Herbert Xu wrote:
> -asmlinkage void sha1_block_data_order(u32 *digest,
> -		const unsigned char *data, unsigned int rounds);
> +asmlinkage void sha1_block_data_order(struct sha1_state *digest,
> +		const u8 *data, int rounds);

The last parameter should be called 'blocks', not 'rounds'.

>  int sha1_update_arm(struct shash_desc *desc, const u8 *data,
>  		    unsigned int len)
>  {
> -	/* make sure casting to sha1_block_fn() is safe */
> +	/* make sure signature matches sha1_block_fn() */
>  	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);

The above comment doesn't really make sense, since making sure function
signatures match is the responsibility of the compiler.

A better comment would be:

	/* sha1_block_data_order() expects the actual state at the beginning. */

It would also be helpful to add a comment to the definition of struct
sha1_state, analogous to the comment in struct blake2s_state:

struct sha1_state {
	/* 'state' is used by assembly code, so keep it as-is. */
	u32 state[SHA1_DIGEST_SIZE / 4];

- Eric
