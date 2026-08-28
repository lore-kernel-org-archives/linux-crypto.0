Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D60638BF70
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 21:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787954051; cv=none; b=Je7JNqz4eruzzrQ4t8iYrGIeaclZGl558YjEVyJ4tPUZF+883vpP1B3GnJyXzqMct328jMcXDj2Yo4N/r22Ci2DjFyY8gfRhOqMyTu22iTSOrgL8ZdYlyIcsiLpEiDrtf8JpsJCo05J6KrYb8wzz46LoI6nCVJZ8MabvZ9X2IVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787954051; c=relaxed/simple;
	bh=5+eRRSBmCBRgSPBWzjUGNn9aTqnNzTiJA7y5CU2N/Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwGglFeU9iIP+z4sht7Iwo/JsnDt2v/0mifsORp48LXFJvcvU1Q2M8d+Gi+nWRDaM127MdhHMlCoBr9qNXppAP+o9xD949j6lk50fANpRboB+ndpwqWOFYSdvgb2vPYAsbq1Asa6bUS3tncgX0iuDFzcqtBJ9kYevNWFCy1w7Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ly9si7oY; arc=none smtp.client-ip=95.215.58.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ly9si7oY"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5+eRRSBmCBRgSPBWzjUGNn9aTqnNzTiJA7y5CU2N/Gc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787954048; v=1; x=1788558848;
 b=Ly9si7oYdpchxRPRjQuhwGTeuxijO5pRC4uJ/6u5kXTq2WXQ8P7KYtaz0Eb+CsblB9aW0Ntr
 aVWo5NuMe4Di1aX5rtpd4cLoydTqB/h6p3AWYVvhp6iHqLnI00QV83wc0gMXmP8LNHdtWNZA4T3
 fr6W1FjIry6OersGa1QI22o4=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a377096cbc5bc423;
	Fri, 28 Aug 2026 21:54:08 +0000
X-Mizu-Trace-ID: a377096cbc5bc423
X-Migadu-Flow: FLOW_OUT
Message-ID: <c0bca273-1395-419a-a2eb-5627f2243452@linux.dev>
Date: Fri, 28 Aug 2026 22:54:07 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per
 context
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, David Sterba <dsterba@suse.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Nick Terrell <terrelln@fb.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, yosry@kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kernel Team <kernel-team@meta.com>
References: <CAHk-=whZf9=X+qKkO9_pQzbLdOnbMw5yO8gu0TkahegVW3cC-g@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAHk-=whZf9=X+qKkO9_pQzbLdOnbMw5yO8gu0TkahegVW3cC-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 28/08/2026 21:19, Linus Torvalds wrote:
> [ Sorry for breaking threading - I have turned off IMAP access to my
> mailbox, and so I have issues replying to lore messages sanely ]
> 
> On Thu, 27 Aug 2026, Usama Arif wrote:
>>
>> On 27/08/2026 03:39, Eric Biggers wrote:
>>>
>>> Why not just use cpu_feature_enabled(X86_FEATURE_BMI2), which compiles
>>> down to a static branch?  All these issues are caused by lib/zstd/ using
>>> its own custom CPU feature detection code, instead of the normal CPU
>>> feature detection code that the rest of the kernel uses.
> 
> Yes, please. The zlib code is just broken in how it makes up its own
> random inine asm that is actively worse than what the kernel already
> exposes.
> 
>> The only issue I saw with that was that zstd is a standalone library that
>> is imported
> 
> Let's ignore that part, and just make it work right. The Zstd people
> should think about this problem on their side.
> 
>> Keep the existing raw CPUID fallback for preboot and other builds which
>> cannot use the normal x86 feature infrastructure. Also retain the early
>> return when dynamic dispatch is disabled.
> 
> No, this is not great, that whole
> 
>         cctx->bmi2 = ZSTD_cpuSupportsBmi2();
>         ...
>         if (bmi2) ...
> 
> model in zstd needs to just die.
> 
> For the kernel, the whole dynamic "test a variable" model is simply wrong.
> It should expand to
> 
>         if (cpu_feature_enabled(X86_FEATURE_BMI2))
> 
> because for the kernel, that becomes a simple static branch.
> 
> When zstd goes through that variable, it loses that entirely and
> instead turns it in a static assignment and then a dynamic test (well,
> not "entirely" - with inlining it could still recover the right code).
> 
> So zstd really should be fixed to get rid of that bad
> 
>         #if DYNAMIC_BMI2
>             if (bmi2) {
>          ....
> 
> pattern entirely, and be taught to have a *helper* macro that just turns
> into 0 for when DYNAMIC_BMI2 is not set, and turns into using that stupid
> flag in user mode, and for the kernel it should just turn into that
> "cpu_feature_enabled(X86_FEATURE_BMI2)"
> 
> Why does it check for both BMI1 and BMI2 anyway? And Arif added an
> extra check for ABM. That all looks bogus. You can't have BMI2 without
> having BMI1, so all this code looks completely bogus to begin with.
> 

The three checks came from interpreting BMI2_TARGET_ATTRIBUTE("lzcnt,bmi,bmi2")
as requiring all three feature bits. Agreed that this is unnecessary here.
The kernel path should check only X86_FEATURE_BMI2.

I was also trying to preserve zstd’s standalone-library behavior.
I will instead make normal x86 kernel builds use a helper that expands directly to
cpu_feature_enabled(X86_FEATURE_BMI2) at each dispatch site. The stored BMI2
context flag and private CPUID probe will be removed from that path.
Preboot and standalone builds will retain their existing caller-provided 
lag and CPUID-based detection.

I will send a revised patch in a little bit.

Thanks!
Usama
