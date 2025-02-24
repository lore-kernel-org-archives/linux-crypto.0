Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D713F43B;
	Mon, 24 Feb 2025 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740423439; cv=none; b=RhH619UiDDSZi4t5RMzVHcteC13fOKqiFeyfSszG3A/FKyZkHm5gcL2+ciNGEQuqKMtfLyS6z1428MrAaO4EkG/9sEGmzVEgeDxhn1SU5Kfur+Ez3U0LzOxko4fL+CUAa2nFzD7EkpJ+cgrB2a02fZQsA7L7kQP2BWNIOplXOvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740423439; c=relaxed/simple;
	bh=R4YAqR7cDtLfMThuNhNNoTiaOenFLVBDLTnY81ScQHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEvXQbtuZ4ev1Kiv/gh5gzqVPWVywnZNxX/hYY+xBpCbN7XQcNEmJUTbGjdGwlwJiIEWVDigM4X3zZBjnJwLIWckrbip1/DaRcJXYIRnwy73NdQaO4O3NEYjhkPdpZ/a2i5H29/PvqRlJD/wjGbO48FNRjzje6cSYp7VafS0GRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6Yl57uG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6Yl57uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52808C4CED6;
	Mon, 24 Feb 2025 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740423438;
	bh=R4YAqR7cDtLfMThuNhNNoTiaOenFLVBDLTnY81ScQHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n6Yl57uGylmyV1l2Ifa/FE/1TVQC5Sh9WyefpebASrtKOeSdH1tmnaEz+/2l0nRHd
	 TqQMEmQpu65d0h2FiookWkAmNCmaFS8Ymj/RquEMQAj9tUqo6adWMEDDHMtT/kxoHN
	 BeNrcN1bT0ngPJD7bfsc5vXcZYoVotg0nX1LxT4fQZnbv90bQL7b9OoKh3U62ozx+p
	 hFluLYKyXQnAv2/VDcpDeXIbLywKe1LT9Xe+RCxsMcqEZ51ugxB1WM+7XYH+3ycfIR
	 Gj+0m+8gRy9GYFqCNtOyd5UsK3uUt6IXvi0EL9076sZ9eEcEJhTRnMRRlGg+3hj5BM
	 LEmrruPv10rgQ==
Date: Mon, 24 Feb 2025 10:57:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH 0/2] Eliminate the no-SIMD en/decryption fallbacks on
 x86
Message-ID: <20250224185716.GA1277@sol.localdomain>
References: <20250220051325.340691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220051325.340691-1-ebiggers@kernel.org>

On Wed, Feb 19, 2025 at 09:13:23PM -0800, Eric Biggers wrote:
> The patchset can also be retrieved from:
>  
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git x86-softirq-fpu-fix-v1
> 
> This patchset fixes a longstanding issue where kernel-mode FPU (i.e.,
> SIMD) was not reliably usable in softirqs in x86, which was creating the
> need for a fallback.  The fallback was really bad for performance, and
> it even hurt performance for users that never encountered the edge case
> where kernel-mode FPU was not usable.
> 
> This patchset aligns x86 with other architectures such as arm, arm64,
> and riscv by making kernel-mode FPU work in softirqs reliably.  There
> are a few possible ways to achieve that, and for now I just went with
> the simplest way; see patch 1 for details.
> 
> Patch 2 eliminates all uses of the "crypto SIMD helper" from x86, as
> patch 1 makes it unnecessary.  For the RFC it is just one big patch;
> I'll probably split patch 2 up if this progresses past RFC status.
> 
> Performance results have been positive.  All en/decryption is now
> slightly faster on x86, as it no longer take a detour through
> crypto/simd.c.  I get a 7% or 23% improvement for AES-XTS, for example.
> 
> I also benchmarked bidirectional IPsec, which has been claimed to often
> hit the edge case where kernel-mode FPU was previously not usable in
> softirq context.  Ultimately, I was not actually able to reproduce that
> edge case being reached unless I reduced the number of CPUs to 1, in
> which case it then started being occasionally reached.  Regardless, even
> without that case being reached, IPsec throughput still improved by 2%.
> In situations where that case was being reached, or where users required
> a synchronous algorithm, a much larger improvement should be seen.
> 
> Eric Biggers (2):
>   x86/fpu: make kernel-mode FPU reliably usable in softirqs
>   crypto: x86 - stop using the SIMD helper

Any thoughts on this from the x86 folks?

- Eric
