Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353823612DD;
	Wed, 11 Mar 2026 22:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773267641; cv=none; b=qbx0PUQhFzmMDT0C0onmq+DNCfO4ORD1DMecDCiuD+lsI5t64oIjvAdGhqMRe5KU6J5FlwMVIBv+SBhz4RBwlba42VIHYqCb8mtWXgA/vHrkcfpnCMbq1v3h60bpVzCcNXMffE7Oiw0xzjoHcOo5fS247ZGt4qTWNdUWnNRuZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773267641; c=relaxed/simple;
	bh=/d9DhITUST8uE1rImPVyYQNvyz3gCjHjmkCyUv3Dx0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOwyVgzQxDBl8OXqzGmfRRigdoRZIzX7bZxnA+MoX8r9oZ2i8iYgY+TPvZjlxd7RK8eaBvmijKEVh0ORvzThW/qi05xKv3EfT1KDb1fWTS4wRxosHWe87w0p2vC91rkfdYq7iURwqnAMWzQutLWzlJj3L1dytLRgaZoQsTqjoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKJu05jg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKJu05jg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773267639; x=1804803639;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/d9DhITUST8uE1rImPVyYQNvyz3gCjHjmkCyUv3Dx0M=;
  b=IKJu05jgE+4HjBpHE+8/1il2qbnfcJ5SAUK9TZoAfDTJRc+JIvJQ66tf
   YaOdHlx63dF3uC/3Oe3jLxgM/lYXa4S8/ehRy2VU5D/h/uj9A3lutoxyi
   7euFg21nwvoffqyprPmCGXpmEzj0/e1cpCl4BbZBWibiZX8OBWYySGlVV
   9h6CAUS32gdisBEB2UPhXdk8kmKhqbzkWgwNPiopbEDH4wsPHo99541kb
   z+46yrZWTDYmgN2efos/m0U0UyvK9zOvkwHDJDGnSscqpGbvqYpibDwGC
   CBZY1g9Q5SatgW44HwLmM3CHQTZScgY5W1wHlbcLjEMl6ip7H0T5i2rWm
   Q==;
X-CSE-ConnectionGUID: EPI9Nr+NRw+idsqd+IGVVg==
X-CSE-MsgGUID: oVYV0FwNRyuajDNSPXTW4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="99817461"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="99817461"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 15:20:39 -0700
X-CSE-ConnectionGUID: dEw+9dr5TNunbwVKAyktMA==
X-CSE-MsgGUID: 2GOiho/AROKnXbgk+YriwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="216803428"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.84]) ([10.125.110.84])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 15:20:36 -0700
Message-ID: <5102edd8-8eaa-4688-b3f7-3004c4cbc8f3@intel.com>
Date: Wed, 11 Mar 2026 15:20:50 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: "Kalra, Ashish" <ashish.kalra@amd.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
 Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <aahH4XARlftClMrQ@google.com>
 <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
 <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
 <6a4f4ecf-ffc0-43a9-98d4-06235b42063e@amd.com>
 <d7ba3790-a959-4150-87e0-c87dea4d09c5@intel.com>
 <cc9bf918-a14b-4619-a084-3f424fa16ea1@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <cc9bf918-a14b-4619-a084-3f424fa16ea1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/26 14:24, Kalra, Ashish wrote:
...
> There are 2 active SNP VMs here, with one SNP VM being terminated, the other SNP VM is still running, both VMs are configured with 100GB guest RAM: 
> 
> When this loop is executed when the SNP guest terminates:
> 
> [  232.789187] SEV-SNP: RMPOPT execution time 391609638 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~391 ms
> 
> [  234.647462] SEV-SNP: RMPOPT execution time 457933019 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~457 ms

That's better, but it's not quite what am looking for.

The most important case (IMNHO) is when RMPOPT falls flat on its face:
it tries to optimize the full 2TB of memory and manages to optimize nothing.

I doubt that two 100GB VMs will get close to that case. It's
theoretically possible, but unlikely.

You also didn't mention 4k vs. 2M vs. 1G mappings.

> Now, there are a couple of additional RMPOPT optimizations which can be applied to this loop : 
> 
> 1). RMPOPT can skip the bulk of its work if another CPU has already optimized that region.
> The optimal thing may be to optimize all memory on one CPU first, and then let all the others
> run RMPOPT in parallel.

Ahh, so the RMP table itself caches the result of the RMPOPT in its 1G
metadata, then the CPUs can just copy it into their core-local
optimization table at RMPOPT time?

That's handy.

*But*, for the purposes of finding pathological behavior, it's actually
contrary to what I think I was asking for which was having all 1G pages
filled with some private memory. If the system was in the state I want
to see tested, that optimization won't function.

> [  363.926595] SEV-SNP: RMPOPT execution time 317016656 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~317 ms
> 
> [  365.415243] SEV-SNP: RMPOPT execution time 369659769 ns for physical address range 0x0000000000000000 - 0x0000020000000000 on all cpus -> ~369 ms.
> 
> So, with these two optimizations applied, there is like a ~16-20% performance improvement (when SNP guest terminates) in the execution of this loop
> which is executing RMPOPT on upto 2TB of RAM on all CPUs.
> 
> Any thoughts, feedback on the performance numbers ? 

16-20% isn't horrible, but it isn't really a fundamental change.

It would also be nice to see elapsed time for each CPU. Having one
pegged CPU for 400ms and 99 mostly idle ones is way different than
having 100 pegged CPUs for 400ms.

That's why I was interested in "how long it takes per-cpu".

But you could get some pretty good info with your new optimized loop:

                start = ktime_get();

                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
                        rmpopt() // current CPU

                middle = ktime_get();

                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE)
                        on_each_cpu_mask(...) // remote CPUs

                end = ktime_get();

If you do that ^ with a system:

	1. full of private memory
	2. empty of private memory
	3. empty again

You'll hopefully see:

	1. RMPOPT fall on its face. Worst case scenario (what I want to
	   see most)
	2. RMPOPT sees great success, but has to scan the RMP at least
	   once. Remote CPUs get a free ride on the first CPU's scan.
	   Largest (middle-start) vs. (end-middle)/nr_cpus delta.
	3. RMPOPT best case. Everything is already optimized.

> Ideally we should be issuing RMPOPTs to only optimize the 1G regions that contained memory associated with that guest and that should be 
> significantly less than the whole 2TB RAM range. 
> 
> But that is something we planned for 1GB hugetlb guest_memfd support getting merged and which i believe has dependency on:
> 1). in-place conversion for guest_memfd, 
> 2). 2M hugepage support for guest_memfd and finally 
> 3). 1GB hugeTLB support for guest_memfd.

It's a no-brainer to do RMPOPT when you have 1GB pages around. You'll
see zero argument from me.

Doing things per-guest and for smaller pages gets a little bit harder to
reason about. In the end, this is all about trying to optimize against
the RMP table which is a global resource. It's going to get wonky if
RMPOPT is driven purely by guest-local data. There are lots of potential
pitfalls.

For now, let's just do it as simply as possible. Get maximum bang for
our buck with minimal data structures and see how that works out. It
might end up being a:

	queue_delayed_work()

to do some cleanup a few seconds out after each SNP guest terminates. If
a bunch of guests terminate all at once it'll at least only do a single
set of IPIs.
