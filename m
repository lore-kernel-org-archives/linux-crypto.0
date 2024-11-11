Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C81F17F7
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 02:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731291686; cv=none; b=EqsytNKzlbGjH+8lFSbsL7w9Oajvs5r0O54e1XJbWdBrx5gK6DHh9OBB/DwlwKmhW5yZbV3sJT5rk3QOHx4VlEyXKVqdYQ3CP6Fq8g2lmKAR4+OmCN9LaMl8amTrans3/RJXG506NSogYT8wYLFjIfry+ddfnskqT88MYn1gPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731291686; c=relaxed/simple;
	bh=mrEQwqNtaPVbW5Kj1Jxdrsw7oPEgKIxv69yc6Muqi/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i3D6lWb3Zhy362K5+w0TLxabcyFXFaSFVZF73x93t1GDG3qeRcFdfGtj8B+r0Q4CecvS86L1bWjJdAdG1KQdc32bn8PTdZy6ICIZr8bn1lIQX3ly1OfkEAMrYpUa6CNsPx3f8fGGybHUbEiBTKbQhYWUwDapuKlvmxVan2Y8iiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XmtXh6f9Vz1hwRg;
	Mon, 11 Nov 2024 10:19:32 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FA2B1402CE;
	Mon, 11 Nov 2024 10:21:20 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Mon, 11 Nov
 2024 10:21:19 +0800
Message-ID: <15bedaeb-245f-4748-9560-cdc081050f44@huawei.com>
Date: Mon, 11 Nov 2024 10:21:18 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
To: Chen Ridong <chenridong@huaweicloud.com>, <horia.geanta@nxp.com>,
	<pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <tudor-dan.ambarus@nxp.com>, <radu.alexe@nxp.com>
CC: <linux-crypto@vger.kernel.org>, <wangweiyang2@huawei.com>
References: <20241104121511.1634822-1-chenridong@huaweicloud.com>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <20241104121511.1634822-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/11/4 20:15, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The caam_rsa_set_priv_key_form did not check for memory allocation errors.
> Add the checks to the caam_rsa_set_priv_key_form functions.
> 
> Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  drivers/crypto/caam/caampkc.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> index 887a5f2fb927..cb001aa1de66 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -984,7 +984,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>  	return -ENOMEM;
>  }
>  
> -static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
> +static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
>  				       struct rsa_key *raw_key)
>  {
>  	struct caam_rsa_key *rsa_key = &ctx->key;
> @@ -994,7 +994,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
>  
>  	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
>  	if (!rsa_key->p)
> -		return;
> +		return -ENOMEM;
>  	rsa_key->p_sz = p_sz;
>  
>  	rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
> @@ -1029,7 +1029,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
>  
>  	rsa_key->priv_form = FORM3;
>  
> -	return;
> +	return 0;
>  
>  free_dq:
>  	kfree_sensitive(rsa_key->dq);
> @@ -1043,6 +1043,7 @@ static void caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
>  	kfree_sensitive(rsa_key->q);
>  free_p:
>  	kfree_sensitive(rsa_key->p);
> +	return -ENOMEM;
>  }
>  
>  static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
> @@ -1088,7 +1089,9 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>  	rsa_key->e_sz = raw_key.e_sz;
>  	rsa_key->n_sz = raw_key.n_sz;
>  
> -	caam_rsa_set_priv_key_form(ctx, &raw_key);
> +	ret = caam_rsa_set_priv_key_form(ctx, &raw_key);
> +	if (ret)
> +		goto err;
>  
>  	return 0;
>  

Friendly ping

Best regards,
Ridong
