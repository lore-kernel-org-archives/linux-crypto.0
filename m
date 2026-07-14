Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A153358CA;
	Tue, 14 Jul 2026 21:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784065992; cv=none; b=OeByRz5mGyX7QgcWOydjdGuckwiHkCYzkE3RgrVG+FRXdTWxOYSNagSfwgdegY8Z3NWbjPvsSn6amgg2kF0Mqw8XApWG7tODZrNPuXKe/gZwg7Tktd+wADYAqCKzKyxvHB1rA0swoFInxJKATjqBoyw6x8mTgQ2cxZWcsoF+B5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784065992; c=relaxed/simple;
	bh=nBJF1huhfRnkLuP6nsnzKOJ93Pj9BiHpUVzk9hZpPWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufaTef+pkIDx1quOg0uzc+scQX8li9zW7oMSpV9+zSJ4JwPAz5Pxc9/6l70qC1V3ecjEt+5qFB2eJX2CtmM/B1FMB5V51Exy6zDc/90l4OLBZB1QE5+tZd8URRmTfs44y3yY4gnR84euRDFRT0Uxnlb8ly0ywjKmhUwbwXmWGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U074G6fS; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U074G6fS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784065990; x=1815601990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nBJF1huhfRnkLuP6nsnzKOJ93Pj9BiHpUVzk9hZpPWc=;
  b=U074G6fSqdyQXAP1emnGjAfl1q/ZU6kgmbhflICm7J2/DGGHTklCit3c
   mjSMv7ozP7A3KDhs1r0ZcRFGLsJrMRUAgRP+UUrQmsEkECZAlLc2/ah3i
   G5l1+lLcpqsDY1LELl2EXka3mPWNALfLxgVCBkn6sbKCfkElM5bkOFnuM
   +/mxTQwSHn1QXK3wNk6M8N+3mfTmUSCa2iBHEaj667RkXpGH2Y/9sjVn3
   6gLlrzWwjyBLP3bwU7ofUPJ4Ex1p8s7jeldq2CVW4iIAPF+a8a1YN8muL
   Uuul8dcLxUymvwtxYYayDLZcaGuqpTJZEc5Q4KAKAYmtSysE6hMBWfsKz
   g==;
X-CSE-ConnectionGUID: 7LPUXCQdTICTPPc6wZOnhg==
X-CSE-MsgGUID: H9iEgEJHSGOqtLMeDdhFyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84579724"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84579724"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 14:53:08 -0700
X-CSE-ConnectionGUID: yKJJ/6CmTr6Jk8v61QImzw==
X-CSE-MsgGUID: X7xhfKPoTYOcNRDF5XST1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252595874"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.131]) ([10.125.108.131])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 14:53:07 -0700
Message-ID: <90c8d0e8-99fc-4fd8-bdfd-f3093ffac256@intel.com>
Date: Tue, 14 Jul 2026 14:53:06 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dmaengine: idxd: assign all engines to group 0 in IAA
 defaults
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>,
 Kristen Accardi <kristen.c.accardi@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
References: <20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com>
 <20260713-iaa-crypto-fixes-zswap-v1-1-65cac23c684d@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260713-iaa-crypto-fixes-zswap-v1-1-65cac23c684d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/13/26 9:10 PM, Vinicius Costa Gomes wrote:
> From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> 
> The IAA device defaults only assigned engine 0 to group 0, leaving
> engines 1 through max_engines-1 unassigned (group_id = -1). This means
> that by default only a single engine processed descriptors, limiting
> throughput to one engine's capacity.
> 
> Assign all available engines to group 0 so that the full hardware
> parallelism is used out of the box without requiring manual
> accel-config setup.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dma/idxd/defaults.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/idxd/defaults.c b/drivers/dma/idxd/defaults.c
> index 2bbbcd02a0da..26ebfa2ca144 100644
> --- a/drivers/dma/idxd/defaults.c
> +++ b/drivers/dma/idxd/defaults.c
> @@ -8,6 +8,7 @@ int idxd_load_iaa_device_defaults(struct idxd_device *idxd)
>  	struct idxd_engine *engine;
>  	struct idxd_group *group;
>  	struct idxd_wq *wq;
> +	int i;
>  
>  	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
>  		return 0;
> @@ -41,11 +42,12 @@ int idxd_load_iaa_device_defaults(struct idxd_device *idxd)
>  	/* set driver_name to "crypto" */
>  	strscpy_pad(wq->driver_name, "crypto");
>  
> -	engine = idxd->engines[0];
> -
> -	/* set engine group to 0 */
> -	engine->group = idxd->groups[0];
> -	engine->group->num_engines++;
> +	/* assign all engines to group 0 */
> +	for (i = 0; i < idxd->max_engines; i++) {
> +		engine = idxd->engines[i];
> +		engine->group = group;
> +		group->num_engines++;
> +	}
>  
>  	return 0;
>  }
> 

