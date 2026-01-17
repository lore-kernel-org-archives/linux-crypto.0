Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68626E71F;
	Sat, 17 Jan 2026 23:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768694354; cv=none; b=cJKfnnK/XjYfksM4/bq6e4fnZakNCo/S9gWi5Y4wBX7uOX9hJxBSh5sc9xct5V/YZTQnvLegbn7SJf+TF8BNMWGDAsDtpqRoOEYl17BQ+t5z5CvzkODE8yHwjwF3uAj3byV8GCANiWFai+qTQcJK6Ha7QpzmddbppizJHxAH23E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768694354; c=relaxed/simple;
	bh=wwSThHcdnhC42RhGU9dsQ3L3s/dVRBaZ5GoaOgCHYqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpqKxC3gtMmHv7XKEGLD49eSSDQzbtBGOnUT4zh2kAjMewEEqe3E20e0EvBE5+GafMH71B65IvYVBHkvEl9oiDWkS8hMQThk/RyR0sanctYp0oVps1jlpolOGhWRuFMOX/HfpmYj+/yRhnx95WOHOntYoq/4oKdwio246doQcQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjuzIQrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjuzIQrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D38C4CEF7;
	Sat, 17 Jan 2026 23:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768694354;
	bh=wwSThHcdnhC42RhGU9dsQ3L3s/dVRBaZ5GoaOgCHYqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjuzIQrFBH41+NaK8qQIH6Cbo9vP4DkVRHtDu/NbMED0AVIehlSu5YF+h5lbFUUKb
	 4XmESoH47BrhNTx5si16yjQDWs6x2ykJO1iJ6M7uV/7ntW252+Ubm8rvnWadVEM2Ys
	 nXi5HPlPgJF2RKRcewTcQqZF4gT+4m8a5mXvZVSVUjA+bHN86rc90vCrLQzaY5k29V
	 ZKngTLVilnLBxRtQCy2nhW7nh2T6IWzYGSS/VbOwsj6aHq62PmbH9Hz3iqBz/5plcf
	 NBmkW8plsjY+ZXqgtQMTExFHYvT5VnPBwTB7FWdQHqCMM+xndoUYoWOgIJzXz8BS6J
	 9joY4rjXjzjZg==
Date: Sat, 17 Jan 2026 15:59:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Holger Dengler <dengler@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260117235906.GD74518@quark>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
 <20260115183831.72010-2-dengler@linux.ibm.com>
 <20260115204332.GA3138@quark>
 <20260115220558.25390c0e@pumpkin>
 <389595e9-e13a-42e3-b0ff-9ca0dd3effe3@linux.ibm.com>
 <20260116183744.04781509@pumpkin>
 <2d5c7775-de20-493d-88cc-011d2261c079@linux.ibm.com>
 <20260116194410.GA1398962@google.com>
 <aedfebcb-4bca-4474-a590-b1acc37307ac@linux.ibm.com>
 <20260116223015.60887d5d@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116223015.60887d5d@pumpkin>

On Fri, Jan 16, 2026 at 10:30:15PM +0000, David Laight wrote:
> It may not matter what you do to get the cpu speed fixed.
> Looping calling ktime_get_ns() for 'long enough' should do it.

For the CPU frequency, sure.  But as I mentioned, the warm-up loop is
also intended to load the target code into cache, as the benchmarks are
intended to measure the warm cache case.  Yes, that part only needs one
call, but the loop accomplishes both.

> That would be test independent but the 'long enough' very
> cpu dependent.
> The benchmarks probably ought to have some common API - even if it
> just in the kunit code.
> 
> The advantage of counting cpu clocks is the frequency then doesn't
> matter as much - L1 cache miss timings might change.
> 
> The difficulty is finding a cpu clock counter. Architecture dependent
> and may not exist (you don't want the fixed frequency 'sanitised' TSC).

Yes, not all architectures supported by Linux have a high-resolution
timer or cycle counter.  IIUC, for some the best resolution available is
that of "jiffies", which can increment as infrequently as once per 10
ms.  On such kernels, the benchmark naturally needs to run for
significantly longer than that to get a reasonably accurate time.

I certainly agree that the benchmarking code I've written is ad-hoc.
But at the same time, there's a bit more reasoning behind it than you
might think.  The "obvious" improvements suggested in this thread
(disabling IRQs, doing only 1 warm-up iteration, doing only 100
iterations) make assumptions that are not true on many systems.

- Eric
