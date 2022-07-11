Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D1FC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jul 2022 13:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiGKNfF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jul 2022 09:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGKNfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jul 2022 09:35:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6AB31924
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2022 06:35:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LhPxC14pTzFq05;
        Mon, 11 Jul 2022 21:34:07 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 21:35:00 +0800
Message-ID: <65952163-6b78-a02a-ba14-933807d3cfec@huawei.com>
Date:   Mon, 11 Jul 2022 21:34:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   "Guozihua (Scott)" <guozihua@huawei.com>
To:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <catalin.marinas@arm.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <zengxianjun3@huawei.com>,
        <yunjia.wang@huawei.com>
Subject: An inquire about a read out-of-bound found in poly1305-neon
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi community,

Syzkaller reported the following bug while fuzzing poly1305-neon:

BUG: KASAN: slab-out-of-bounds in 
neon_poly1305_blocks.constprop.0+0x1b4/0x250 [poly1305_neon]
Read of size 4 at addr ffff0010e293f010 by task syz-executor.5/1646715
CPU: 4 PID: 1646715 Comm: syz-executor.5 Kdump: loaded Not tainted 
5.10.0.aarch64 #1
Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.59 01/31/2019
Call trace:
  dump_backtrace+0x0/0x394
  show_stack+0x34/0x4c arch/arm64/kernel/stacktrace.c:196
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x158/0x1e4 lib/dump_stack.c:118
  print_address_description.constprop.0+0x68/0x204 mm/kasan/report.c:387
  __kasan_report+0xe0/0x140 mm/kasan/report.c:547
  kasan_report+0x44/0xe0 mm/kasan/report.c:564
  check_memory_region_inline mm/kasan/generic.c:187 [inline]
  __asan_load4+0x94/0xd0 mm/kasan/generic.c:252
  neon_poly1305_blocks.constprop.0+0x1b4/0x250 [poly1305_neon]
  neon_poly1305_do_update+0x6c/0x15c [poly1305_neon]
  neon_poly1305_update+0x9c/0x1c4 [poly1305_neon]
  crypto_shash_update crypto/shash.c:131 [inline]
  shash_finup_unaligned+0x84/0x15c crypto/shash.c:179
  crypto_shash_finup+0x8c/0x140 crypto/shash.c:193
  shash_digest_unaligned+0xb8/0xe4 crypto/shash.c:201
  crypto_shash_digest+0xa4/0xfc crypto/shash.c:217
  crypto_shash_tfm_digest+0xb4/0x150 crypto/shash.c:229
  essiv_skcipher_setkey+0x164/0x200 [essiv]
  crypto_skcipher_setkey+0xb0/0x160 crypto/skcipher.c:612
  skcipher_setkey+0x3c/0x50 crypto/algif_skcipher.c:305
  alg_setkey+0x114/0x2a0 crypto/af_alg.c:220
  alg_setsockopt+0x19c/0x210 crypto/af_alg.c:253
  __sys_setsockopt+0x190/0x2e0 net/socket.c:2123
  __do_sys_setsockopt net/socket.c:2134 [inline]
  __se_sys_setsockopt net/socket.c:2131 [inline]
  __arm64_sys_setsockopt+0x78/0x94 net/socket.c:2131
  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
  invoke_syscall+0x64/0x100 arch/arm64/kernel/syscall.c:48
  el0_svc_common.constprop.0+0x220/0x230 arch/arm64/kernel/syscall.c:155
  do_el0_svc+0xb4/0xd4 arch/arm64/kernel/syscall.c:217
  el0_svc+0x24/0x3c arch/arm64/kernel/entry-common.c:353
  el0_sync_handler+0x160/0x164 arch/arm64/kernel/entry-common.c:369
  el0_sync+0x160/0x180 arch/arm64/kernel/entry.S:683
Allocated by task 1646715:
  kasan_save_stack+0x28/0x60 mm/kasan/common.c:48
  kasan_set_track mm/kasan/common.c:56 [inline]
  __kasan_kmalloc.constprop.0+0xc8/0xf0 mm/kasan/common.c:479
  kasan_kmalloc+0x10/0x20 mm/kasan/common.c:493
  __kmalloc+0x33c/0x734 mm/slub.c:4022
  kmalloc ./include/linux/slab.h:568 [inline]
  sock_kmalloc.part.0+0xe4/0x130 net/core/sock.c:2247
  sock_kmalloc+0x50/0x90 net/core/sock.c:2240
  alg_setkey+0xac/0x2a0 crypto/af_alg.c:212
  alg_setsockopt+0x19c/0x210 crypto/af_alg.c:253
  __sys_setsockopt+0x190/0x2e0 net/socket.c:2123
  __do_sys_setsockopt net/socket.c:2134 [inline]
  __se_sys_setsockopt net/socket.c:2131 [inline]
  __arm64_sys_setsockopt+0x78/0x94 net/socket.c:2131
  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
  invoke_syscall+0x64/0x100 arch/arm64/kernel/syscall.c:48
  el0_svc_common.constprop.0+0x220/0x230 arch/arm64/kernel/syscall.c:155
  do_el0_svc+0xb4/0xd4 arch/arm64/kernel/syscall.c:217
  el0_svc+0x24/0x3c arch/arm64/kernel/entry-common.c:353
  el0_sync_handler+0x160/0x164 arch/arm64/kernel/entry-common.c:369
  el0_sync+0x160/0x180 arch/arm64/kernel/entry.S:683

It seems that the error happens in poly1305_init_arch(), which take in a 
argument "key" as a fixed 32 bytes long array, while the caller, 
neon_poly1305_blocks(), is called when input data is longer the block 
size of poly1305 which is 16 bytes. No other checks are preformed to 
ensure the array size mentioned above which is passed into 
poly1305_init_arch().

  1 void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 
key[POLY1305_KEY_SIZE])
  2 {
  3 	poly1305_init_arm64(&dctx->h, key);
  4 	dctx->s[0] = get_unaligned_le32(key + 16);
  5 	dctx->s[1] = get_unaligned_le32(key + 20);
  6 	dctx->s[2] = get_unaligned_le32(key + 24);
  7 	dctx->s[3] = get_unaligned_le32(key + 28);
  8 	dctx->buflen = 0;
  9 }

  1 static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, 
const u8 *src,
  2 				 u32 len, u32 hibit, bool do_neon)
  3 {
  4 	if (unlikely(!dctx->sset)) {
  5 		if (!dctx->rset) {
  6 			poly1305_init_arch(dctx, src);
  7 			src += POLY1305_BLOCK_SIZE;
  8 			len -= POLY1305_BLOCK_SIZE;
  9 			dctx->rset = 1;
10 		}
11 		if (len >= POLY1305_BLOCK_SIZE) {
12 			dctx->s[0] = get_unaligned_le32(src +  0);
13 			dctx->s[1] = get_unaligned_le32(src +  4);
14 			dctx->s[2] = get_unaligned_le32(src +  8);
15 			dctx->s[3] = get_unaligned_le32(src + 12);
16 			src += POLY1305_BLOCK_SIZE;
17 			len -= POLY1305_BLOCK_SIZE;
18 			dctx->sset = true;
19 		}
20 		if (len < POLY1305_BLOCK_SIZE)
21 			return;
22 	}
23
24 	len &= ~(POLY1305_BLOCK_SIZE - 1);
25
26 	if (static_branch_likely(&have_neon) && likely(do_neon))
27 		poly1305_blocks_neon(&dctx->h, src, len, hibit);
28 	else
29 		poly1305_blocks(&dctx->h, src, len, hibit);
30 }

The logic neon_poly1305_blocks() performed seems to be that if it was 
called with both s[] and r[] uninitialized, it will first try to 
initialize them with the data from the first "block" that it believed to 
be 32 bytes in length. First 16 bytes are used as the key and the next 
16 bytes for s[]. This would lead to the aforementioned read 
out-of-bound. However, calling poly1305_init_arch(), it deduct 16 bytes 
from the input and then check whether there are another 16 bytes of data 
remained, and use those 16 bytes for initializing s[] again.

This seems to be faulty to me that 1. s[] should not be initialized for 
2 times, and 2. poly1305_init_arch() takes in and processed 32 bytes but 
only 16 bytes were deducted from the input.

To fix this, I tried adding checks before calling poly1305_init_arch() 
ensuring the key is not shorter than 32 bytes, but that would cause the 
self-test to fail. Directly calling poly1305_init_arm64 instead of 
poly1305_init_arch() is also tried but it would fail the self-test as well.

Does the community has any suggestion on fixing this BUG?

One more thing I noticed is that poly1305 never appears on it's own. I 
checked the two articles mentioning poly1305 and it seems that it's used 
with chacha20 or AES. Is this statement valid?

Thanks in advance.

-- 
Best
GUO Zihua
