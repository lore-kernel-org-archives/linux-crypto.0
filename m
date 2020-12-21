Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4126C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 22:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F4A22A83
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 22:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgLUWCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Dec 2020 17:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgLUWCJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Dec 2020 17:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241D722A83;
        Mon, 21 Dec 2020 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608588088;
        bh=YRRPyKf8Lftmoy25LQ08I6W5DxDDr2G1YVAywJtCGM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+G1lm5O2Y4qTSzfPnrWDUDjo4iwnM8On3x0qdHiyVUEkLv7gEgrPqUUpyb2w7j9A
         R+SD45774ArcGAyyqO9h2aGemerIJe0FCdIrvdvDYk6/xp2yVcI30se9rfIk6qxppC
         lN0CBOz00BfaHNHi0bX2RD3L2sbyXbFFaywu/Ddx51eDEriy/BX5bsXew0aIszvzP5
         hNiXEDmkvNSGQtq0fOyYZK2VcBEjWP35zhLNfab6exZ2tzH0zWkd0AIROC2zriaqJI
         Q/Q4NLuM3QODFMYQcwRRLyT7cH7g0Fkv4LAWrwl6CrVAQ+PJxmZg/Y0T4U8jFV3xdM
         H+om5+ZUv+t5g==
Date:   Mon, 21 Dec 2020 14:01:26 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: gcm-aes-ni cleanups
Message-ID: <X+EbNj3HPZZ5ar1d@sol.localdomain>
References: <20201212091700.11776-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212091700.11776-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Sat, Dec 12, 2020 at 10:16:56AM +0100, Ard Biesheuvel wrote:
> Clean up some issues and peculiarities in the gcm(aes-ni) driver.
> 
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (4):
>   crypto: x86/gcm-aes-ni - prevent misaligned IV buffers on the stack
>   crypto: x86/gcm-aes-ni - drop unused asm prototypes
>   crypto: x86/gcm-aes-ni - clean up mapping of associated data
>   crypto: x86/gcm-aes-ni - refactor scatterlist processing
> 
>  arch/x86/crypto/aesni-intel_glue.c | 238 ++++++--------------
>  1 file changed, 74 insertions(+), 164 deletions(-)
> 

I get the following with this series applied:

BUG: sleeping function called from invalid context at mm/page_alloc.c:4934
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 426, name: cryptomgr_test
no locks held by cryptomgr_test/426.
CPU: 0 PID: 426 Comm: cryptomgr_test Not tainted 5.10.0-12509-g8cc543a98aac #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
Call Trace:
 show_stack+0x3d/0x3f arch/x86/kernel/dumpstack.c:318
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xa4/0xd9 lib/dump_stack.c:120
 ___might_sleep.cold+0x186/0x1b5 kernel/sched/core.c:7911
 __might_sleep+0xa1/0x1a0 kernel/sched/core.c:7865
 prepare_alloc_pages mm/page_alloc.c:4934 [inline]
 __alloc_pages_nodemask+0x46f/0x6b0 mm/page_alloc.c:4978
 alloc_pages_current+0x139/0x240 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 __get_free_pages+0x10/0xa0 mm/page_alloc.c:5031
 skcipher_walk_next+0x736/0xd30 crypto/skcipher.c:370
 skcipher_walk_first+0xc5/0x110 crypto/skcipher.c:445
 skcipher_walk_aead_common+0x7f2/0xbe0 crypto/skcipher.c:544
 skcipher_walk_aead_encrypt+0x6d/0xa0 crypto/skcipher.c:557
 gcmaes_crypt_by_sg+0x3e2/0x740 arch/x86/crypto/aesni-intel_glue.c:655
 gcmaes_encrypt+0xd2/0x260 arch/x86/crypto/aesni-intel_glue.c:694
 helper_rfc4106_encrypt+0x213/0x4d0 arch/x86/crypto/aesni-intel_glue.c:755
 crypto_aead_encrypt+0xf1/0x160 crypto/aead.c:94
 simd_aead_encrypt+0x186/0x270 crypto/simd.c:328
 crypto_aead_encrypt+0xf1/0x160 crypto/aead.c:94
 test_aead_vec_cfg+0x9e0/0x1980 crypto/testmgr.c:2012
 test_aead_vec+0x1e8/0x280 crypto/testmgr.c:2134
 test_aead crypto/testmgr.c:2539 [inline]
 alg_test_aead+0x1f7/0x410 crypto/testmgr.c:2585
 alg_test+0x3fc/0x840 crypto/testmgr.c:5660
 cryptomgr_test+0x5a/0x80 crypto/algboss.c:206
 kthread+0x366/0x440 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
