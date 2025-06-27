Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F97028A406
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061114; cv=none; b=cKjy/lSad6YqeN0IoycXV0RnJq0VmAJ2Z7s76p/cwFqCtEF3EFGse+DiGVkVRXupTvkVVicbZtM/hnXiIpHbWYPOquj8AF67LZ0xoXhREn7uwb5AcMIWUvngfHiqLEgjMPdcVyVbczMEquqcBv8hafip85/SFju5pSPgTENE7dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061114; c=relaxed/simple;
	bh=6RlVLwYxD624F9ZBWUaG+TvP/YFr9pDC9swFlV1MCJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lItnzr51qlHhNk7Fgyak5xVqexAMMdVX/eq5zezHem9eLp9q4o2lmVXzFOgGUgLjeWI6UKklJqXheynuc6SKdywEMqrpOn6Ew+FdYm9J/cmgQAHaUObRHMi7U5rtzFSCdUa2daQXl2tg7I9Q4KqtfPVTW/XDhR92v6AiI0IbYFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNR6UU/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNR6UU/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D065C4CEE3;
	Fri, 27 Jun 2025 21:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751061113;
	bh=6RlVLwYxD624F9ZBWUaG+TvP/YFr9pDC9swFlV1MCJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bNR6UU/EFCvxF2MMtQuuUGTLigvVXiscRJT9MZmA26crak9uEmQyPcq55CeFac3v/
	 AWfeg3SCMS1ZJnFsmUH2Y1yuuSf6bI+yvLWqpZL2sjiZXSVPpaThMeww50ZefgQ8J1
	 mDT53jECnlr8uVYkRhy5aWftw8yfgHCerNJc19+pD6oFMJvmhRcf9kJRN7ye7m/C1U
	 bwU9Irxcba/iUrh9gVMmjnUPGYYpg/3StEIg0I4Be0hQ/QNr3AE0N9IvK0u+SaZg0M
	 sfqbWPnXojS4WAfxIeipuFmyMg/pf6XjDumswLwEwCJJJgd9J4PGQOFV+bLC0tUonR
	 1SMm5s3II4i3Q==
Date: Fri, 27 Jun 2025 21:51:51 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Andy Polyakov <appro@cryptogams.org>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	alex@ghiti.fr, zhang.lyra@gmail.com
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250627215151.GA1194754@google.com>
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol>
 <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol>
 <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
 <fa13aa9c-fd72-4aa3-98bc-becaf68a5469@cryptogams.org>
 <CABCJKucHNWz6J9vvDvKh_Je8eQTJO_1r0f6jsDTsDmfaxdBygg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucHNWz6J9vvDvKh_Je8eQTJO_1r0f6jsDTsDmfaxdBygg@mail.gmail.com>

On Fri, Jun 27, 2025 at 09:10:30AM -0700, Sami Tolvanen wrote:
> > Would it be sufficient to #include <linux/cfi_types.h>?
> 
> Yes, but this requires the function to be indirectly called, because
> with CFI_CLANG the compiler only emits CFI type information for
> functions that are address-taken in C. If, like Eric suggested, these
> functions are not currently indirectly called, I would simply leave
> out the lpad instructions for kernel builds and worry about
> kernel-mode CFI annotations when they're actually needed:
> 
> # if defined(__riscv_zicfilp) && !defined(__KERNEL__)
>         lpad    0
> # endif

These functions aren't indirectly called, and I'm intending to keep it that way.

- Eric
