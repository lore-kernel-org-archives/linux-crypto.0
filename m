Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76DB155333
	for <linux-crypto@vger.kernel.org>; Sat, 30 Aug 2025 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756544652; cv=none; b=n/ceg2jjjSoKPvIXia8VSq6sx+8t5FeOPkNZAeSLFJ20VUgelvAvzJhIIQg/Vu7eFj5WtZnsPefR+/aiIW1I+qJBq7tj4fd78zF8MiNzdTz2vIuzGgRyhGMzuYi3p1DbCNS/uNiS4eNaxBvR2X++pz4bEuAknnNaKwJ8nsdpciI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756544652; c=relaxed/simple;
	bh=jqmyRX0n/UZt0pKSOHKRGPnful4husVw1QpkulVOGrE=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SWp7b86g2GkaRxGra4nPotjEdd7nAN8+kYDReacZOle5dHX1l4wyFOggilUYHmyDYtAfeAqPjaatlqQcqqSkXvTjBHrpSoMcC9RL3jqDFNJ04CM+GDkOEdbML8Z9ZULK9N25hNf//59HkhNNc9KxHxu9o0ZLByjE5esWtCyCZ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cDTgd6YB4ztTPn;
	Sat, 30 Aug 2025 17:03:09 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 09F60180B62;
	Sat, 30 Aug 2025 17:04:07 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 17:04:06 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec2 - Fix false-positive warning of
 uninitialised qp_ctx
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
References: <aLK4s1jSG1ulgKvF@gondor.apana.org.au>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7884a346-cef8-aff3-fe75-05656c288cae@huawei.com>
Date: Sat, 30 Aug 2025 17:04:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aLK4s1jSG1ulgKvF@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/30 16:39, Herbert Xu wrote:
> Fix the false-positive warning of qp_ctx being unitialised in
> sec_request_init.  The value of ctx_q_num defaults to 2 and is
> guaranteed to be non-zero.
> 
> Thus qp_ctx is always initialised.  However, the compiler is
> not aware of this constraint on ctx_q_num.  Restructure the loop
> so that it is obvious to the compiler that ctx_q_num cannot be
> zero.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index d044ded0f290..31590d01139a 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -1944,14 +1944,12 @@ static void sec_request_uninit(struct sec_req *req)
>  static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
>  {
>  	struct sec_qp_ctx *qp_ctx;
> -	int i;
> +	int i = 0;
>  
> -	for (i = 0; i < ctx->sec->ctx_q_num; i++) {
> +	do {
>  		qp_ctx = &ctx->qp_ctx[i];
>  		req->req_id = sec_alloc_req_id(req, qp_ctx);
> -		if (req->req_id >= 0)
> -			break;
> -	}
> +	} while (req->req_id < 0 && ++i < ctx->sec->ctx_q_num);
>  
>  	req->qp_ctx = qp_ctx;
>  	req->backlog = &qp_ctx->backlog;
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks
Longfang.

