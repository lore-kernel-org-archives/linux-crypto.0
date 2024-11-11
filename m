Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0481BC41
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 02:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731291739; cv=none; b=pcotWgqpAWxm2nKqkZO5zRKvCZy2t6kTpnK0K5LlZbmERJN7NxNFjViUixP/dUWp7sxlt7SG0dhWtGvKxTfrx9id18CmvDkqNT1osZ25USblZbKiMSCiCjrA7dyTZCrT8u0ZWYzHem1UGal6OTCQKvRbWPXb7Y3rlCaCpMm69nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731291739; c=relaxed/simple;
	bh=2wz6swNibd9UDMiudYiQwq6i0ztpOKGoxW7/khEU8dA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l3sxZ5j8P5f+cmCJRgRrFzFY5JWpLpIQ5ANwfsj3hukk7+QGELdVdptaou2V2bVVZxDSGH9OfbtAb0J9NCX+WIfE41AtyRj6HJ1sp5wP//czRiRGAVws//gYQialdLJBRixFMDSvjKEQ5gAXfYoWHmVaf7N6L3IZ2XInz3b/VgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XmtbJ4Vqjz4f3jY4
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 10:21:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C26A21A058E
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 10:22:06 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP2 (Coremail) with SMTP id Syh0CgBXuORNajFnzjS+BQ--.64389S2;
	Mon, 11 Nov 2024 10:22:06 +0800 (CST)
Message-ID: <797862d3-1b87-4542-b54e-cb111e089465@huaweicloud.com>
Date: Mon, 11 Nov 2024 10:22:05 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: bcm - add error check in the ahash_hmac_init
 function
To: Chen Ridong <chenridong@huaweicloud.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net, u.kleine-koenig@baylibre.com, rob.rice@broadcom.com,
 steven.lin1@broadcom.com
Cc: linux-crypto@vger.kernel.org, wangweiyang2@huawei.com
References: <20241104121745.1634866-1-chenridong@huaweicloud.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20241104121745.1634866-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBXuORNajFnzjS+BQ--.64389S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFy8Gw1DCFWDZryUZryxKrg_yoW8GFyDpF
	W8u3y2yrn5XFsxGFZ7Xa1rJF9IgFyxA34rtrW8J348Z3srZry8u3y7Gw18ZF1DA3yrGFya
	yF4Ig347XryUXFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2024/11/4 20:17, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The ahash_init functions may return fails. The ahash_hmac_init should
> not return ok when ahash_init returns error. For an example, ahash_init
> will return -ENOMEM when allocation memory is error.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  drivers/crypto/bcm/cipher.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 7540eb7cd331..9e6798efbfb7 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -2415,6 +2415,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
>  
>  static int ahash_hmac_init(struct ahash_request *req)
>  {
> +	int ret;
>  	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>  	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
> @@ -2424,7 +2425,9 @@ static int ahash_hmac_init(struct ahash_request *req)
>  	flow_log("ahash_hmac_init()\n");
>  
>  	/* init the context as a hash */
> -	ahash_init(req);
> +	ret = ahash_init(req);
> +	if (ret)
> +		return ret;
>  
>  	if (!spu_no_incr_hash(ctx)) {
>  		/* SPU-M can do incr hashing but needs sw for outer HMAC */

Friendly ping.

