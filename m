Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC84C376BCA;
	Tue, 17 Mar 2026 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765138; cv=none; b=AK7+sjIEVrlIAHnrKxrQwbeN6QJlBHYcPqaFuJVpaUvCZ5bzlaOxnLu4/u+JIJ4CMdbXwgQFmicFW/kmhwglDC09aBCMsnYcFpfr4beI+TMfxHd19FTboADlaRz4M1iWZ2W5uBM07UZgad4AQJOnl+YXz+4NfVG8SN664G5MptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765138; c=relaxed/simple;
	bh=cYheTIqpcFI6XBmZlpJGrVLvA9SafZRNORIoUZKVj0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYmlCjWw2B3r0/p6mHODJr+dhCjZTqAlFP0i+ofR/gUvkw3lqMKLePebvfdG0ZvAeDVCA2NeJFiRRIEZhM3sZYh/OeggBbQdMO5WkI3crwnEREK7sa+vnoCdFGnHn+mOzSAFz/VpOzrA8LB0Tp6Kk9O2D87uRZcB58O2cIsI2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3j6f/kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3j6f/kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115FEC2BC86;
	Tue, 17 Mar 2026 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765138;
	bh=cYheTIqpcFI6XBmZlpJGrVLvA9SafZRNORIoUZKVj0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3j6f/knD5CMzTIaf/nN32w38r/tE2Cp4mNGqfpdE4XKhOoHmi5e8bOcFVaFgqUZv
	 5h0IMDqVLRkw38w0xVQ5wu5e/9gFnhsu1i69TafzMnRIZ8px3RIfjphqVyUnnid09k
	 v3ohZkCtmz4XwKLrdJu8mNX2UcOtkZJ6Xz5WkD6xocS6EJ0FsN9WFkqWS/3ItQIMA1
	 HKEx1va87UjkYRERVjpF8LC1A6KXgq3AorrG3C051YkUuicCpYAMHCDxcMvjwHhpa4
	 ElY8EsMJkTgl/H/G4gFLTiyoZ5D2cXSW6mVigVY6uoxRBEep/N5+46lkdzQM533GTi
	 qNmTo5kCgzsDQ==
Date: Tue, 17 Mar 2026 09:31:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] lib/crc: arm64: Drop check for CONFIG_KERNEL_MODE_NEON
Message-ID: <20260317163118.GE2931@sol>
References: <20260314175744.30620-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314175744.30620-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 10:57:44AM -0700, Eric Biggers wrote:
> CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
> been since its introduction in 2013.  Given that and the fact that the
> usefulness of kernel-mode NEON has only been increasing over time,
> checking for this option in arm64-specific code is unnecessary.  Remove
> this check from lib/crc/ to simplify the code and prevent any future
> bugs where e.g. code gets disabled due to a typo in this logic.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crc-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
