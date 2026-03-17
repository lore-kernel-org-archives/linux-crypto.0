Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B737649B;
	Tue, 17 Mar 2026 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765061; cv=none; b=JCJQwJ3TAh2lFTARs4re9qJVh2WZSP3oOU1jdbTawyf43xX79rkS9bP4HXBiukMZmOzwjGtyxZ9OjhYqDif0p0oVVDBaCAy7cSPi0MM9zid/ptoc55omGJJCVSJLA53Qq+dujPEWaLa2v0mAajHBA99jKYAbgp/JZ6m2MyvKAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765061; c=relaxed/simple;
	bh=f7M8YijdANJIM7TwtqYVn+G6KqOEWAFeN7/No3wmCcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRHHuMNM8qW0jSQUNyV3T1DwRzYWCt+54gHnuqg8/GTWHuSczlfQq8LIzkDTYKyzZJc9yHTUUgXULtuq+6e4uLOw/UANrW5hpRP751sW5eYIb+AtktCIjNwLZOMgTP3ZGSrils4Wru9u0nQ1bcDbBvseAeUK9ex4qJGYY/DfE/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FK7WqClR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FK7WqClR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB374C4CEF7;
	Tue, 17 Mar 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765061;
	bh=f7M8YijdANJIM7TwtqYVn+G6KqOEWAFeN7/No3wmCcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FK7WqClRcXiprDvXkPmiUiykVRGnMEMt8Y7Q6gStvwlBrkBZZGlyFURDEoTuUfKlJ
	 hUzR5+SmO8qlZ5fwBy5w/hdV31tHra0yzVnbz6rqdbTC/3XNUVh/r59fCvMhrBCotG
	 nIbvGkwYxclPqKOTer4iYGtlfCDolv3Ns7qKXOhiecHCG4ntQj95HphjAAXQEjq7m5
	 TBC3ManZ6Cy6rvPmKg1SUf3T7bYvW162jrwGjuN3jSyqIMDhmedg+/uyglRyxhXKVN
	 8q+C0HIe0L2MLExAiJscPBtcJrr+6YjE8OXzJyssmSCxmo+TWd2YDHmbmgi2i7KDES
	 cBTI/CDYgmosw==
Date: Tue, 17 Mar 2026 09:30:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Subject: Re: [PATCH] kunit: configs: Enable all CRC tests in all_tests.config
Message-ID: <20260317163001.GB2931@sol>
References: <20260314172224.15152-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314172224.15152-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 10:22:24AM -0700, Eric Biggers wrote:
> The new option CONFIG_CRC_ENABLE_ALL_FOR_KUNIT enables all the CRC code
> that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS to enable all these
> tests.  Add this option to all_tests.config so that kunit.py will run
> them when passed the --alltests option.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crc-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)
> which has the commit adding CONFIG_CRC_ENABLE_ALL_FOR_KUNIT.
> 
> Note that patch also mirrors
> https://lore.kernel.org/linux-crypto/20260314035927.51351-3-ebiggers@kernel.org/
> which does the same for the crypto library tests.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
