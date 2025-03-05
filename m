Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DAE19067C;
	Wed,  5 Mar 2025 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197877; cv=none; b=KTliw7v4Hh+GJcY8AM2dsfdiFblPTZJKMhv81F0BcbbfqTxzyCN6JB+xXSAYaqsp25ietfvvbF3LtIR4vsbDQ+X9oZb78818yHzclA2QA9/U8ZorHBQd0DOBtot3pXReD+gsUd8rCSTdRWlLDpf0SS+ZJlQxpXKQ9gKau9m1wlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197877; c=relaxed/simple;
	bh=BtD0jXPwnPj/HyDrO5pdGQamGBGIgoaMDHMcTEOGTvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fdQHVAGWH0XOOY3v9jG/EyutWVfy5o7WAkYFmlufcKuPrH7R6PARB0PUvs8RqVLs2DTokausDV0o88OyW3Mm8ktxnHZ6n5CpPOlHBSSoDpYj4rFsblL6f++u084GlRkFBdni6EmtZALgzSNjZ4btDBreWVV4F9/8fq8zd+p8bXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZrnHjDhm; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZrnHjDhm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741197875; x=1772733875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BtD0jXPwnPj/HyDrO5pdGQamGBGIgoaMDHMcTEOGTvI=;
  b=ZrnHjDhmLXUxMLo1h0+of72EAHtQo7uNTqyyAzOYZj9oKVjokO5f9i6k
   IUu/Wz9dtMtPGzJtJsDk1yHKGfNLqhlfdSiU+8R2i01l5jNIsjTEJ3YHM
   zfPYynY4s+jfirPFLkxc6gyKkuXdOFtSFiafK9LI/xIgfPppYiEbsD7/V
   NBkiY9McBSdwET135yiCoSbW0cyvL5ahF+qRWGm1CUYovDEtGhHCYFU11
   umXVTX4O5dvWACWcrW2Ces4fcc5VSTDkBwGxo8xxL3/VgTgNHuys/FVbm
   l/Wlk93R1RKwVDuE8gKuYhwbPQ8/yAAoDhld//u/OhYuKUm8QjlnL5Ojq
   w==;
X-CSE-ConnectionGUID: aHOxS9+WS/u3XCmhQnE/QQ==
X-CSE-MsgGUID: dKMV4uJ7TsCJnUIc2TxziA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41350895"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="41350895"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 10:04:34 -0800
X-CSE-ConnectionGUID: lkDykKfvSDC3MQpZT1WUCA==
X-CSE-MsgGUID: uP8R6ut1Q/6S0Q1q70+IHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="118481595"
Received: from kcaccard-desk.amr.corp.intel.com (HELO [10.125.109.196]) ([10.125.109.196])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 10:04:34 -0800
Message-ID: <65c29e20-8d63-4323-b2e5-09e2e7bf3c1c@intel.com>
Date: Wed, 5 Mar 2025 10:04:54 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ben Greear <greearb@candelatech.com>,
 Xiao Liang <shaw.leon@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com> <b6a80f6d-8469-429d-b03a-8fa71a33046b@intel.com>
 <Z8iL1dY3o9OxQgBy@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <Z8iL1dY3o9OxQgBy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/25 09:37, Ingo Molnar wrote:
> 
> * Dave Hansen <dave.hansen@intel.com> wrote:
> 
>> On 3/5/25 01:07, Ingo Molnar wrote:>> Alternatives considered:
>>>> - Make kernel-mode FPU sections fully preemptible.  This would require
>>>>   growing task_struct by another struct fpstate which is more than 2K.
>>>
>>> So that's something that will probably happen once the kernel is built 
>>> using APX anyway?
>>
>> I was expecting that building the kernel with APX would be very 
>> different than a kernel_fpu_begin(). We don't just need *one* more 
>> save area for APX registers: we need a stack, just like normal GPRs.
> 
> Yes - but my point is: with any APX build we'd probably be saving 
> FPU(-ish) registers at entry points, into a separate context area. If 
> that includes FPU registers then we'd not have to do 
> kernel_fpu_begin()/end().

That's true. But wouldn't it be a bit silly to include _all_ FPU
registers? If the kernel isn't using AVX512, why bother saving and
restoring AVX512?

> In other words, we'd be doing something close to 'growing task_struct 
> by another struct fpstate', or so - regardless of whether it's in 
> task_struct or some sort of extended pt_regs. The kernel would also be 
> close to 'FPU-safe', i.e. there likely wouldn't be a need for 
> kernel_fpu_begin()/end().
The new APX registers are 128 bytes, total. 'struct fpstate' is ~3k on
most CPUs these days and >11k with AMX.

I was thinking that growing things (say pt_regs) by 128b would be
acceptable, given some nice performance gains from AMX. Growing by 3k
would be cause some real headaches. Growing by 11k would be a non-starter.

I'm pretty sure the torches and pitchforks would come out if our syscall
latency included another 1k of save/restore much less 3k or 11k.
