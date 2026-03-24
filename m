Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98026345741
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 19:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381475; cv=none; b=B3D0M8B9ZNb1c1TcWKO+9AoE+y5KHusR2X6pAfGKbYQMmiPPs/hOaTCqeyRmvNudA1W6v+IgFRa2V4qj81I1bIybnwAobAUvAViQ+VojTcxZzRwbUHb4nIzN8RD1OmezTdeEIQWOxNuEC2+9ReaTm0EZoReWvLZK2LHSk3zf6uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381475; c=relaxed/simple;
	bh=UziImsq7zUjs4NQ2kslg0HUFulUNI5cwJCWZ92dxJrs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dpEN4e7HatOqn01vIbAbrZAzg5UMRKI2vf87JxabjVpp2bEpwgcEC9Xs75eg+GvYQ1RrK/NzF7WEyC24Tsf2vbz5064cvlQ+cj1AQYOcrxMEAWxGr1lDTqZBHYtomhlciiSroPubbrCvjXqD1qQ17EiJRaz2oKqHsj13um1ymCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z9SCSqbK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z9SCSqbK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774381473; x=1805917473;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=UziImsq7zUjs4NQ2kslg0HUFulUNI5cwJCWZ92dxJrs=;
  b=Z9SCSqbK97YnvBb0zshd2bhJg3XTo4nohgVoVtg/0d0EiUfAF5u/KG/C
   msEG9Si9TNvz6+Fq87GjDL4WXmEqEkBJK9COwGQuOQdAlN5p6kiSDL3zl
   og80P5lygeCfGyX3gUU9PjWstn2jPMXIYW0ckLij1WC1rNyB1ytlvJgBz
   f1ilZLunxV8LYTS8XSMZkawRaqfRkAcs/WlbZlQ1IfAlSrTEALc+a1K3N
   yGd+LyR6JZMVchT4rqZFYxThlYyrer3MLVsTFuN9ezKm327YRCEXPvI69
   vRbSi59r4vi1CEcSH3N1577gZSuW8izWK4MWgI/UxG4Jkw3c9WJgFBczI
   Q==;
X-CSE-ConnectionGUID: C8x9xQQ4T4+IzfuJ+ViiAw==
X-CSE-MsgGUID: 893t0a9XTJ2sYnR0ZqAKgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86486826"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86486826"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 12:44:32 -0700
X-CSE-ConnectionGUID: KKx5/mYXTPeIHnM8tAQ+ag==
X-CSE-MsgGUID: uNW4RXIyR2yKNmT27sorgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="223661759"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.88.27.144])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 12:44:33 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 herbert@gondor.apana.org.au, kristen.c.accardi@intel.com
Cc: linux-crypto@vger.kernel.org, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: iaa - fix per-node CPU counter reset in
 rebalance_wq_table()
In-Reply-To: <20260324182912.123665-1-giovanni.cabiddu@intel.com>
References: <20260324182912.123665-1-giovanni.cabiddu@intel.com>
Date: Tue, 24 Mar 2026 12:44:31 -0700
Message-ID: <878qbh6mhs.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Giovanni Cabiddu <giovanni.cabiddu@intel.com> writes:

> The cpu counter used to compute the IAA device index is reset to zero
> at the start of each NUMA node iteration. This causes CPUs on every
> node to map starting from IAA index 0 instead of continuing from the
> previous node's last index. On multi-node systems, this results in all
> nodes mapping their CPUs to the same initial set of IAA devices,
> leaving higher-indexed devices unused.
>
> Move the cpu counter initialization before the for_each_node_with_cpus()
> loop so that the IAA index computation accumulates correctly across all
> nodes.
>
> Fixes: 714ca27e9bf4 ("crypto: iaa - Optimize rebalance_wq_table()")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


-- 
Vinicius
