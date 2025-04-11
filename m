Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506BC1EB18C
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 02:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339445; cv=none; b=r8h8Q0R7eCD2ZPaeVeot1Tzi44Di/9lEp2ysmq0G+qh7B0wkyY/cwtf2MYiIR00YE9gIiMLAj1et0apoaoPrx/NDEYL3PmkkP51+UGByf8X/yAetuQb0ZSxZwXVdiyKbitKKOP/3+TOXg0NCnGiYNUi59BKOe4SSCrYnDSGogIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339445; c=relaxed/simple;
	bh=cW0H36u724NhJ8Z1+4mvU/0AQuhGNfojdK7FhmZt+4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsRal8UOy+j/DOFwNnvlZkVE4AeGR5OmQx6M/CJIKjquhhpCtO8TYyBSlBKD8I5eQjfQIsjlCdKP5Q+946cAiT19uA9Tv1E8xavvvufiLYEkKNtgMewyeMd4gnRokLJnv8naBGM4xjBZVkTeQS7uVBwik/DeckkGFJOdIi6o+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=jaCFvf9h; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="jaCFvf9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744339444; x=1775875444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t+tVWahaQdAx3d0pKIzo/isaAUyw7LhtrBUhCF9WaNI=;
  b=jaCFvf9hlq/MTtcob6lXCkYie28uZZhYeei3kTf0jRm4D0S5Ws37BNBj
   9OkNSgdXPQOzLN29b5UklZrqCd8Lur+oxtDrg7SqsOcV+NmsgopYoiFdb
   Zv87HcaLP9hidqYuYVCgxs6Kn341ZEYWQkNteeX26hrgnPd9ugPDo/sKT
   0=;
X-IronPort-AV: E=Sophos;i="6.15,203,1739836800"; 
   d="scan'208";a="82749504"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 02:44:00 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:16839]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.147:2525] with esmtp (Farcaster)
 id 68288331-fcf3-4a5b-9f16-0efedcfede79; Fri, 11 Apr 2025 02:43:59 +0000 (UTC)
X-Farcaster-Flow-ID: 68288331-fcf3-4a5b-9f16-0efedcfede79
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Apr 2025 02:43:58 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.100.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Apr 2025 02:43:54 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
	<linux-crypto@vger.kernel.org>, <syzkaller@googlegroups.com>
Subject: Re: [v2 PATCH] crypto: scomp - Fix wild memory accesses in scomp_free_streams
Date: Thu, 10 Apr 2025 19:43:18 -0700
Message-ID: <20250411024346.64403-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <Z_hv117exy6sjUI7@gondor.apana.org.au>
References: <Z_hv117exy6sjUI7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 11 Apr 2025 09:26:47 +0800
> On Thu, Apr 10, 2025 at 11:33:45AM -0700, Kuniyuki Iwashima wrote:
> > syzkaller reported the splat below [0].
> > 
> > When alg->alloc_ctx() fails, alg is passed to scomp_free_streams(),
> > but alg->stream is still NULL there.
> > 
> > Also, ps->ctx has ERR_PTR(), which would bypass the NULL check and
> > could be passed to alg->free_ctx(ps->ctx).
> 
> Thanks for the report.  I think we should instead move the assignment
> up and test for IS_ERR_OR_NULL in scomp_free_streams.

I didn't move the assignment just because I was not sure if the
immature alg->stream could be accessed by another thread.

But if it's okay, v2 looks better to me.

Thanks!


> 
> ---8<---
> In order to use scomp_free_streams to free the partially allocted
> streams in the allocation error path, move the alg->stream assignment
> to the beginning.  Also check for error pointers in scomp_free_streams
> before freeing the ctx.
> 
> Finally set alg->stream to NULL to not break subsequent attempts
> to allocate the streams.
> 
> Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Co-developed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index f67ce38d203d..5762fcc63b51 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -111,13 +111,14 @@ static void scomp_free_streams(struct scomp_alg *alg)
>  	struct crypto_acomp_stream __percpu *stream = alg->stream;
>  	int i;
>  
> +	alg->stream = NULL;
>  	if (!stream)
>  		return;
>  
>  	for_each_possible_cpu(i) {
>  		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
>  
> -		if (!ps->ctx)
> +		if (IS_ERR_OR_NULL(ps->ctx))
>  			break;
>  
>  		alg->free_ctx(ps->ctx);
> @@ -135,6 +136,8 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
>  	if (!stream)
>  		return -ENOMEM;
>  
> +	alg->stream = stream;
> +
>  	for_each_possible_cpu(i) {
>  		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
>  
> @@ -146,8 +149,6 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
>  
>  		spin_lock_init(&ps->lock);
>  	}
> -
> -	alg->stream = stream;
>  	return 0;
>  }
>  
> -- 
