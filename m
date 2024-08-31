Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A9320F;
	Sat, 31 Aug 2024 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725094503; cv=none; b=AO+r9rwTPVlyWHyXWCQeIhRGDcHvucFSH/a3VjCPy9fgi1GqBnps/ECvjQBGpdOQ3TUcAvwp/eedFiJ4njpYESD6O6KHldcuC8oWKFhi3s9qQplm3h1o/F5Av2jaiAcgnwZYf2MCl6sqkLy/5Vu2aYKywUc5wwMGM/yxY/u8PdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725094503; c=relaxed/simple;
	bh=WKf2h0R0WGR8ElZrsbkg0Gecievb5VW6kUmx3JKajwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pt6zaKQyP54OeLbiW8Tn8yooPYHtr1wcscASBXeegcZY6x2/9Xnc8GbqIAbBx4dJcjeJYlktyuUCaIMg+5y2czdkU6Lzo71el0z9pTqsuyjM3hUoFfAe4yfHmQZquOLX7TE42kJ42s00Bt8X1+TGQWB/ZEZBDGeyzrcSoPdvI1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QxWKtA1g; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxWKtA1g"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d889207d1aso653566a91.3;
        Sat, 31 Aug 2024 01:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725094501; x=1725699301; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a3G9lC58rClwuOYKI8lYcySeZmZpkHNUwXcDyHnPjos=;
        b=QxWKtA1g5FdsEh4e4EtkCVmPxDnIFufixgN64DDlZXMPGZtLcTc996aWPmGDf9B+Rm
         oKt4mQVrVpS2oBKvylsKiL/9DKFSVGE86AYcC9ALPkER2qYxbJCDdgY250zunsSu4B29
         7VpuvBlkTIGPDJg0GZaTuXpe/38tGTOOIE8Q3/+9vndDQFF8R3R7evrlp/MZgNjKL724
         R8GXZ55alsXPGFjNSkP5Q6XJQQs6Jy/VpbcMJ9wZOhiAIbjABJW8e0zXpvx59xjHsGfM
         pSg4YTCFc4/BCvR4CvNxP1bFUgUksd5U99c29WGU+BbY9QqAKFVs584AwZS2Vh5Hgr2H
         IJ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725094501; x=1725699301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3G9lC58rClwuOYKI8lYcySeZmZpkHNUwXcDyHnPjos=;
        b=oHjvcjrD/FGhkGuHY7yPNlMyCB3J+snDF59L3BydeFJjEgv3jrL2JdgAjloxpbP2lm
         BYLnx9fyYmkwA5/k/E1d0bmdi23HW14jaFLnmDp86fhwOv1PsQSIx0ZO50rCA1UAYjEi
         QUcIgXcsTA4Uf3DzotZObRJD4/gj3ZyRj1mxdJwBym7bc7jCcLu+ioAqL1ajiP6cLLZG
         mSjuwU4+HUV4bJo5rk6a3nvux5CPbQZ++l8HeFCFblCzxEGVPFuvRzKR8eEg3lPf4viQ
         ofojU3JGUO2jcn+5tyDDExNLQ41kkCHgl9BWtqtBsVWRTKQoPQ9bET2257PQYZC4p0oH
         fdPA==
X-Forwarded-Encrypted: i=1; AJvYcCUCKnwC2qOiU0v9pY5Kin2dWh9IZ1wUj2bbdRcjlMXwV3AlCu7CKrIm1jRgPH+XS/WEEUKgLWJH0162VzA=@vger.kernel.org, AJvYcCVD4LzUYP5Gj10wPZ/55dR65mP2yUSDGx+a9OBZLD186j0AUQukENJk7INTwVnCJpONCYlddNEBGYdIRxrD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7e56P/VNBuP26w9VEBSO9XmOedSQuMg3lBKmPGlJ30rgzfg9k
	IoLgs6qMv/SbRDuQ/rsPSDmBnHkDf6GQi+YkmPCqirI9u9iUQmtr
X-Google-Smtp-Source: AGHT+IElW8il5eJK87uF45oKTNfqzmNpsqFCKTnwS44NbYCy24UFsHTlV15SCym6hixhFGiUryfyhQ==
X-Received: by 2002:a17:90a:ea89:b0:2d3:c303:fe14 with SMTP id 98e67ed59e1d1-2d8946801e0mr1272107a91.40.1725094501222;
        Sat, 31 Aug 2024 01:55:01 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8446c1c08sm7689485a91.37.2024.08.31.01.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 01:55:00 -0700 (PDT)
Date: Sat, 31 Aug 2024 16:54:56 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	fanghao11@huawei.com, liulongfang@huawei.com, shenyang39@huawei.com,
	songzhiqi1@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, taoqi10@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH 2/3] crypto: hisilicon - add a lock for the qp send
 operation
Message-ID: <ZtLaYFUKM9pPb5rF@visitorckw-System-Product-Name>
References: <20240830101718.3193159-1-huangchenghai2@huawei.com>
 <20240830101718.3193159-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830101718.3193159-3-huangchenghai2@huawei.com>

On Fri, Aug 30, 2024 at 06:17:17PM +0800, Chenghai Huang wrote:
> Apply for a lock before the qp send operation to ensure no
> resource competition in multi-concurrency situations.
> 
> This modification has almost no impact on performance.
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 ++
>  drivers/crypto/hisilicon/zip/zip_crypto.c   | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> index 764532a6ca82..c167dbd6c7d6 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -575,7 +575,9 @@ static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
>  
>  	do {
>  		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
> +		spin_lock_bh(&ctx->req_lock);
>  		ret = hisi_qp_send(ctx->qp, msg);
> +		spin_unlock_bh(&ctx->req_lock);
>  		if (ret != -EBUSY)
>  			break;
>  		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
> index 94e2d66b04b6..e3a31e3416be 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
> @@ -213,6 +213,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
>  {
>  	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
>  	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
> +	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
>  	struct acomp_req *a_req = req->req;
>  	struct hisi_qp *qp = qp_ctx->qp;
>  	struct device *dev = &qp->qm->pdev->dev;
> @@ -244,7 +245,9 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
>  
>  	/* send command to start a task */
>  	atomic64_inc(&dfx->send_cnt);
> +	write_lock(&req_q->req_lock);
>  	ret = hisi_qp_send(qp, &zip_sqe);
> +	write_unlock(&req_q->req_lock);

Hi Chenghai,

Thanks for your patch. Since Herbert has already applied a patch [1]
changing rw_lock to spinlock in the hisilicon zip controller driver,
applying your patch might cause a conflict. Could you rebase on
Herbert's crypto tree and update write_lock() and write_unlock() to
spin_lock() and spin_unlock(), respectively?

[1]: https://lore.kernel.org/lkml/20240823183856.561166-1-visitorckw@gmail.com/

Regards,
Kuan-Wei

>  	if (unlikely(ret < 0)) {
>  		atomic64_inc(&dfx->send_busy_cnt);
>  		ret = -EAGAIN;
> -- 
> 2.33.0
> 
> 
