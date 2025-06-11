Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C804244663;
	Wed, 11 Jun 2025 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676673; cv=none; b=ZKFwVRgUaXiBVN4vriF/04yNt00cS01dGBOY8g5/fJ0nWt2RtK6ZjTNz3C5v+dAGPyNAZ5+FF41m81tanpJqeW6dG5yPbkieRb4TzyIWO4hz1uDDNRTLE5jD7sr651uaJ14100U+r7w3aHdmphBAD/AIBR/ApeTGM22aZauuWsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676673; c=relaxed/simple;
	bh=S+LipCKWtqniA6VgzkhLx9Mj5Oe60IIUsMAQ1B//s/Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GHc7JUBK6mdhKBO9RCDZYgTiRGONhuX2CUnVt8bvsQqpBkU66VewdOXlK8yn7MiH7s/LiAFHFlYeJR+xEByRu7sLLL6fZzTsv0UaoqsFIdixNhrT8JBEusfyszp5jHJXTVBUna1hbM85uFY4wNTQ+8c12xnRpN07eH3TYhpZjT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJSwI2gi; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJSwI2gi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749676672; x=1781212672;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=S+LipCKWtqniA6VgzkhLx9Mj5Oe60IIUsMAQ1B//s/Y=;
  b=VJSwI2giPmAx+0exXoMaG+5K9OhP4TaekzWbMOcvenSYeinyjDl464oz
   ppAWlF+AoOwe80S1VM5v6lQyofM5DpNNV7GPqocEW0iAY+RmU9GifCqy7
   zFpms0yVf7VNwILgG2G865Auewt4+YPXz5XTptwL4WbBnIxmJk84vhIe+
   AN9tc3fD94z4eXsGK5VBE+WUFvtnxRIqUDbalbadtLu4jcBMQJr1qDufv
   MkSUjveZ/CiL9gqShEwMNlynicExzGFSawJ3oIpjd+auWVVr3/dAR/3Bm
   dbeuRwmXl/LnQPoejZD+cFYSStOojbjujMKS9MSbl7Xg3yP47OhlByb1L
   A==;
X-CSE-ConnectionGUID: BkUpkPbGRlqTF8WOH/x7Jw==
X-CSE-MsgGUID: QaPe45AHQgCEU5qQY13kDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51933720"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="51933720"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:17:51 -0700
X-CSE-ConnectionGUID: AyUrXfxOQvWhfcZggceskg==
X-CSE-MsgGUID: UF5g3Q3QTjGRe/vCcTgspg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="178263481"
Received: from unknown (HELO vcostago-mobl3) ([10.241.226.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 14:17:50 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>, "David S. Miller"
 <davem@davemloft.net>, Tom Zanussi <tom.zanussi@linux.intel.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix race condition when probing IAA devices
In-Reply-To: <aEjnbdoqzLoMifRn@gondor.apana.org.au>
References: <20250603235531.159711-1-vinicius.gomes@intel.com>
 <aEjnbdoqzLoMifRn@gondor.apana.org.au>
Date: Wed, 11 Jun 2025 14:17:49 -0700
Message-ID: <878qlyugea.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Jun 03, 2025 at 04:55:31PM -0700, Vinicius Costa Gomes wrote:
>>
>> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
>> index 23f585219fb4..2185c101bef3 100644
>> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
>> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
>> @@ -35,28 +35,39 @@ static unsigned int cpus_per_iaa;
>>  
>>  /* Per-cpu lookup table for balanced wqs */
>>  static struct wq_table_entry __percpu *wq_table;
>> +static DEFINE_SPINLOCK(wq_table_lock);
>
> This can be called in BH context so you need to disable BH when
> taking the spinlock.
>

My tests with lockdep enabled must have missed something, will verify
and fix this.

>>  static struct idxd_wq *wq_table_next_wq(int cpu)
>>  {
>> -	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
>> +	struct wq_table_entry *entry;
>> +	struct idxd_wq *wq;
>> +	int id;
>> +
>> +	guard(spinlock)(&wq_table_lock);
>> +
>> +	entry = per_cpu_ptr(wq_table, cpu);
>
> You're taking a global spinlock around a per-cpu variable.  In that
> case you might as well get rid of the per-cpu variable and use the
> spinlock only.
>

From what I could gather, the idea of the per-cpu workqueue table ("map"
really) is more to "spread" the workqueues to different CPUS than to
reduce contention.

If the question is more about the choice of using per-cpu variables, I
can look for alternatives.

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Cheers,
-- 
Vinicius
