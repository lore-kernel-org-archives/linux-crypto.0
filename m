Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AB126BF7
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781289163; cv=none; b=TanRwVmwvI3qwWpS0TStUogOHRXn5lsZfKfzpjReNuE3obofbDhDlvtQL+fQVgIcBI0wNmkr39UwOQcjhld4kVnspKldu7XPIIhIkxsOVyYBd0jFYwpahDnIz+JiQiwziM22HkQCA3bGFUbjMXorjcf6wsDM6bzHj7V7AsLkgKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781289163; c=relaxed/simple;
	bh=VSY7e6mwHa6GFXqRwywWBp0c8Z69E0AH3wwBN28BN9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoTNuytaXlOUo/aiWNYxRvjvwjvdMwJL4CQDIH/bY9R8EN4pFN5pJ2DY33qu6xZsENST/oV7+bSnbRJsXo2BGmnFLNmR3zG734u6ohCDpGDLzxvujf/7k7JRZToKKpfc5tcrqpwn/dta7Kc6JGZKk8wOTqc18LXznPkWrlC8R1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9XZ8zzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9XZ8zzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3D71F000E9;
	Fri, 12 Jun 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781289161;
	bh=mvcWInPHA/zbkgvk0Rse/vKMKr/qBbd26eIrz/w4RAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M9XZ8zzmH4wxkbj0uu06SkK+n7aR6PwXGxg9CEUr5at5QCq495zLCd2RQtWSZ74Na
	 MZqN1AAf7whMNwE6+31thAL3r9mtqhnX8O+j+l0yuzfx+ML5SFHDT6SFpPQBV2ff8N
	 jKPb1HSPKUNBmOTfkpOS+tAa6ZPIE9UXuJ6hNUSl8ClMtSmpgfXlnbhiPCAiFsiPq5
	 DbO85RZG/PO2yeLxmVL+pPBLRpqJmhSkU+ggDmsUTRhGA7fyDambnpHWuKJKcbp0Qo
	 wMWdgPH1t/MAIwJMkwAm91F68v/00Ga2WHCoTPV/gGF3J05mgFBADMsdI4MWJ1N9tP
	 dw/K2TrHocqCg==
Date: Fri, 12 Jun 2026 18:32:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: kstzavertaylo <kstzavertaylo@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC] ML-KEM (FIPS 203) implementation with reusable
 decapsulation pool
Message-ID: <20260612183240.GA2157807@google.com>
References: <CAMho2RfgwvNhWJidb_Xn3RRt71TFjQ2QBKP9Xt8ur22L-ZWP9A@mail.gmail.com>
 <20260609192542.GA3811606@google.com>
 <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMho2Rem-B908oaFQzTx8Mg895LuvPcfN9+ANoHW+XfGW+wB6A@mail.gmail.com>

On Fri, Jun 12, 2026 at 05:14:54PM +0300, kstzavertaylo wrote:
> Thank you for the detailed reply and for pointing me to the existing
> ML-KEM/X-Wing patchset. I spent some time reviewing the implementation
> to better understand the design choices and how they compare to the
> approach I took in my own work.
> 
> After reviewing the patchset, I can see several strengths in the
> implementation. It integrates cleanly into the existing lib/crypto
> infrastructure, reuses kernel cryptographic primitives, avoids large
> stack allocations, and includes KUnit-based validation. The
> implementation also appears intentionally compact and well aligned
> with existing kernel conventions.
> 
> While reviewing the implementation, I noticed that decapsulation
> allocates a temporary workspace for each operation. This is one of the
> areas where my design diverged, which is what originally motivated the
> reusable pool approach.
> 
> My implementation was developed with a somewhat different goal in
> mind. I experimented with a reusable decapsulation workspace model
> where memory is allocated during key initialization and then reused
> across subsequent decapsulation operations. The main motivation was
> reducing allocation frequency and minimizing both stack usage and
> repeated memory management during decapsulation.
>
> As a result, the implementation avoids allocations during
> decapsulation entirely by reusing preallocated workspaces associated
> with the key context. My original hypothesis was that moving memory
> allocation to key initialization, thereby eliminating allocations from
> the decapsulation path, could reduce allocation overhead during
> repeated decapsulation operations and be beneficial in environments
> where allocation activity is considered undesirable.

In my ML-KEM code, all the decapsulation memory is consolidated into
struct mlkem_decap_workspace.  It would be straightforward to support
the caller providing a pre-allocated workspace.

In the case of X-Wing, we could also support pre-expanding the
decapsulation key.

It just depends on what is actually going to be needed by the kernel
feature(s) that are going to use this.  Which we don't really know yet.

We do know that it hasn't been found to be useful for the crypto
subsystem to provide pools for any other algorithm in the kernel, for a
variety of reasons.  Usually callers can just allocate per-operation, or
they have some sort of object (inode, block device, socket, etc.) that's
a natural place for them to cache whatever they need anyway.  In the
rare cases where some sort of pool is needed it's implemented in the
caller, optimized for the particular use case.  So I think there's a
good chance your pool idea is going off on the wrong track.

> Another difference is the integration level. My prototype explored
> direct integration through the KPP interface, whereas the patchset
> focuses on providing a reusable cryptographic library component within
> lib/crypto. These approaches address somewhat different layers of the
> kernel crypto stack.

We don't need crypto_kpp support, as it's much more complex and harder
to use than the crypto library
(https://docs.kernel.org/crypto/libcrypto.html).  Also it seems it's not
really possible anyway, since crypto_kpp is an old design that works for
Diffie-Hellman but not KEMs.

- Eric
