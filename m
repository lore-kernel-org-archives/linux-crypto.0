Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664133065C;
	Fri,  6 Mar 2026 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772832055; cv=none; b=i0+tDIH6LQzlH10DDEIs9IWImZ9R+vzhzYazXOs9O8E8EOkSpf75ovgFb9yOZB9zJMdUCAheFdheWh346oucEGPgGqDJxcTmzD9VFnY0L4DP4cMlpHU9eU5DlwgkXLN9fwQ3GEgWJ9uiStE9VbvPUpMzRJZw2K3KHdIWoq5xVwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772832055; c=relaxed/simple;
	bh=d47rG+H8ii2ThUXsKOFdx0M1Mi8gKdGY5WoGfVjpHX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3Y+Zsu0wtfoRua5Y7FKKt8ZjKyk9e4CLevI2u+RJbyMfuzjxVsW518350Z4yJC6o3eVX1d+EUlOpf/7SnHKGuthXGS/yfGlAtXOWqgQRxF19H2tesr8XcGIphyrR22ryzL6qjHHmnJ/8iaDIbUbVISzwwew0c70pfMAJPrQpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyOnHJWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyOnHJWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89695C4CEF7;
	Fri,  6 Mar 2026 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772832055;
	bh=d47rG+H8ii2ThUXsKOFdx0M1Mi8gKdGY5WoGfVjpHX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iyOnHJWAxXF8m00TmcHXfN1AQvl/EFXfxicOoFIHQUZcqdlvhhwcvvxoaAG1aLcAi
	 JQOTgBDQ4avDlV3+uBxEtWlzSM1BAjgLg3gCEv8maDgOJPyJnzlO63xYFcGl5Bpgdl
	 raKelPRAQ0P0fcZvNCdL+QfFD+q8z+5ubONoGiKAdTvxIup4kSVozzm556wPV7DUtE
	 n87O3k20lkDfBQRnn6v0CpnwTOga42GImbc1HMFGvL0xABL/qqF/Lsgo5W9dqWCYPT
	 E2OlJfZBL7LOBJq3g0rOuBJhXrV+Zk600hLwJnLc5dmDVeUZOx/HkDVtbLmIuFm7gj
	 Oppgy+OG84ebw==
Date: Fri, 6 Mar 2026 13:20:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Cc: amadeuszx.slawinski@linux.intel.com, arnd@arndb.de, dakr@kernel.org,
	gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, mcgrof@kernel.org, rafael@kernel.org,
	russ.weight@linux.dev, jeff.hugo@oss.qualcomm.com,
	troy.hanson@oss.qualcomm.com
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20260306212052.GA9593@quark>
References: <20250428190909.852705-1-ebiggers@kernel.org>
 <20260306163744.1495881-1-youssef.abdulrahman@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306163744.1495881-1-youssef.abdulrahman@oss.qualcomm.com>

On Fri, Mar 06, 2026 at 05:37:43PM +0100, Youssef Samir wrote:
> On 4/28/2025 8:09 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > This user of SHA-256 does not support any other algorithm, so the
> > crypto_shash abstraction provides no value.  Just use the SHA-256
> > library API instead, which is much simpler and easier to use.
> > 
> > Also take advantage of printk's built-in hex conversion using %*phN.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > This patch is targeting the firmware_loader tree for 6.16.
> Hi Eric,
> 
> An issue has been found on kernel versions older than v6.16, where a firmware
> file larger than 2GB and is not divisible by SHA256_BLOCK_SIZE (64b) will always lead to a page fault. The first size that fits this criteria is 2147483649b. It is also worth noting that any subsequent loads regardless of the size or divisibility by 64, will lead to another page fault.
> I've mainly tested this with drivers/accel/qaic on 6.8.0-62-generic, but technically this should affect any code that uses the firmware loader on a kernel version older than v6.16 with CONFIG_FW_LOADER_DEBUG enabled, including the stable kernels.
> 
> This can be reproduced by creating a dummy binary file of a size that fits the criteria listed above, then compress it using zstd to allow _request_firmware() to open it.
> 
> This patch appears to have fixed the issue so I suggest backporting it, but
> I also noticed that it relies on changes that were introduced in this series:
> https://lore.kernel.org/lkml/cover.1745734678.git.herbert@gondor.apana.org.au/

I guess this further shows that the upgrade to size_t lengths was a good
idea...

There was recently a similar bug report where on old kernels kexec
crashed in crypto_sha256_update when loading a file larger than ~2 GB.
It had already been fixed upstream by the upgrade to size_t lengths.
However, due to the large number of backports that would have been
needed, for the 6.1, 6.6, and 6.12 LTS kernels we just went with the
one-line fix "crypto: sha256 - fix crash at kexec"
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-6.12.y&id=70165dc3ec8cff702da7b8b122c44575ee3111d6).

That increased the supported length in 6.1, and 6.6, and 6.12 from ~2 GB
to ~4 GB.  Your "6.8.0-62-generic" distro kernel must be missing that
commit.  You should first ask your distro to cherry-pick that commit
from 6.12, and it will fix the problem for sizes < ~4 GB.

Do you need support for sizes > ~4 GB?  If so, then we can come up with
a solution for that in the LTS kernels.  (Besides just doing a lot of
backports, one option would be to replace the call to
crypto_shash_digest() with a multi-step incremental computation.)

- Eric
