Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D60B3E44ED
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 19:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781033145; cv=none; b=e0fD9NWfgIQ5jP6ow2yoY+yX/Jmkh/bL/dmbcog7mVaWH1338XoOnyU8Tjn1Lw6czdOIWrLgZPktZkCEltM03ay6MwkOKEQbC023ukrcrxwBQ6ljI5QhJ9wSrd1GVeA8CUevbJJISwPr3rvq67uhFcawfKoWJNbOTyLS+nMbKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781033145; c=relaxed/simple;
	bh=q/hyI2CAQKKslq+Q6JufItUDwvXLZnAzNjiOX4tUczo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APE1yVr+qnZGmrJ0e+8VzlBjkR25j6+ssOmD7QmYi66PLgdQQ8kMr/fgEw/IfkM6BVj8vMNk7WR0IuK1fkBe1rPa+9DjgEreUigvdij10GMeQtHw2h/qQjSOG9SZ+2zL4tIc3ROfHGYOj6ytrDN8X8n31jzzukRS9fW7rs00T30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPyI4ht2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPyI4ht2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6FA1F00893;
	Tue,  9 Jun 2026 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781033144;
	bh=+ddnk60tXdM7hobNqKcXw8Ox9Bo2tDNzlWPY9VejNHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kPyI4ht2inC1WvYi3jOSbK9wpVETA1UAmAk0x/oEd7xv4u+8+R6skBfQE8B7KQM91
	 4mSO1+EJfKNPo/OIn7MPTona/dsQ7pwF624X58pbG5Gs3lq6pL9FOwKWGM7kk3U3rH
	 qbc79/HR5J2Gohha0JFIibQg6b8U22FOQhhFBt6NOVc4o+65t16cGQ/K3qhC3F2aD9
	 ZOocKkdVyO2zqSc4tEcTFoGSje1dgpnk1wYZ+8NoPTzrs6dJmW4JWoSB7Rf/Dkw+di
	 TVfZGXLteOtOFDBgCGq6splzcaQNxHQ0I1JwU4Kofhpqps/ghumeYW+oHohhZnyjY2
	 +qvsau/RsnvvQ==
Date: Tue, 9 Jun 2026 19:25:42 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: kstzavertaylo <kstzavertaylo@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
Message-ID: <20260609192542.GA3811606@google.com>
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>

On Tue, Jun 09, 2026 at 10:45:48AM +0300, kstzavertaylo wrote:
> Hello,
> I have been working on an ML-KEM (FIPS 203) implementation for the
> Linux kernel. This is an early RFC to solicit feedback on the overall
> design and architecture before further polishing.
> 
> The implementation consists of two closely related variants sharing
> the same core cryptographic logic:
>     1. A userspace implementation accompanied by a set of validation
> programs, including NIST KAT vectors, timing-leakage testing (dudect),
> pool stress tests, and additional functional tests.
>     2. A Linux kernel module implementing the KPP interface and
> reusing the same core architecture where possible.
> 
> Key features include:
>    1. Support for all three parameter sets: ML-KEM-512, ML-KEM-768,
> and ML-KEM-1024.
>    2. The implementation uses a reusable decapsulation pool consisting
> of preallocated slots associated with a key context. The goal of this
> design is to move memory allocation to key initialization and avoid
> per-decapsulation allocations.
>    3. Explicit zeroization of sensitive data and constant-time
> operations where required.
>    4. Portable C11 codebase with minimal differences between userspace
> and kernel versions.
> 
> I am aware that some aspects (local SHA3/SHAKE implementation, coding
> style, etc.) will likely need adjustment to align with upstream
> expectations.
> 
> At this stage, I would like to ask for feedback on the following points:
>    1. Is the general direction (KPP integration + reusable
> decapsulation pool) acceptable?
>    2. Are there any fundamental concerns with the pool-based architecture?
>    3. Would you prefer to reuse kernel crypto primitives for
> SHA3/SHAKE, or is the current embedded approach acceptable at this
> stage?
> 
> The implementation is available at: repository - https://github.com/kstzv/ml-kem
> 
> Documentation and implementation details are available in the repository.
> 
> Any feedback, criticism or suggestions would be greatly appreciated.

There's already a kernel patchset for ML-KEM and X-Wing ready to go:
https://lore.kernel.org/linux-crypto/20260525184403.101818-1-ebiggers@kernel.org/T/#u
It's a high quality implementation that fully follows kernel conventions
already.  There just hasn't been a reason to merge it yet, since there's
no user yet.

We could consider replacing my ML-KEM implementation (patch 1 of that
series) with a different one.  But it would have to be a high-quality
implementation that brings something substantially new to the table.

I think only an integration of
https://github.com/pq-code-package/mlkem-native *might* have a chance at
passing that bar.  However, it would be way more code than my
implementation, would have significant integration challenges, and would
need some fixing up to work in the kernel.  The main benefit would be
getting the assembly code, but it's not clear that will be needed.  So
those are some of the reasons I didn't reach for that initially.

I don't think integrating https://github.com/kstzv/ml-kem would be
beneficial, for a number of reasons.

Anyway, I suggest you review the pre-existing patchset
https://lore.kernel.org/linux-crypto/20260525184403.101818-1-ebiggers@kernel.org/
and give feedback on that, if you have any.

- Eric
