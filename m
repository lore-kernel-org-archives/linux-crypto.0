Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BC914E2CC;
	Mon,  9 Dec 2024 19:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733772963; cv=none; b=nRNIoFp2L/P0rSYUD5RD2/w/gIy34oMQX6RPQUDu74P9E7dZknWre+ku80GNEIGU8oEoDUEEmn5O3F9WJA2uyRO7Ea+Y9+3EwQ1pC7ld0HuAG6WBBAvR4bQ6JOfbqSrka0v9zBwybOxWY3h7nTSiJAMf9U00QVrDoWefO0fUItM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733772963; c=relaxed/simple;
	bh=Q5rZxy0kJibOV6Sj3CPasPQPWuPDGx1ot+UAxBTJ2cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKLDqwp0FfEoSS4x2jm7tXlFa/VYx/NMSXnBzdG4uJFwjILW2IEBJvF2DGOmVVifJWG2AGteFVDfDWRG78g7zWcg1F4UUDO5UPlDxvoqe5HHBu22MKsP8vueIN0EvzNLCHy3w9EopDEjQbm2ZHY+DR95izZhf25Gg1YzRFJzW14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVp4UZ9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVp4UZ9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52CEC4CED1;
	Mon,  9 Dec 2024 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733772963;
	bh=Q5rZxy0kJibOV6Sj3CPasPQPWuPDGx1ot+UAxBTJ2cA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZVp4UZ9GtGupfceM2V8krYGkLZAydHOXQ2ixoOngZxD0qm9p2TBcINe5h43dUlDj4
	 zwwGVhl6CIsMG8klnNtAhgKgonm/Hkhoa59yZtnAVs0k8WiCu/kyQkSqmyLD2oKtbB
	 jGfWZF1V6x8tb9j2QS41xi8cZZDb3BZL/9THlbDQf6n1uoDALOLdeddHOFb6xOQO4I
	 48SVDH7CXRkIEbaB6w34xUVfGMfH8hJe3tV/1M6l/yExYF/I9PLhjnkHDmSB/1U2A5
	 XAbAMd1v+fBUWhgnzAhj1SEFPknHLmHx+Yc67HZ3nGgvg0E8jApEvfehIEKVnAhCbA
	 +0cR9A69HHThw==
Date: Mon, 9 Dec 2024 12:35:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <20241209193558.GA1597021@ax162>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <Z1XkhhBqFYtbvQYp@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1XkhhBqFYtbvQYp@yury-ThinkPad>

On Sun, Dec 08, 2024 at 10:25:21AM -0800, Yury Norov wrote:
> On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
> > So the above statements expands to:
> > memcpy(pinst->cpumask.pcpu->bits, pcpumask->bits, nr_cpu_ids)
> > memcpy(pinst->cpumask.cbcpu->bits, cbcpumask->bits, nr_cpu_ids)
> > 
> > Now the compiler complains about "error: ‘__builtin_memcpy’ reading
> > between 257 and 536870904 bytes from a region of size 256". So the
> > value of nr_cpu_ids which gcc calculated is between 257 and 536870904.
> > This looks strange and incorrect.
> 
> Thanks for the detour into internals. I did the same by myself, and
> spent quite a lot of my time trying to understand why GCC believes
> that here we're trying to access memory beyond idx == 256 and up to
> a pretty random 536870904.
> 
> 256 is most likely NR_CPUS/8, and that makes sense. But I have no ideas
> what does this 536870904 mean. OK, it's ((u32)-64)>>3, but to me it's a
> random number. I'm quite sure cpumasks machinery can't be involved in
> generating it.

That can also be written as (UINT_MAX - 63) / 8, which I believe matches
the ultimate math of bitmap_size() if nbits is UINT_MAX (but I did not
fully verify) in bitmap_copy(). I tried building this code with the
in-review -fdiagnostics-details option from GCC [1] but it does not
really provide any other insight here. UINT_MAX probably comes from the
fact that for this configuration, large_cpumask_bits is an indeterminate
value for the compiler without link time optimization because it is an
extern in kernel/padata.c:

| #if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
| #define nr_cpu_ids ((unsigned int)NR_CPUS)
| #else
| extern unsigned int nr_cpu_ids;
| #endif
| ...
| #if NR_CPUS <= BITS_PER_LONG
|   #define small_cpumask_bits ((unsigned int)NR_CPUS)
|   #define large_cpumask_bits ((unsigned int)NR_CPUS)
| #elif NR_CPUS <= 4*BITS_PER_LONG
|   #define small_cpumask_bits nr_cpu_ids
|   #define large_cpumask_bits ((unsigned int)NR_CPUS)
| #else
|   #define small_cpumask_bits nr_cpu_ids
|   #define large_cpumask_bits nr_cpu_ids
| #endif

From what I can tell, nothing in this callchain asserts to the compiler
that nr_cpu_ids cannot be larger than the compile time value of NR_CPUS
(I assume there is a check for this somewhere?), so it assumes that this
memcpy() can overflow if nr_cpu_ids is larger than NR_CPUS, which is
where that range appears to come from. I am able to kill this warning
with

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9278a50d514f..a1b0e213c638 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -836,6 +836,7 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
 static __always_inline
 void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
 {
+	BUG_ON(large_cpumask_bits > NR_CPUS);
 	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
 }
 

although I am sure that is not going to be acceptable but it might give
a hint about what could be done to deal with this.

Another option would be taking advantage of the __diag infrastructure to
silence this warning around the bitmap_copy() in cpumask_copy(), stating
that we know this can never overflow because of <reason>. I think that
would be much more palpable than disabling the warning globally for the
kernel, much like Greg said.

[1]: https://inbox.sourceware.org/gcc-patches/20241105163132.1922052-1-qing.zhao@oracle.com/

Cheers,
Nathan
