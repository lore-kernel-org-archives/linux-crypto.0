Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCAAC3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 15:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926F02073F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 15:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="px5h+HqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfH2Pct (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:32:49 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:53924 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2Pct (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 11:32:49 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46K67K4GkTzB09Zd;
        Thu, 29 Aug 2019 17:32:45 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=px5h+HqN; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 62p04wlpeZ_B; Thu, 29 Aug 2019 17:32:45 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46K67K350czB09Zc;
        Thu, 29 Aug 2019 17:32:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1567092765; bh=inLRHSYdeswudIassqlB1giOtBbD3jCpbhs1IAAAaB4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=px5h+HqN8E4nvzuhvJOFy21xelMHFBC2vXdOsZADp/BglnMon4akhKe4KcwxFo3VK
         kER78wRfz4aoykiKRlIpFQeInHutTZ8CFYpm0BbtRMg7fLOwodDAGGJElpfEDBSRjj
         WnftFNPcHVvgp4htjaOREYZG2StRS1FI7/eWJagg=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0FB658B8CB;
        Thu, 29 Aug 2019 17:32:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 4AcsCRfvUMpO; Thu, 29 Aug 2019 17:32:46 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A0D2E8B8C1;
        Thu, 29 Aug 2019 17:32:46 +0200 (CEST)
Subject: Re: [PATCH v2 13/15] crypto: testmgr - convert hash testing to use
 testvec_configs
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org
References: <20190201075150.18644-1-ebiggers@kernel.org>
 <20190201075150.18644-14-ebiggers@kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e1ce6e9f-dc20-79bc-cd53-faff92481f7a@c-s.fr>
Date:   Thu, 29 Aug 2019 17:32:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190201075150.18644-14-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,


Le 01/02/2019 à 08:51, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> Convert alg_test_hash() to use the new test framework, adding a list of
> testvec_configs to test by default.  When the extra self-tests are
> enabled, randomly generated testvec_configs are tested as well.
> 
> This improves hash test coverage mainly because now all algorithms have
> a variety of data layouts tested, whereas before each algorithm was
> responsible for declaring its own chunked test cases which were often
> missing or provided poor test coverage.  The new code also tests both
> the MAY_SLEEP and !MAY_SLEEP cases and buffers that cross pages.
> 
> This already found bugs in the hash walk code and in the arm32 and arm64
> implementations of crct10dif.
> 
> I removed the hash chunked test vectors that were the same as
> non-chunked ones, but left the ones that were unique.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   crypto/testmgr.c | 795 ++++++++++++++++++++---------------------------
>   crypto/testmgr.h | 107 +------
>   2 files changed, 352 insertions(+), 550 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 7638090ff1b0a..96aa268ff4184 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c

[...]


> -static int __test_hash(struct crypto_ahash *tfm,
> -		       const struct hash_testvec *template, unsigned int tcount,
> -		       enum hash_test test_type, const int align_offset)
> +static int test_hash_vec_cfg(const char *driver,
> +			     const struct hash_testvec *vec,
> +			     unsigned int vec_num,
> +			     const struct testvec_config *cfg,
> +			     struct ahash_request *req,
> +			     struct test_sglist *tsgl,
> +			     u8 *hashstate)
>   {
> -	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
> -	size_t digest_size = crypto_ahash_digestsize(tfm);
> -	unsigned int i, j, k, temp;
> -	struct scatterlist sg[8];
> -	char *result;
> -	char *key;
> -	struct ahash_request *req;
> -	struct crypto_wait wait;
> -	void *hash_buff;
> -	char *xbuf[XBUFSIZE];
> -	int ret = -ENOMEM;
> -
> -	result = kmalloc(digest_size, GFP_KERNEL);
> -	if (!result)
> -		return ret;
> -	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
> -	if (!key)
> -		goto out_nobuf;
> -	if (testmgr_alloc_buf(xbuf))
> -		goto out_nobuf;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
> +	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
> +	const unsigned int statesize = crypto_ahash_statesize(tfm);
> +	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
> +	const struct test_sg_division *divs[XBUFSIZE];
> +	DECLARE_CRYPTO_WAIT(wait);
> +	struct kvec _input;
> +	struct iov_iter input;
> +	unsigned int i;
> +	struct scatterlist *pending_sgl;
> +	unsigned int pending_len;
> +	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];

Before this patch, result was allocated with kmalloc().
Now, result is in the stack. Is there a reason for this change ?

Due to this change, the talitos driver fails when using 
CONFIG_VMAP_STACK, because result is not dma-able anymore.

CONFIG_DEBUG_VIRTUAL warns on:

[    4.276401] WARNING: CPU: 0 PID: 72 at 
./arch/powerpc/include/asm/io.h:804 dma_direct_map_page+0x50/0x178
[    4.285725] CPU: 0 PID: 72 Comm: cryptomgr_test Tainted: G        W 
       5.3.0-rc6-s3k-dev-00897-g03e8e9014403-dirty #2182
	[snip registers]
[    4.353542] NIP [c0066eac] dma_direct_map_page+0x50/0x178
[    4.358872] LR [c0066eac] dma_direct_map_page+0x50/0x178
[    4.364074] Call Trace:
[    4.366533] [c9d0fc18] [c0066eac] dma_direct_map_page+0x50/0x178 
(unreliable)
[    4.373587] [c9d0fc38] [c033ac38] __map_single_talitos_ptr+0x54/0x9c
[    4.379869] [c9d0fc48] [c033e878] ahash_process_req+0x318/0x7a8
[    4.385739] [c9d0fca8] [c0210b68] do_ahash_op.isra.0+0x24/0x70
[    4.391494] [c9d0fcb8] [c02130e8] test_ahash_vec_cfg+0x478/0x5a8
[    4.397432] [c9d0fda8] [c0213b40] __alg_test_hash.isra.13+0x16c/0x334
[    4.403797] [c9d0fe08] [c0213d84] alg_test_hash+0x7c/0x164
[    4.409218] [c9d0fe28] [c0213f88] alg_test+0xc0/0x384
[    4.414209] [c9d0fef8] [c020f0ec] cryptomgr_test+0x48/0x50
[    4.419623] [c9d0ff08] [c003a818] kthread+0xe0/0x10c
[    4.424539] [c9d0ff38] [c000e1d0] ret_from_kernel_thread+0x14/0x1c

How should this be fixed ?

Christophe

