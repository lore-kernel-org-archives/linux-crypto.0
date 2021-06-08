Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C94C47082
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 02:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA1E6124C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 02:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhFHCqP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:46:15 -0400
Received: from gw.atmark-techno.com ([13.115.124.170]:56430 "EHLO
        gw.atmark-techno.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFHCqO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jun 2021 22:46:14 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2021 22:46:14 EDT
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 03000800BD
        for <linux-crypto@vger.kernel.org>; Tue,  8 Jun 2021 11:35:22 +0900 (JST)
Received: by mail-pl1-f199.google.com with SMTP id 31-20020a1709020022b02900eeddd708c8so9008018pla.11
        for <linux-crypto@vger.kernel.org>; Mon, 07 Jun 2021 19:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JT31p1ca8pgh5l0QaXINbe3tri/dpwj61zppPFhJm4E=;
        b=ZvUOTg5fnSOT8ZNPT/ONjYikQq7aw6GkV8BTJdL7b60uCcdgYrmleiwz2hV4pMSSvM
         7rGN5IyjQb+MlAzgSHJum4TgwVkQdOT+2JkYyCi4xfzUCiz9DJl34KveDrZu/T7X66Y2
         n2KhOCfxYfPi5dnPBsHOJJLCjoGPjjlFDfWVA7JNoYzoSooEAu8naGIbvoAlRIb2pWYB
         CbhWacJOtXo9btp1XNqwaGTvMgZV/VjkydshuZYzhNXsl1lN5wKeB2EBJ12uy1AWEznk
         gqrRbCtm5LeKs8xeVGGG24o9HXY6MeaZpMN3Gb6M3kxtjwo0K42pv9RLY6/NezyvYtQY
         yvBA==
X-Gm-Message-State: AOAM533Hx06xZrPDl9zlGRvB+lawmN3GILY1L51XMooDJCXzBd/0oD/+
        ES9bWNwmxX1CKvvwD/KkwRATDPQAYp+Mni9GyqonI9ZXOc6A4/un+DO61jko/e4ZOYlf5h0WARH
        39zn3A1xpHBGvZ2mt/xSUgYSFWInq
X-Received: by 2002:a63:4b18:: with SMTP id y24mr20471819pga.438.1623119721101;
        Mon, 07 Jun 2021 19:35:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjuuaAPz9mNpOHbgkNdLeGmigjHU2ser0YtxZY9wU5GgthrW3/tAFdM+FQVhF+lXsXcyIw3Q==
X-Received: by 2002:a63:4b18:: with SMTP id y24mr20471791pga.438.1623119720760;
        Mon, 07 Jun 2021 19:35:20 -0700 (PDT)
Received: from pc-0115 (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id h16sm9383147pfk.119.2021.06.07.19.35.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jun 2021 19:35:20 -0700 (PDT)
Received: from martinet by pc-0115 with local (Exim 4.94.2)
        (envelope-from <martinet@pc-0115>)
        id 1lqRaI-005t6V-NT; Tue, 08 Jun 2021 11:35:18 +0900
Date:   Tue, 8 Jun 2021 11:35:08 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>,
        "Lukas F. Hartmann" <lukas@mntmn.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <YL7XXNOnbaDgmTB9@atmark-techno.com>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I'm not able to find any individual mails for Christoph's patches so
replying to the PR.

In particular, this commit:
Konrad Rzeszutek Wilk wrote on Fri, Feb 26, 2021 at 11:00:08AM -0500:
> Christoph Hellwig (8):
>       swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single

merged as 16fc3cef33a0, breaks caam as used today (thanks Lukas for
bisecting it!)


More precisely, drivers/crypto/caam/caamalg.c does a lot of mappings
that aren't aligned:

dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
                           desc_bytes(desc), ctx->dir);
dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
                           desc_bytes(desc), ctx->dir);


which can be caught by crypto tests with this caam enabled, for example
adding a warning when an unaligned mapping happens I get this trace:
--------
[ 1628.670226]  swiotlb_tbl_sync_single+0x74/0xa0
[ 1628.674677]  dma_sync_single_for_device+0xe4/0x110
[ 1628.679472]  skcipher_setkey+0xd0/0xf0
[ 1628.683224]  des3_skcipher_setkey+0x74/0xac
[ 1628.687416]  crypto_skcipher_setkey+0x54/0x110
[ 1628.691866]  crypto_authenc_setkey+0x94/0xd0
[ 1628.696138]  crypto_aead_setkey+0x34/0x10c
[ 1628.700236]  test_aead_vec_cfg+0x3a0/0x770
[ 1628.704338]  test_aead+0xac/0x130
[ 1628.707656]  alg_test_aead+0xa8/0x190
[ 1628.711324]  alg_test.part.0+0xf4/0x41c
[ 1628.715161]  alg_test+0x1c/0x60
[ 1628.718307]  do_test+0x37ec/0x4c50
[ 1628.721709]  do_test+0x4bec/0x4c50
[ 1628.725114]  tcrypt_mod_init+0x54/0xac
[ 1628.728864]  do_one_initcall+0x4c/0x1b0
[ 1628.732701]  kernel_init_freeable+0x1d0/0x234
[ 1628.737060]  kernel_init+0x10/0x114
[ 1628.740550]  ret_from_fork+0x10/0x24
-----

and the tests themselves also fail (all or at least most of them) with
e.g.
------
[    8.454233] caam_jr 30901000.jr: 40001713: DECO: desc idx 23: Header Error. Invalid length or parity, or certain other problems.
[    8.465820] alg: ahash: hmac-sha256-caam final() failed with err -22 on test vector 0, cfg="init+update+final aligned buffer"
[    8.477149] ------------[ cut here ]------------
[    8.481781] alg: self-tests for hmac-sha256-caam (hmac(sha256)) failed (rc=-22)
[    8.481818] WARNING: CPU: 2 PID: 295 at crypto/testmgr.c:5645 alg_test.part.0+0x128/0x41c
[    8.497307] Modules linked in:
[    8.500365] CPU: 2 PID: 295 Comm: cryptomgr_test Tainted: G        W         5.13.0-rc5-00002-gc98cdee6172e #23
[    8.510455] Hardware name: NXP i.MX8MPlus EVK board (DT)
[    8.515767] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[    8.521778] pc : alg_test.part.0+0x128/0x41c
[    8.526050] lr : alg_test.part.0+0x128/0x41c
[    8.530324] sp : ffff80001371bd10
[    8.533637] x29: ffff80001371bd10 x28: 000000000000008f x27: 000000000000008f
[    8.540785] x26: 000000000000008f x25: 0000000000000400 x24: ffff8000111658c8
[    8.547930] x23: ffff0000c02aaa80 x22: 000000000001008f x21: ffff0000c02aaa00
[    8.555075] x20: 0000000000000085 x19: 00000000ffffffea x18: 00000000fffffffc
[    8.562221] x17: 0000000000000001 x16: 0000000000000003 x15: 0000000000000020
[    8.569365] x14: ffffffffffffffff x13: 00000000000003e7 x12: ffff80001371b9e0
[    8.576511] x11: ffff80001188c940 x10: ffff800011844300 x9 : ffff800011886b98
[    8.583658] x8 : ffff80001182eb98 x7 : ffff800011886b98 x6 : ffffffffffff0888
[    8.590801] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
[    8.597945] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c1684e00
[    8.605093] Call trace:
[    8.607540]  alg_test.part.0+0x128/0x41c
[    8.611467]  alg_test+0x1c/0x60
[    8.614608]  cryptomgr_test+0x28/0x50
[    8.618275]  kthread+0x154/0x160
[    8.621511]  ret_from_fork+0x10/0x24
[    8.625088] ---[ end trace 2d195377ee3c219e ]---
------



Looking at it a bit further it seems to me that swiotlb_bounce() should
either keep the offset (re-adding the line that was removed except it
would go back in swiotlb_bounce, diff at end of mail), or the size
should be adjusted to cover from the start of the page up until the
original offset + size which would also probably work (not tested)

That, or make unaligned mappings forbidden and warn when we see one, but
I have no idea what other component could be doing some -- I'm not sure
if what the caam code does it legitimate (e.g. would it be possible to
do the mappings once at init and use them?), but the swiotlb code
doesn't look quite right.


For now I'll just revert this locally but there must have been a reason
the adjustment got removed in the first place, what's the best way
forward?





--- (for 5.13-rc1+)
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8ca7d505d61c..3acdd77edfed 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -349,6 +349,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
+	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	if (size > alloc_size) {
 		dev_WARN_ONCE(dev, 1,
---

Thanks,
-- 
Dominique
