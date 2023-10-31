Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9C7C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Oct 2023 04:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjJaEMK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 00:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjJaEMK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 00:12:10 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCC7C0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 21:12:05 -0700 (PDT)
Received: from kwepemm000013.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SKGq31cZRz1P7cB;
        Tue, 31 Oct 2023 12:09:03 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm000013.china.huawei.com (7.193.23.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 31 Oct 2023 12:12:02 +0800
Subject: Re: [PATCH] ubifs: use crypto_shash_tfm_digest() in ubifs_hmac_wkm()
To:     Eric Biggers <ebiggers@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        <linux-mtd@lists.infradead.org>
CC:     <linux-crypto@vger.kernel.org>
References: <20231029050355.154989-1-ebiggers@kernel.org>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <1811bc93-cf3f-460f-cadf-3cca7537bd53@huawei.com>
Date:   Tue, 31 Oct 2023 12:11:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20231029050355.154989-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000013.china.huawei.com (7.193.23.81)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ÔÚ 2023/10/29 13:03, Eric Biggers Ð´µÀ:
> From: Eric Biggers <ebiggers@google.com>
>
> Simplify ubifs_hmac_wkm() by using crypto_shash_tfm_digest() instead of
> an alloc+init+update+final sequence.  This should also improve
> performance.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   fs/ubifs/auth.c | 19 ++-----------------
>   1 file changed, 2 insertions(+), 17 deletions(-)

Tested-by: Zhihao Cheng <chengzhihao1@huawei.com>

Time cost of ubifs_hmac_wkm(unit: us):

Before: 381~1634

After:278~1539

>
> diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
> index e564d5ff8781..4add4a4f0720 100644
> --- a/fs/ubifs/auth.c
> +++ b/fs/ubifs/auth.c
> @@ -501,42 +501,27 @@ int __ubifs_shash_copy_state(const struct ubifs_info *c, struct shash_desc *src,
>    *
>    * This function creates a HMAC of a well known message. This is used
>    * to check if the provided key is suitable to authenticate a UBIFS
>    * image. This is only a convenience to the user to provide a better
>    * error message when the wrong key is provided.
>    *
>    * This function returns 0 for success or a negative error code otherwise.
>    */
>   int ubifs_hmac_wkm(struct ubifs_info *c, u8 *hmac)
>   {
> -	SHASH_DESC_ON_STACK(shash, c->hmac_tfm);
> -	int err;
>   	const char well_known_message[] = "UBIFS";
>   
>   	if (!ubifs_authenticated(c))
>   		return 0;
>   
> -	shash->tfm = c->hmac_tfm;
> -
> -	err = crypto_shash_init(shash);
> -	if (err)
> -		return err;
> -
> -	err = crypto_shash_update(shash, well_known_message,
> -				  sizeof(well_known_message) - 1);
> -	if (err < 0)
> -		return err;
> -
> -	err = crypto_shash_final(shash, hmac);
> -	if (err)
> -		return err;
> -	return 0;
> +	return crypto_shash_tfm_digest(c->hmac_tfm, well_known_message,
> +				       sizeof(well_known_message) - 1, hmac);
>   }
>   
>   /*
>    * ubifs_hmac_zero - test if a HMAC is zero
>    * @c: UBIFS file-system description object
>    * @hmac: the HMAC to test
>    *
>    * This function tests if a HMAC is zero and returns true if it is
>    * and false otherwise.
>    */
>
> base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e


