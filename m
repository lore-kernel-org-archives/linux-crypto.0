Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFE3C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 08:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiGSIEB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiGSIEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 04:04:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7B12870A
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 01:03:58 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LnB9Q4Qtxz1M88g;
        Tue, 19 Jul 2022 16:01:14 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 16:03:27 +0800
Message-ID: <a35d8eab-8f74-51aa-2c2b-41a32e616315@huawei.com>
Date:   Tue, 19 Jul 2022 16:03:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] arm64/crypto: poly1305 fix a read out-of-bound
Content-Language: en-US
From:   "Guozihua (Scott)" <guozihua@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <ebiggers@kernel.org>, <ardb@kernel.org>
References: <20220712075031.29061-1-guozihua@huawei.com>
In-Reply-To: <20220712075031.29061-1-guozihua@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/7/12 15:50, GUO Zihua wrote:
> A kasan error was reported during fuzzing:
> 
> BUG: KASAN: slab-out-of-bounds in neon_poly1305_blocks.constprop.0+0x1b4/0x250 [poly1305_neon]
> Read of size 4 at addr ffff0010e293f010 by task syz-executor.5/1646715
> CPU: 4 PID: 1646715 Comm: syz-executor.5 Kdump: loaded Not tainted 5.10.0.aarch64 #1
> Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.59 01/31/2019
> Call trace:
>   dump_backtrace+0x0/0x394
>   show_stack+0x34/0x4c arch/arm64/kernel/stacktrace.c:196
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x158/0x1e4 lib/dump_stack.c:118
>   print_address_description.constprop.0+0x68/0x204 mm/kasan/report.c:387
>   __kasan_report+0xe0/0x140 mm/kasan/report.c:547
>   kasan_report+0x44/0xe0 mm/kasan/report.c:564
>   check_memory_region_inline mm/kasan/generic.c:187 [inline]
>   __asan_load4+0x94/0xd0 mm/kasan/generic.c:252
>   neon_poly1305_blocks.constprop.0+0x1b4/0x250 [poly1305_neon]
>   neon_poly1305_do_update+0x6c/0x15c [poly1305_neon]
>   neon_poly1305_update+0x9c/0x1c4 [poly1305_neon]
>   crypto_shash_update crypto/shash.c:131 [inline]
>   shash_finup_unaligned+0x84/0x15c crypto/shash.c:179
>   crypto_shash_finup+0x8c/0x140 crypto/shash.c:193
>   shash_digest_unaligned+0xb8/0xe4 crypto/shash.c:201
>   crypto_shash_digest+0xa4/0xfc crypto/shash.c:217
>   crypto_shash_tfm_digest+0xb4/0x150 crypto/shash.c:229
>   essiv_skcipher_setkey+0x164/0x200 [essiv]
>   crypto_skcipher_setkey+0xb0/0x160 crypto/skcipher.c:612
>   skcipher_setkey+0x3c/0x50 crypto/algif_skcipher.c:305
>   alg_setkey+0x114/0x2a0 crypto/af_alg.c:220
>   alg_setsockopt+0x19c/0x210 crypto/af_alg.c:253
>   __sys_setsockopt+0x190/0x2e0 net/socket.c:2123
>   __do_sys_setsockopt net/socket.c:2134 [inline]
>   __se_sys_setsockopt net/socket.c:2131 [inline]
>   __arm64_sys_setsockopt+0x78/0x94 net/socket.c:2131
>   __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>   invoke_syscall+0x64/0x100 arch/arm64/kernel/syscall.c:48
>   el0_svc_common.constprop.0+0x220/0x230 arch/arm64/kernel/syscall.c:155
>   do_el0_svc+0xb4/0xd4 arch/arm64/kernel/syscall.c:217
>   el0_svc+0x24/0x3c arch/arm64/kernel/entry-common.c:353
>   el0_sync_handler+0x160/0x164 arch/arm64/kernel/entry-common.c:369
>   el0_sync+0x160/0x180 arch/arm64/kernel/entry.S:683
> 
> This error can be reproduced by the following code compiled as ko on a
> system with kasan enabled:
> 
> char test_data[] = "\x00\x01\x02\x03\x04\x05\x06\x07"
> 		   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> 		   "\x10\x11\x12\x13\x14\x15\x16\x17"
> 		   "\x18\x19\x1a\x1b\x1c\x1d\x1e";
> 
> int init(void)
> {
> 	struct crypto_shash *tfm = NULL;
> 	struct shash_desc *desc = NULL;
> 	char *data = NULL;
> 
> 	tfm = crypto_alloc_shash("poly1305", 0, 0);
> 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
> 	desc->tfm = tfm;
> 
> 	data = kmalloc(POLY1305_KEY_SIZE - 1, GFP_KERNEL);
> 	memcpy(data, test_data, POLY1305_KEY_SIZE - 1);
> 	crypto_shash_update(desc, data, POLY1305_KEY_SIZE - 1);
> 	crypto_shash_final(desc, data);
> 	kfree(data);
> 	return 0;
> }
> 
> void deinit(void)
> {
> }
> 
> module_init(init)
> module_exit(deinit)
> MODULE_LICENSE("GPL");
> 
> The root cause of the bug sits in neon_poly1305_blocks. The logic
> neon_poly1305_blocks() performed is that if it was called with both s[]
> and r[] uninitialized, it will first try to initialize them with the
> data from the first "block" that it believed to be 32 bytes in length.
> First 16 bytes are used as the key and the next 16 bytes for s[]. This
> would lead to the aforementioned read out-of-bound. However, after
> calling poly1305_init_arch(), only 16 bytes were deducted from the input
> and s[] is initialized yet again with the following 16 bytes. The second
> initialization of s[] is certainly redundent which indicates that the
> first initialization should be for r[] only.
> 
> This patch fixes the issue by calling poly1305_init_arm64() instead of
> poly1305_init_arch(). This is also the implementation for the same
> algorithm on arm platform.
> 
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: GUO Zihua <guozihua@huawei.com>
> ---
>   arch/arm64/crypto/poly1305-glue.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> index 9c3d86e397bf..1fae18ba11ed 100644
> --- a/arch/arm64/crypto/poly1305-glue.c
> +++ b/arch/arm64/crypto/poly1305-glue.c
> @@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
>   {
>   	if (unlikely(!dctx->sset)) {
>   		if (!dctx->rset) {
> -			poly1305_init_arch(dctx, src);
> +			poly1305_init_arm64(&dctx->h, src);
>   			src += POLY1305_BLOCK_SIZE;
>   			len -= POLY1305_BLOCK_SIZE;
>   			dctx->rset = 1;

Including Ard in the loop as they are the original uploader of this algo.

-- 
Best
GUO Zihua
