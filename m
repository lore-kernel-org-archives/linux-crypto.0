Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A1E148850
	for <linux-crypto@vger.kernel.org>; Sun, 19 Apr 2026 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776592959; cv=none; b=dP2lnFHfu8OrsSawxLdZZ/q4yhjgV5/x8JpRKcPFq9eq68y5i9L+MW4wQOZB2EV31x5yVZMqaU4e9Kmfho5JQwkBbLXQXGXkVDtY/HqDI7gIh8gllXdaeaTQxmDNkKAs+u2VB/2XunvC56cfju011lUehifVxFZzEJbLvA/xhgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776592959; c=relaxed/simple;
	bh=s+ildAv7xkRLEU3QFEpFAKQaeUnIF857g+IoFjNTd9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ITnsQKsJmeWFWATOH8M3niwIZPjIWiZpRuVVXQcNq/QfP1gHjkHeGmzqWXJoamc+YS3/o0ojzjw7S61HjJgRY5PcYQBvsyalVDLK3DhOD4p9KegRccfbQV+NhBfRR3LTmfSLdiozvI88yaNKxUf1UymGXdBPd+ZoNo3qAIgM23I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from [IPV6:fdfe:dcba:9876::1] (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACXDwApqORpMy_UAA--.14358S2;
	Sun, 19 Apr 2026 18:02:17 +0800 (CST)
Message-ID: <daae489c-ee5a-4163-894a-b805c70d22af@lzu.edu.cn>
Date: Sun, 19 Apr 2026 17:57:27 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] crypto: ccm - keep a private IV for auth and CTR
 state
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, smueller@chronox.de,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, tr0jan@lzu.edu.cn, kanolyc@gmail.com,
 ldy3087146292@gmail.com, enjou1224@outlook.com
References: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>
 <7f569774b437b9056985db1fec58aff337a41a4d.1776578475.git.enjou1224@outlook.com>
Content-Language: en-US
From: Ren Wei <n05ec@lzu.edu.cn>
In-Reply-To: <7f569774b437b9056985db1fec58aff337a41a4d.1776578475.git.enjou1224@outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:ygmowACXDwApqORpMy_UAA--.14358S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw18KFWrGrW8Xr47JrWrKrg_yoWrCrW3pF
	WfWan0yrZ5Jry7CF4IqrW8uFy5uFZY9343Ww4xGw13Grn7Kr18JFy2kr1YyF1rAFykGFWj
	yF4v93sruwnrt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9vb7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q
	6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JV
	W8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8rWrJUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQECCWnkluAAsQABsA



On 4/19/26 16:53, Ren Wei wrote:
> From: Douya Le <ldy3087146292@gmail.com>
> 
> CCM currently uses req->iv both when formatting the authentication
> input and as the working IV consumed by the CTR walk.  Keep a private IV
> copy in the request context for authentication, and use a separate
> working copy for CTR processing.
> 
> Together with the AF_ALG IV snapshot, this makes async CCM IV handling
> stable without changing normal CCM behaviour.
> 
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Tested-by: Yucheng Lu <kanolyc@gmail.com>
> Signed-off-by: Douya Le <ldy3087146292@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> Signed-off-by: ENJOU1224 <enjou1224@outlook.com>
> ---
> changes in v2:
>   - split the original combined fix and keep only the ccm private IV
>     handling change in this patch
>   - rebase onto the current crypto-2.6 tree context used for the
>     algif_aead part of the series
>   - v1 Link: https://lore.kernel.org/all/9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com
> 
>  crypto/ccm.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 2ae929ffdef8..d409324dec29 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -42,6 +42,7 @@ struct crypto_ccm_req_priv_ctx {
>  	u8 odata[16];
>  	u8 idata[16];
>  	u8 auth_tag[16];
> +	u8 iv[16];
>  	u32 flags;
>  	struct scatterlist src[3];
>  	struct scatterlist dst[3];
> @@ -121,17 +122,17 @@ static int crypto_ccm_setauthsize(struct crypto_aead *tfm,
>  	return 0;
>  }
>  
> -static int format_input(u8 *info, struct aead_request *req,
> +static int format_input(u8 *info, const u8 *iv, struct aead_request *req,
>  			unsigned int cryptlen)
>  {
>  	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -	unsigned int lp = req->iv[0];
> +	unsigned int lp = iv[0];
>  	unsigned int l = lp + 1;
>  	unsigned int m;
>  
>  	m = crypto_aead_authsize(aead);
>  
> -	memcpy(info, req->iv, 16);
> +	memcpy(info, iv, 16);
>  
>  	/* format control info per RFC 3610 and
>  	 * NIST Special Publication 800-38C
> @@ -176,7 +177,7 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
>  	int ilen, err;
>  
>  	/* format control data for input */
> -	err = format_input(odata, req, cryptlen);
> +	err = format_input(odata, pctx->iv, req, cryptlen);
>  	if (err)
>  		goto out;
>  
> @@ -248,9 +249,11 @@ static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag)
>  {
>  	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
>  	struct scatterlist *sg;
> -	u8 *iv = req->iv;
> +	u8 *iv = pctx->iv;
>  	int err;
>  
> +	memcpy(iv, req->iv, sizeof(pctx->iv));
> +
>  	err = crypto_ccm_check_iv(iv);
>  	if (err)
>  		return err;
> @@ -288,7 +291,7 @@ static int crypto_ccm_encrypt(struct aead_request *req)
>  	struct scatterlist *dst;
>  	unsigned int cryptlen = req->cryptlen;
>  	u8 *odata = pctx->odata;
> -	u8 *iv = req->iv;
> +	u8 *iv = pctx->idata;
>  	int err;
>  
>  	err = crypto_ccm_init_crypt(req, odata);
> @@ -303,6 +306,8 @@ static int crypto_ccm_encrypt(struct aead_request *req)
>  	if (req->src != req->dst)
>  		dst = pctx->dst;
>  
> +	memcpy(iv, pctx->iv, 16);
> +
>  	skcipher_request_set_tfm(skreq, ctx->ctr);
>  	skcipher_request_set_callback(skreq, pctx->flags,
>  				      crypto_ccm_encrypt_done, req);
> @@ -365,7 +370,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>  	if (req->src != req->dst)
>  		dst = pctx->dst;
>  
> -	memcpy(iv, req->iv, 16);
> +	memcpy(iv, pctx->iv, 16);
>  
>  	skcipher_request_set_tfm(skreq, ctx->ctr);
>  	skcipher_request_set_callback(skreq, pctx->flags,


If there is no need for a v3, could you please drop

    Signed-off-by: ENJOU1224 <enjou1224@outlook.com>

when applying?

This was entirely our mistake. We did not review the trailer chain
carefully enough before sending this round, and we sincerely apologize
for the confusion and extra noise.

