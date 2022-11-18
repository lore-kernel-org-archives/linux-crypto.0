Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3EBC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 20:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKRUKi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 15:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiKRUKc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 15:10:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AB21825
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 12:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30387B82519
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 20:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99655C433D6;
        Fri, 18 Nov 2022 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668802228;
        bh=g15ZgYIyqqNcWivqUSAPRmX9RwX9KtdnWWwsroGLpB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dY0poglitAuL6oX65nW17ZRSUcrUf7Lh2egtvRB17q91ikFzAeCqKYD5teJ5h7vHS
         AH4Pmu8RrJFTU5FW9mh0RwvwNia5IlP7yNNe5sYwzzikYxmxC7UvS2fx7Ozlca49Yi
         VL8FQh6hIO8gMcInwprkXZqVKQo7n6QpXuV3B2YN0SGIy9V+pT1N1xojrVX6Yslsz9
         /j/WW0sM2KCTeFYBtbweciYvctODMylX859uyyMkcZHklZ5W1id3nrvoXDQOq3zYne
         I7ea8j1kTiKGMel9AGiYe/DQ79fa4sAE1NAMwgE8jY/mWEp2A3diQ1t3VUkiC10KDs
         5LG67XzlYRnMg==
Date:   Fri, 18 Nov 2022 12:10:26 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
Message-ID: <Y3fmskgfAb/xxzpS@sol.localdomain>
References: <20221118194421.160414-1-ebiggers@kernel.org>
 <20221118194421.160414-9-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118194421.160414-9-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 11:44:17AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> sm4_aesni_avx_ctr_enc_blk8(), sm4_aesni_avx_cbc_dec_blk8(),
> sm4_aesni_avx_cfb_dec_blk8(), sm4_aesni_avx2_ctr_enc_blk16(),
> sm4_aesni_avx2_cbc_dec_blk16(), and sm4_aesni_avx2_cfb_dec_blk16() are
> called via indirect function calls.  Therefore they need to use
> SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
> hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
> Otherwise, the code crashes with a CFI failure.
> 
> (Or at least that should be the case.  For some reason the CFI checks in
> sm4_avx_cbc_decrypt(), sm4_avx_cfb_decrypt(), and sm4_avx_ctr_crypt()
> are not always being generated, using current tip-of-tree clang.
> Anyway, this patch is a good idea anyway.)

Sami, is it expected that a CFI check isn't being generated for the indirect
call to 'func' in sm4_avx_cbc_decrypt()?  I'm using LLVM commit 4a7be42d922af0.

- Eric
