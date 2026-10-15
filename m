Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6501B3F9F5B;
	Thu, 15 Oct 2026 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792088804; cv=none; b=ncHKrlfZY82/LCKflFA2T7pKbUv3kWJQyzA5uUwG84SXdFBexe5Uacqmn954NWhSeCJm6EOFYfxkNsiBnT2UDhtLfDXYs/vvwIeuEk/RielaEoW+HJLfctm9YefIIoYKs358K3+HWMXTzZtjw0qZKxY7vwbwcCP2fdMyAsuQGS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792088804; c=relaxed/simple;
	bh=oiYFsfi6jMgj+Wt+cJ7I1Fu2up7kp5G5ztJImNzyEOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CuZ0ha4S+rKqex07pOAk+UflRuxjYflkKO2iFUuga03akLx4yfboBnm2P7JiCROFeGzNgkqt4cFH5GsfG0F/QT03JCDHkfiZG4DE0uC0OcClID09frY68No8mImG0yu2cLAr/meilXnhHgxe97A+VT9kLVgVrAfrvO3vnhxy7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UabknGaJ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UabknGaJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792088802; x=1823624802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oiYFsfi6jMgj+Wt+cJ7I1Fu2up7kp5G5ztJImNzyEOM=;
  b=UabknGaJrb14sTdfwLfuvPM5445iKFQPEVvioLI7do0oS0HBq6R466n1
   X5vF0iiMpwS1YxIqQsvy3/TrRjpX8JOuaKSxXaUXaCoLHIj1MPo0RCt9s
   9tFyGzM3b7jOmR9t0i1qJAquh5MmevNb60RU1wpWPiEqnOfEBaDqZxZY7
   SkS+VpdM4pRj0+KJdYXBxbL5ov5LyB3NplERFXmDJntGRMaHFfcIkxTxO
   J10I0psL00q9NrViazYOnMy1dsuC0/i4GEXTZ8Rm4kV+xuXetA5m7Ruaz
   GOxwyoI8MtGXFb4Zla0+Z2wy992/2WnmHKt+aA26K+0HHaGSFgCW/UV3M
   A==;
X-CSE-ConnectionGUID: pmYeNWpbQ92aAX9vVNxcBA==
X-CSE-MsgGUID: zzuOtGJaSf2JAmEn7VQM1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="762311"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="762311"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 11:26:41 -0700
X-CSE-ConnectionGUID: 4cPquWbeSdOY3oDSTLawtA==
X-CSE-MsgGUID: ysvOsgJ2TUqU1ZLKdnkwUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1667043"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.113]) ([10.125.110.113])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 11:26:40 -0700
Message-ID: <959bd30e-f8b8-4beb-bd2e-5195bf5e9ad5@intel.com>
Date: Thu, 15 Oct 2026 11:26:38 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] async_tx: use DMA Engine APIs
To: Frank.Li@oss.nxp.com, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org,
 Frank Li <Frank.Li@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/26 12:43 PM, Frank.Li@oss.nxp.com wrote:
> Use DMA Engine APIs to prepare make dma_device private.
> Last patch mark async_tx as deprecated.
> 
> Depend on below two patches
> https://lore.kernel.org/imx/20261014190337.1718622-1-Frank.Li@oss.nxp.com/T/#u
> 
> base on https://git.kernel.org/pub/scm/linux/kernel/git/vkoul/dmaengine.git/
> branch: next
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>

For the series:
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Frank Li (6):
>       async_tx: replace direct ->device_prep*() calls with standard DMA engine API
>       async_tx: use dmaengine_get_dma_device() instead of chan->device->dev
>       async_tx: use dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
>       async_tx: convert to dmaengine_is_*_aligned() helpers
>       async_tx: replace open-coded cap_mask accesses with dmaengine_has_cap()
>       async_tx: Mark as Deprecated in Kconfig
> 
>  crypto/async_tx/Kconfig             |  2 +-
>  crypto/async_tx/async_memcpy.c      | 14 +++++------
>  crypto/async_tx/async_pq.c          | 44 ++++++++++++++++----------------
>  crypto/async_tx/async_raid6_recov.c | 14 +++++------
>  crypto/async_tx/async_tx.c          | 19 ++++----------
>  crypto/async_tx/async_xor.c         | 50 +++++++++++++++++--------------------
>  include/linux/async_tx.h            |  8 ++----
>  7 files changed, 65 insertions(+), 86 deletions(-)
> ---
> base-commit: 547cb54c6fd39a610130c0beb2d85489bc914ea7
> change-id: 20261014-async_tx_dma-4f69bf80176f
> 
> Best regards,
> --  
> Frank Li <Frank.Li@nxp.com>
> 
> 

