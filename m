Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F5D2F8E95;
	Thu, 18 Jun 2026 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781818881; cv=none; b=P3+yI/sjoVYm7XwwqHw62zsZznJigqxqLzBSAjO1WbL5cmYifdg3Jb0GuH+SHDWRyeVPMAwDUnILR1QPKFoFXn7A6p+oxw5qymj1jAgnG32YRSlmpDhgUKCZRFmon8j+JcltRxirq3K1VLjUHOfuPgRslrVrQz5ckO9pdcksnRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781818881; c=relaxed/simple;
	bh=EqQh7sQyjfQ2i+UlpLfY06A5FPB68Rxqhw+Rc+NXTCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fKUHqLOANk3L9/92zw8Azzsq4VB/a5wni+KEAevOMv9PrgCJAItjnOVaIMK8ZjpYVP2LSqd8Q0NA9A/fbMM/S/TldZYKN93Yz5Gw1JQg6JLGAib67udenBVLk0TB9UdamJK/sIxh2Z2fwRFTNOVh5L100OplswuiAjkEERakdCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=faUyffYK; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="faUyffYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781818880; x=1813354880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EqQh7sQyjfQ2i+UlpLfY06A5FPB68Rxqhw+Rc+NXTCk=;
  b=faUyffYKThDQuavOg/ZjKv6MEYkae+xiEFu8hxHryPjXxAuKVSsF3GBw
   cWubA1/H5jhoTmYFt12dtOLuBmrTP+Kj2qA9A4NsR899zxZ6DidmDSFka
   ZCGFcL+//2A7Du+21UAfdnf2hm1TvkMN6N9HZ83+mURPdCA8vLu4jjeo9
   zOd41zPk75Eq6WMtB+JAiXym2XOLKZZAYY5zSoqRNHsfSmWeA6JYnrRUV
   tA+qrD45aRDX8CsaOyUo6gK5o/MM9M5OKsgxGILIuQ9B6Er+1Hu1s42VK
   yHzKj558B0LJ+n93LrFkopDMVW7mrpP/C4xDDDSUGRoaFXPqp3DvvBLuY
   w==;
X-CSE-ConnectionGUID: 4ud04ZjtTvC+JdTcC3C0Tg==
X-CSE-MsgGUID: ltbalLxHTWKxb8M+HmPYyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="82550580"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="82550580"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 14:41:19 -0700
X-CSE-ConnectionGUID: sOE3iEX8SBuneScJ3sT2IQ==
X-CSE-MsgGUID: eFXa3WRBQBGL6rsmYIjcYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="245559936"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.222]) ([10.125.111.222])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 14:41:18 -0700
Message-ID: <060e3ab5-4632-413d-aed6-2fd99d782fac@intel.com>
Date: Thu, 18 Jun 2026 14:41:17 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] x86/sev: Add interface to re-enable RMP
 optimizations.
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <cdb8098074de8e150dcf534ab806e38744325a57.1781419998.git.ashish.kalra@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <cdb8098074de8e150dcf534ab806e38744325a57.1781419998.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/26 12:49, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> RMPOPT table is a per-CPU table which indicates if 1GB regions of
> physical memory are entirely hypervisor-owned or not.
> 
> When performing host memory accesses in hypervisor mode as well as
> non-SNP guest mode, the processor may consult the RMPOPT table to
> potentially skip an RMP access and improve performance.
> 
> Events such as RMPUPDATE can clear RMP optimizations. Add an interface
> to re-enable those optimizations.

This doesn't really help me understand when or how this function might
be called.

	Normal guest evens like splitting and collapsing large pages can
	clear RMP optimizations. Without some intervention, all RMP
	optimizations would eventually be lost. Periodically re-optimize
	the system.

> The interface uses mod_delayed_work() instead of queue_delayed_work()
> so that the delay timer is reset on each call. This provides proper
> batching semantics: re-optimization runs 10 seconds after the *last*
> VM termination rather than after the first. mod_delayed_work() also
> re-queues work that is already in-flight, so a re-scan request
> during an active scan is not silently dropped.

This seems sane.

> +void snp_rmpopt_all_physmem(void)
> +{
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_configured)
> +		return;
> +
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	if (!rmpopt_wq)
> +		return;
> +
> +	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
> +			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
> +}
> +EXPORT_SYMBOL_GPL(snp_rmpopt_all_physmem);

Does this need to be globally exported? Or can it be exported to a
single module namespace?

I'm close to being able to ack this, but it's still got a few too many
nits to ack.
