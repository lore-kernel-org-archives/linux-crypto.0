Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BA24137BF
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143870; cv=none; b=P99HXQ5P2luSciQ7SpkT6NUnA/Lf+gU6qexoUWTtCzPNSTyMgg08O8K54nSmUNJlLi0wIe7xmswP/ib2mirXJEFuUuiydkS0LSD5bcpLaQZa49ACaXPBAvdDXNXq2q/oBqS+79OmOeotv2wauHTbhzvtlVELziP7UdSIUKfgtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143870; c=relaxed/simple;
	bh=y1I5rOf7OrXfFm3V0abeMQKoeg6ZpFE9wFa86V6vDmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrXqKpqIEM/1SML8d8igLyPYoAkNhCkqjCHyzqWqZ1gcIVVmTUse+2+4/uwWinbwZ6tGxfguGF4YfAqIQI2BpFN9E4O7HGVLE+zOO6PLDKHIlNks2mfU5Kl+yQCZ8lwoZEgcPwNS9ACPtvRnWxcYja22N+tpFXbWAqRpDOYvDI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=czG9+e4K; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="czG9+e4K"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id 99T4xbPoDv0nd9GCCxnOmz; Wed, 23 Sep 2026 06:11:08 +0000
Received: from gator4166.hostgator.com ([108.167.190.91])
	by cmsmtp with ESMTPS
	id 9GCBxW39xvfbR9GCBxp9xO; Wed, 23 Sep 2026 06:11:07 +0000
X-Authority-Analysis: v=2.4 cv=X7FSKHTe c=1 sm=1 tr=0 ts=6ab36d7b
 a=vY9Mjuda9oMEc2E4Cx1x2A==:117 a=vY9Mjuda9oMEc2E4Cx1x2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7T7KSl7uo7wA:10 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=tBmdgtp83pJHOttqeXgA:9 a=QEXdDO2ut3YA:10
 a=2aFnImwKRvkU0tJ3nQRT:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=t8eoLHfrw7hclX5j0eUpFdmOPOJ4bJnLXLBr2WWB5ws=; b=czG9+e4KAvvC
	hZOshRvg7+XoxLTfjB2ycCnfidNdp7qsExT1C0ZPqtEZY8BXO/UkbNQ1/OqhQGtNjR0WajLWFk4u7
	HfX826I9glD6K6c7zzHjrpad7Jhnu1Y15/3FcElFwBKVTmmED9ymekxMtM/rML0N+IpJ8aSr1t2Mu
	WdclcbI13wVh/u5BplxWyw7gGoJ8xjkLKimFHH74bJeL0T3pFPKWmuH2FeLRaOccg0EjGASMx7gsI
	lRYVSYpZTzh54OZ+nKlnpmSCUQtPPgyu1cPolUukTb4Gbpz8cpNTXbdgMNTtrPhiC9U5A0IbjGUNV
	z6Wg/YNmu7McP/j5+U5tPw==;
Received: from flh4-125-195-69-90.tky.mesh.ad.jp ([125.195.69.90]:54380 helo=[10.203.100.34])
	by gator4166.hostgator.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <gustavo@embeddedor.com>)
	id 1x9GCA-00000002MGj-0UfR;
	Wed, 23 Sep 2026 01:11:06 -0500
Message-ID: <abbd8862-cb64-4c58-a78b-c971fdada7be@embeddedor.com>
Date: Wed, 23 Sep 2026 15:11:01 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: hisilicon/qm - annotate cap_tables with
 __counted_by_ptr
To: Bill Wendling <morbo@google.com>, Zhiqi Song <songzhiqi1@huawei.com>,
 Longfang Liu <liulongfang@huawei.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Weili Qian <qianweili@huawei.com>,
 Zhou Wang <wangzhou1@hisilicon.com>,
 Chenghai Huang <huangchenghai2@huawei.com>
Cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 codemender-patching+linux@google.com
References: <20260923060114.2605310-1-morbo@google.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20260923060114.2605310-1-morbo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 125.195.69.90
X-Source-L: No
X-Exim-ID: 1x9GCA-00000002MGj-0UfR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: flh4-125-195-69-90.tky.mesh.ad.jp ([10.203.100.34]) [125.195.69.90]:54380
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP+MMO+qywfixZ3tZHtjdQE2BomUvwHPvpuYG1jKgmCNRlOK8IX0FNru67HQYl+ltc29SHOYdITntQ8Q0/7wLoEuVhHLFHqYhjJqiWEGreuWbZ65rG5j
 TQptsxc8BCh7qGNVibSRItVScs2vYq5NSB7x/lymFTDm+a0Z9GRKWGP2JCFDoS2yr1WyfGJG+UpZbX3gdAr8oXV2TEh+BN9uJxptuR4Ca95DSdABeZnIMz4P



On 9/23/26 15:01, Bill Wendling wrote:
> Annotate the 'qm_cap_table' and 'dev_cap_table' pointer fields in
> 'struct hisi_qm_cap_tables' with the '__counted_by_ptr' attribute.
> This improves bounds checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE, allowing KASAN and compiler diagnostics to
> detect out-of-bounds accesses.
> 
> The 'qm_cap_table' pointer is associated with 'qm_cap_size' which
> specifies its element count. Similarly, 'dev_cap_table' is associated
> with 'dev_cap_size'.
> 
> To ensure safety under compiler instrumentation, the assignments in the
> initialization paths have been updated to set the 'size'/'count' fields
> prior to setting the pointer fields. This prevents any transient state
> where the pointer is valid but the count is 0 (or uninitialized),
> ensuring that subsequent accesses to these tables do not trigger
> false-positive bounds check panics.
> 
> Cc: codemender-patching+linux@google.com
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-Gustavo

> ---
>   drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>   drivers/crypto/hisilicon/qm.c             | 2 +-
>   drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
>   drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
>   include/linux/hisi_acc_qm.h               | 4 ++--
>   5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index b6903fce6071..4a1b2de476f5 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1234,8 +1234,8 @@ static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
>   		return -EINVAL;
>   	}
>   
> -	qm->cap_tables.dev_cap_table = hpre_cap;
>   	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = hpre_cap;
>   
>   	return 0;
>   }
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index c01966a4a33f..7d13476451e3 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -5743,8 +5743,8 @@ static int qm_pre_store_caps(struct hisi_qm *qm)
>   							i, qm->cap_ver);
>   	}
>   
> -	qm->cap_tables.qm_cap_table = qm_cap;
>   	qm->cap_tables.qm_cap_size = size;
> +	qm->cap_tables.qm_cap_table = qm_cap;
>   
>   	return 0;
>   }
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 752565200c16..ac423d016998 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -1285,8 +1285,8 @@ static int sec_pre_store_cap_reg(struct hisi_qm *qm)
>   				     i, qm->cap_ver);
>   	}
>   
> -	qm->cap_tables.dev_cap_table = sec_cap;
>   	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = sec_cap;
>   
>   	return 0;
>   }
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 706a73656977..10091ad4a6a8 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -1400,8 +1400,8 @@ static int zip_pre_store_cap_reg(struct hisi_qm *qm)
>   				     i, qm->cap_ver);
>   	}
>   
> -	qm->cap_tables.dev_cap_table = zip_cap;
>   	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = zip_cap;
>   
>   	return 0;
>   }
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index f7570a409905..8dc49fa2123b 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -332,9 +332,9 @@ struct hisi_qm_cap_record {
>   
>   struct hisi_qm_cap_tables {
>   	u32 qm_cap_size;
> -	struct hisi_qm_cap_record *qm_cap_table;
> +	struct hisi_qm_cap_record *qm_cap_table __counted_by_ptr(qm_cap_size);
>   	u32 dev_cap_size;
> -	struct hisi_qm_cap_record *dev_cap_table;
> +	struct hisi_qm_cap_record *dev_cap_table __counted_by_ptr(dev_cap_size);
>   };
>   
>   struct hisi_qm_list {

