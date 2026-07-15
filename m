Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D43E42BC2D;
	Wed, 15 Jul 2026 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784079523; cv=none; b=uo2sOnTbTfZnBJRwC4lVkzzYjAppLap63raZjAnO6Dh8PsymBk42vq8BeItmvsuZoStZuc+hbo3SgWx150lmZTF+iu1IdHfGwH8jFoitBEd0rBRpHZejLSbxAagoDKYD9uMHTdCo7VBBcCZqt/mX22p3gbG0sUM+ewSSg5/4muA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784079523; c=relaxed/simple;
	bh=H6o9M3cTUc3hhTR6B77yuvL8RpMhrRRa7oC5lhzb64U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=b4A776x8UF5q7WZ8AoHK/FaUT4nxmhTjGNN56CIjs/hlzQtyOiK+9xxlmK2lJaRt581+lL3W1tb0KfTayzNtiAFo47ROmPzbAk51MYs6WaJ9IbYAGk0qv+XasL5baZH+4GqbFNbSWX5/WbJfT373t3yhPH1Az7cw/ZHxlnKNB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oisg3Q+6; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oisg3Q+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784079522; x=1815615522;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=H6o9M3cTUc3hhTR6B77yuvL8RpMhrRRa7oC5lhzb64U=;
  b=Oisg3Q+6xirKkS1P1iUoSxRuoEI2IyRLJjEXWy/6wmYt3QxJG9s1YxEU
   Ac4vJCFyHmHt98mLioawPK9ow82jgA2rSjzrE6aRfAOTKAdfRl5bfV7ad
   UoDDz1doe3pAZTMcHtLQSkE0xHBb09sNwJIX2IAiRsOUU22FsDzcBvp2k
   vtyy+hNwVmCxLBMGAzLJTFyBb3eopMnZ+jWkighCIfAAhnw0NVq2FE8v2
   PwZCSuqREeQoag+wSadAqvjjRiPI2+p+zfVj9AkmoJCzWvUe7pz1g1VCD
   24UcU/RXRP71MeTDLYfYuzh3TCsNTyjXskfABSJcloEakmKQXOtzJj9nD
   A==;
X-CSE-ConnectionGUID: d1mu8S0JQS2w0mdkv8DU4A==
X-CSE-MsgGUID: mkV2xtO3So2eujOR440MAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84799693"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="84799693"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 18:38:42 -0700
X-CSE-ConnectionGUID: uY/TCLgMS+m4grNmiAYdrQ==
X-CSE-MsgGUID: +s1uJOVaQrm5XjjUCn8xmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252056728"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO vcostago-mobl3) ([10.125.108.174])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 18:38:41 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>, Frank
 Li <Frank.Li@kernel.org>, Kristen Accardi <kristen.c.accardi@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Yosry
 Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Giovanni Cabiddu
 <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH 1/4] dmaengine: idxd: assign all engines to group 0 in
 IAA defaults
In-Reply-To: <1caa4de2-0aff-4281-8e5a-402b3278cb20@intel.com>
References: <20260713-iaa-crypto-fixes-zswap-v1-0-65cac23c684d@intel.com>
 <20260713-iaa-crypto-fixes-zswap-v1-1-65cac23c684d@intel.com>
 <90c8d0e8-99fc-4fd8-bdfd-f3093ffac256@intel.com>
 <1caa4de2-0aff-4281-8e5a-402b3278cb20@intel.com>
Date: Tue, 14 Jul 2026 18:38:40 -0700
Message-ID: <87y0fdowv3.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dave Jiang <dave.jiang@intel.com> writes:

> On 7/14/26 2:53 PM, Dave Jiang wrote:
>> 
>> 
>> On 7/13/26 9:10 PM, Vinicius Costa Gomes wrote:
>>> From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>>>
>>> The IAA device defaults only assigned engine 0 to group 0, leaving
>>> engines 1 through max_engines-1 unassigned (group_id = -1). This means
>>> that by default only a single engine processed descriptors, limiting
>>> throughput to one engine's capacity.
>>>
>>> Assign all available engines to group 0 so that the full hardware
>>> parallelism is used out of the box without requiring manual
>>> accel-config setup.
>>>
>>> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>> 
>
> Just noticed it's missing Vinicius sign off. 
>

Ugh, forgot those, will add for v2. Thank you.


Cheers,
-- 
Vinicius
