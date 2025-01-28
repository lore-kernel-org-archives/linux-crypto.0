Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93390BA27;
	Tue, 28 Jan 2025 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738090080; cv=none; b=AveHJTZVaC+aLivdGdyJyXr6YW6FnN8SOdqD8jtFBefB+wcUZyfQt6U6R2BhuVW4bNHkXIJDiqy3njmCAW5/SUbLGI7NYcahhCOHmY7QmY3tqPxAxEoIb2vwBK3wPvzMSC43m9c+2W5V/wDQIrmkhgNxO/KItHfu0BoeT441lp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738090080; c=relaxed/simple;
	bh=0khbF40FHqbi1PYKMCWlYdaO8t6F0KGG62ljFhW7vYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fk4N5mqDw24qc4UfxZQL1AsPexBfxVLhp0GkmaJRU1Tk5KSsG5wQWVMUsZOmyHLY60J7s6slMy4lA0/bwyCD1pUhW/fmiVkshPUCLxafd3bhgTqF7lYTmoHFMadB/ym59BG/iR1UiwU6sUHY9F5xkkpl8S0izSk+u/6QNp/hlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIEbCmCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIEbCmCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF54DC4CED3;
	Tue, 28 Jan 2025 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738090080;
	bh=0khbF40FHqbi1PYKMCWlYdaO8t6F0KGG62ljFhW7vYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PIEbCmCfWN+77S71JlvrRrpTEVzhgNJFHD43GC3Qj/9XmRdwsk5zhall4VVRR0+VY
	 4Lx+IuJIaJr5ChlLx9exCwn9o6pHS4fJxkY8nQ4CDQHjE4R6pg8JCeCvBIfLZSICCA
	 0cjdhy7QN8OlrFFeD3yqIABTmhylYYNZnqkxBdeNLmO1T7lL7HnIQ1cqWObO8iyOSr
	 lPE0zusNx9oSZwUytuPxojz+541pOEV8PRvfcmbhCdDyJL2G2NTv4a1h14XceG5uuk
	 NCNCyabCf4eA+PV6mbKt/JQbFSBr/Laa5+iSXeFZfpeX0yJ3Kmne+adscgX6+BHLxq
	 k9xiQ+vCh9ffA==
Date: Tue, 28 Jan 2025 18:47:58 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-ctr - rewrite AES-NI optimized CTR and
 add VAES support
Message-ID: <20250128184758.GA662128@google.com>
References: <20250128063118.187690-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128063118.187690-1-ebiggers@kernel.org>

On Mon, Jan 27, 2025 at 10:31:18PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Delete aes_ctrby8_avx-x86_64.S and add a new assembly file
> aes-ctr-avx-x86_64.S which follows a similar approach to
> aes-xts-avx-x86_64.S in that it uses a "template" to provide AESNI+AVX,
> VAES+AVX2, VAES+AVX10/256, and VAES+AVX10/512 code, instead of just
> AESNI+AVX.  Wire it up to the crypto API accordingly.

I realized there's a slight oversight in this patch: the existing AES-CTR had
both AVX and non-AVX variants, with the non-AVX assembly located in
aesni-intel_asm.S.  This patch deletes the non-AVX glue code but leaves the
non-AVX assembly, causing it to become unused.

The non-AVX AES-CTR code is x86_64 specific, so it is useful only in x86_64
kernels running on a CPU microarchitecture that supports AES-NI but not AVX:
namely Intel Westmere (2010) and the low-power Intel CPU microarchitectures
Silvermont (2013), Goldmont (2016), Goldmont Plus (2017), and Tremont (2020).
Tremont's successor, Gracemont (2021), supports AVX.

I'd lean towards just deleting the non-AVX AES-CTR code.  AES-CTR is less
important to optimize than AES-XTS and AES-GCM.  But it probably should be a
separate patch.

- Eric
