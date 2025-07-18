Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD052BEC24;
	Fri, 18 Jul 2025 11:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837165; cv=none; b=gns7SIXpSvnssQT8DILZ+G6HVJuX6mDn7HA36qvD5/3RVZYiXiVgwKSCTJ4QSUYjg99OsT5d32OBNorMStUb1C4wM5E/KJ/M7g2aRIPJRbqhLlaFqW44Z5sCG/efKYizPPjY8G6pZ9zvqiiD6UGSQfV2u+4+YQLtUn03Y1D3V4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837165; c=relaxed/simple;
	bh=pN7nMJzYWuyor/OgGpD7F0YeaFDp1vibzzy5pYJe6lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KD94M9iz49XL5JTngyfJ7jv4itB2tmtYj2JZSGNcCXQmIPYU/NK/FVobU6KsEHeMxc2qbjKc+m0bUfssa1qK5jz7CmNo21avDPvUsES64ghE+3zwblr6hC/VzS1lqpcFaxASDo9RBbUH9U15qEAvAxDTVTKaZ1SA2KDx9f9JgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Yg66yAmq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Yg66yAmq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BvTCZ51d3XXJlGmGkI41GCgkn6QO1Hi7Y8wl9qsGLf8=; b=Yg66yAmqWi4oGtG2EA6VsBfKtr
	3GjI9+T/5LKrkpwDeyqYB1cqKNa18OVTyY8joaNOG0ZPUtE4NIWprAWCWiwvJI36alsLCBeMA5nax
	760R6euyUnZ+x3BFN7ziO45hUSebyYR3GQYADhAaKRFNKVoOWzqIqZE0lwzN4DqKt4ejn7cAoRjFp
	D12SFtaAU3fHYOvO+LV64Sx5KWTyNWCz+ND+A8FMc7zDRha/tW1WEyWy8V3TGBEMF9HxUw450uGMO
	FgqszKkU+EcjQzrlnHTP3BlZVUbi+FSn8rKgtzO2WxHlCX/fBpvi8e8oULQdLYvZbIlsEaMzq05sC
	ubsBt86Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucilf-007ymj-0N;
	Fri, 18 Jul 2025 19:12:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:12:39 +1000
Date: Fri, 18 Jul 2025 21:12:39 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec2 - implement full backlog mode for
 sec
Message-ID: <aHosJ8XZ-SbcAxtf@gondor.apana.org.au>
References: <20250710122457.2295119-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710122457.2295119-1-huangchenghai2@huawei.com>

On Thu, Jul 10, 2025 at 08:24:57PM +0800, Chenghai Huang wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> This patch introduces a hierarchical backlog mechanism to cache
> user data in high-throughput encryption/decryption scenarios,
> the implementation addresses packet loss issues when hardware
> queues overflow during peak loads.
> 
> First, we use sec_alloc_req_id to obtain an exclusive resource
> from the pre-allocated resource pool of each queue, if no resource
> is allocated, perform the DMA map operation on the request memory.
> 
> When the task is ready, we will attempt to send it to the hardware,
> if the hardware queue is already full, we cache the request into
> the backlog list, then return an EBUSY status to the upper layer
> and instruct the packet-sending thread to pause transmission.
> Simultaneously, when the hardware completes a task, it triggers
> the sec callback function, within this function, reattempt to send
> the requests from the backlog list and wake up the sending thread
> until the hardware queue becomes fully occupied again.
> 
> In addition, it handles such exceptions like the hardware is reset
> when packets are sent, it will switch to the software computing
> and release occupied resources.
> 
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h        |  63 ++-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 574 ++++++++++++++-------
>  2 files changed, 457 insertions(+), 180 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
