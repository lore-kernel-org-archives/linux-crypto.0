Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522887;
	b=VoUm6L2dTZAv6j1UmcbnRh/x4Jnvv3ZDrflxVH6Bb9A7541p32Lx/+MaRKYlyHp7N5Lw
	 Fi4LyqO20pbbXK7Go/x2GZmdmUw7BqzCapRNkn0/fFEOPjQ5p/LrzpTecb2QFk+7bTYmr
	 3L9UPlpL+wMcd+RRfzRBpvUV9MWou8TEj7wDcREr10e2KzNQmMMYgVUIc0Asoy2uRHFYd
	 swU3MiJDwT7bWHS07NzE9fpjK2nub85KxhAXcQ3D63TWZLCdOPbz31ei7Ko/Zx7gfh52y
	 9PMmyiDZ9S4gnr68jg0ZoNlFF4GC1Q4s36MLZAnb8QrxYMKhxsibu81o/lQq1gytWNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522887;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type;
	bh=stCSDCk1Xz9wPGWW1xwLdd2SYAWvhjzP8nY3HJs1wdU=;
	b=eA3u3fZEk4pjQO3kgwoZSeb13j1/VrXmKrpHyJZjhQfyLsyVqRMvc5qNEoJ7GK+S4VR5
	 O06ViZM7SwGmouf6P5kmxh5dV30nayymT9EfxS4kPSBy1wYAtoiT4s3hJyNqnhShHgGim
	 HICwu5EPMPbjV/cRXY7eHO1eOubBqq6R8v9I4uk2rpvbOMZCILOJQ4RLCr/v8NCcB9oN3
	 egtRayVDRMjkYcTrUBtBvYj3kA27KfK/28JrQU+ERxNbTyaFLHINC0lHjfLVR3zPn0oJ1
	 5rIIpsxmEX8+0A06IoQWpFSGzvUVTM+iZSpP1HDGD1NJd4icccTqvdDRHwPtvhKXumQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fi6Dqt0V;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8696C606A323;
	Thu, 12 Nov 2026 22:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8696C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fi6Dqt0V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794522888; x=1826058888;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=GnYlyiHsQlWyu80oZdVgy0nS70dYZn1om8cq+Q2hwLo=;
  b=fi6Dqt0VTjF+2WHStac0ZPX+t7kpx0DD8WLOR8u6pLKBfWg8C/LSYdr2
   vstCOwD5+s3Q6kvvIW7GsqgKmtHmcct7UoNvGVLHUK7aWxpvXH4f9YaWC
   SppWcFb6ghbs7QG0p64T0nGyRwxzlzhwdoJLSjo5QHWqj30Yk2CDcQDQl
   6xwr6IFt2y9DSspvr+uTgl+pcWU0k0HaM6YvVYUxf38XmIa6mvSPpH6Yv
   uFPXIZygPrRUll3YCJnqo0Bj4Qs6dZciS5p1bfmFzwUHjQPuh2CEcaDV2
   9+vi4saoOWnnkPUIG3yVeZHlqHUoMVtepxYwD/5Y0OLJ5tu1qNAlX4912
   Q==;
X-CSE-ConnectionGUID: 36qICpPWT3een8bIKOUnXg==
X-CSE-MsgGUID: 3wo1nL7yQ3yZPO4QjDQNTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3181922"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3181922"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 14:34:48 -0800
X-CSE-ConnectionGUID: A1hu9ftDQMWpmm3BF2lIXQ==
X-CSE-MsgGUID: Xbn59vmBSn+BHgZPRHv4/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="8846765"
Received: from vcostago-desk.jf.intel.com (HELO vcostago-desk) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 14:34:47 -0800
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>, "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: iaa - use RCU per-package WQ tables
In-Reply-To: <avRHIuISSNUxfAU4@gondor.apana.org.au>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
 <20261019-iaa-crypto-wq-tables-v1-3-fab67b2a1538@intel.com>
 <avRHIuISSNUxfAU4@gondor.apana.org.au>
Date: Thu, 12 Nov 2026 14:34:46 -0800
Message-ID: <87pkw9u1a1.fsf@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Hi,

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Mon, Oct 19, 2026 at 04:06:22PM -0700, Vinicius Costa Gomes wrote:
>> rebalance_wq_table() gives CPU n all the WQs of IAA device
>> n / cpus_per_iaa. The flat index ignores package boundaries, so a CPU
>> can be paired with a device on another package, and each CPU sends all
>> its requests to one device while the other devices of its package stay
>> idle. The table is also rebuilt in place, so a request issued during a
>> probe or remove can read a NULL WQ and fail with -ENODEV.
>> 
>> Replace it with one table per package, holding the WQs of every IAA
>> device on that package, and have each CPU round-robin over its package's
>> table. Rebalance builds the whole set of tables and publishes it with
>> rcu_replace_pointer(). The submit paths look the WQ up, and take their
>> reference on it, inside an RCU read-side section.
>> 
>> - A package without IAA devices gets a copy of another package's table,
>>   so the lookup needs no fallback.
>> - Every table has room for all the WQs, a few pointers more than it
>>   needs, so they can be sized without counting per package.
>> - If a rebalance fails, the current tables are kept. On removal they
>>   are cleared instead, because they still hold the removed WQ. Removal
>>   then waits for a grace period before returning, because the idxd_wq
>>   can be freed after that.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>>  drivers/crypto/intel/iaa/iaa_crypto.h      |   7 -
>>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 346 ++++++++++-------------------
>>  2 files changed, 117 insertions(+), 236 deletions(-)
>
> Please respond to this comment:
>
> https://sashiko.dev/#/patchset/20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538%40intel.com
>

Weird that I haven't received any notification about these comments.

Anyway, as I moved some code around, sashiko considers it a "new" issue,
but from a quick look, it's a pre-existing one. Doesn't seem too hard to
fix, will include the fix on v2.


Cheers,
-- 
Vinicius
