Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50122DC789;
	Sat, 31 Jan 2026 02:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828392; cv=none; b=D8jW4USD5GWO2URUYtLPolLOgPVaV+2I7up2eCznwlNLLKHeeshwkZ7d4kNF6d4UoXMANmWk0FMHCn1s0XV6eXWY/RlYliW302aTRqzTG91+X8ptlGPUzl4GXvyzmKz7TpD3gtk4ByC2zHpuTLiUg5rPbQvCoPu752UeFcVVTtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828392; c=relaxed/simple;
	bh=oL6NBlRP6LiTXPTzbDVaE1aDBOFxP/SCmaHcwWK4t8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GisnnvE1P9qkbshzXOR97De5m6HiP5YobisysvzjIhfemaPHXesnfPs2NesLbvR7Eh+jDJ9bCEXkifVp9oiWlsJGWVWUiWkmb82vPzC/vtr8KPnXCAjfHpmVEMrfiZosT1rszdVZO04CNa1PaFEV9ZOdbPXxLuZKLxlhWfp5D8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gwEPAofH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gwEPAofH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OPZk+hja2WdnmqK7k60I128twSDa4RF4sPlvNqZThsA=; 
	b=gwEPAofHAqcqhUzIcFpVDBpDRc95jCMHSWLcOtqrDAjfIdDdEss7AtOEe2AyiSV58Rd02TmGWFi
	Id61/Ehn/9hlElfmwkas4ppO0fIs5u5c8cT5aU00Zo0Muh7pJ6ovo13C9AicxmZo1StcrIQK0OePy
	69SsQTwFN3rlC0zYuJ6nni1N5CdiUZgwEAnKZHyhMkZhpXW9qK0VFdrOVd9U8pBaD12GZNVVsDyoy
	u13qDpgFunGnFDNbDhepK4bQoa3pB3CS7fW2Isf4hOL/IiF/2++4tQzbQfJ8vdE4h+6wwGuRsiM8x
	31+EbD8ZhoqihCS0d6tNgXoBb/3oUZhBt1AQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1D9-003S3Q-0R;
	Sat, 31 Jan 2026 10:59:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:59:47 +0800
Date: Sat, 31 Jan 2026 10:59:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/4] crypto: hisilicon/qm - fix several mailbox issues
Message-ID: <aX1wI7ghvy7-Q-Ii@gondor.apana.org.au>
References: <20260117101806.2172918-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117101806.2172918-1-huangchenghai2@huawei.com>

On Sat, Jan 17, 2026 at 06:18:02PM +0800, Chenghai Huang wrote:
> These patchset fix several issues for mailbox handling in the
> hisilicon/qm crypto accelerator driver:
> 1. Fix the memory barrier order in mailbox operations to ensure data is
> up-to-date before hardware access.
> 2. Remove unnecessary architecture-related code, as the driver is
> exclusively used on ARM64.
> 3. Use 128-bit atomic read to replace the current mailbox operations
> in the driver. Since the PF and VFs share the mmio memory of the
> mailbox, mailbox mmio memory access needs to be atomic. Because the
> stp and ldp instructions do not guarantee atomic access to mmio memory
> on all hardware, the current assembly implementation is placed in the
> driver.
> 4. Increase the mailbox wait time for queue and function stop commands
> to match the hardware processing timeout.
> 
> ---
> Chenghai Huang (1):
>   crypto: hisilicon/qm - move the barrier before writing to the mailbox
>     register
> 
> Weili Qian (3):
>   crypto: hisilicon/qm - remove unnecessary code in qm_mb_write()
>   crypto: hisilicon/qm - obtain the mailbox configuration at one time
>   crypto: hisilicon/qm - increase wait time for mailbox
> 
>  drivers/crypto/hisilicon/qm.c | 177 +++++++++++++++++++++-------------
>  include/linux/hisi_acc_qm.h   |   1 +
>  2 files changed, 113 insertions(+), 65 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
