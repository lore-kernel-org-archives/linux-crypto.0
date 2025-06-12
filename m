Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DB818CC1D;
	Thu, 12 Jun 2025 23:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769792; cv=none; b=nRJ8lJFy5JsR07WJ16G07AcoV82F2+qn7of7MG0mIQMP6fB2dOvm6vUMQqJCNV3DwG9upLWQPnytnsxXoZR4PMtYBzStW5G0CphAptt96hYet44X3rew6j60+imc5B4JHsWt161FUV3OLNL4diNT901QgJ5fN24ZwFtQa9FjKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769792; c=relaxed/simple;
	bh=BXwHG2qudgkITh3YDB4mez2Ozgw6n+T3YbBgSyNz5Yc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kHRxSaYGpuiPvBVvWDA9v2GIg5wXigcyjbSULNCjY/mMopAoh3JS9/IU02eaV/8ELKSklJxNJFxzHMwyqN7o6GjNhCpd0WiVMr0jJr3DB5YhmXJMss2Pv+V5mx42oUV7cJbEOwrt4qMmQj6JdI3Qw3Rcfpr8LssHbYVMOQYOUsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=faeHGAQT; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="faeHGAQT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749769791; x=1781305791;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=BXwHG2qudgkITh3YDB4mez2Ozgw6n+T3YbBgSyNz5Yc=;
  b=faeHGAQTUoOeQ6ZsWhzw6D/yv/NxWCj9LwUuJtOts/TIuPVNrao4kBtb
   bcvanBx9apimYbvFCzEnAKC8G93lvAqa8yZX0SEpCKqm35CeviQBlctyK
   UyHJOh6Yr8Mm6I0w6y9AIfpJ3fX2gzyDJQ7/sVg1jxHkPY6c7f1twcn1v
   IgjSSZL07Ryf3+HWh/B5mrZM76SCTOWEg0odqHbi3lM8EXzVy9sCVv8Cs
   Lc1jRyWVwcZEQPpjUsc+9K5AFRrGr/Utmu+aSnWX4easuPadNWtBE3zum
   Z/9DvwGo6bKv7pv5PXNFiKvfxP6i3c3WW1QBtFdNPVX/fiKWT6u6EjeAk
   w==;
X-CSE-ConnectionGUID: unRk1cMvQpSq2VXESzFmsQ==
X-CSE-MsgGUID: Yx5tf/cFSwmVssDgEXHgiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="74501287"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="74501287"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 16:09:50 -0700
X-CSE-ConnectionGUID: H6PAIMCESeen2bH58cIwEA==
X-CSE-MsgGUID: A5LZmhLvTT++P3wZtJYNBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="148551513"
Received: from unknown (HELO vcostago-mobl3) ([10.241.226.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 16:09:50 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>, "David S. Miller"
 <davem@davemloft.net>, Tom Zanussi <tom.zanussi@linux.intel.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix race condition when probing IAA devices
In-Reply-To: <aEpn0B6CrMNcD-Oj@gondor.apana.org.au>
References: <20250603235531.159711-1-vinicius.gomes@intel.com>
 <aEjnbdoqzLoMifRn@gondor.apana.org.au> <878qlyugea.fsf@intel.com>
 <aEpn0B6CrMNcD-Oj@gondor.apana.org.au>
Date: Thu, 12 Jun 2025 16:09:49 -0700
Message-ID: <87qzzo8sle.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Jun 11, 2025 at 02:17:49PM -0700, Vinicius Costa Gomes wrote:
>>
>> >From what I could gather, the idea of the per-cpu workqueue table ("map"
>> really) is more to "spread" the workqueues to different CPUS than to
>> reduce contention.
>> 
>> If the question is more about the choice of using per-cpu variables, I
>> can look for alternatives.
>
> Prior to your patch, the compress/decompress paths simply did a
> lockless per-cpu lookup to find the wq.  Now you're taking a global
> spinlock to do the same lookup.
>
> That makes no sense.  Either it should be redesigned to not use
> a spinlock, or the per-cpu data structure should be removed since
> it serves no purpose as you're always taking a global spinlock.
>

Will think a bit harder on this. It could be the code is trying too hard
being smart and there's a easier/simpler way out. I was only trying to
solve a bug that some folks found.


> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Cheer,
-- 
Vinicius
