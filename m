Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D47B2C181;
	Tue, 14 Oct 2025 00:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760402045; cv=none; b=MLLQn4OusgqhpCngZl6ZYSBTdizpt2ilNCY2wbaucP9eM6KV7QmNxSuIxd62Lvwx/mhvv/VaGm0RFjRgYUIVbpQJKieQOFBnmfLqx5RUNt9V/S5A43HrU2bVcXd/IaHPRlxnM+qw5AueIoBe5DJ8IWjLsnJfQ6BjhPcY0W6K4ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760402045; c=relaxed/simple;
	bh=rmCAYd8HmAmz2uTEwJhSVa4lOwo9teCkgGgaKJv+VpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JC+suf/oT0wHuvUXwBt/m5kutf4deM23lbScaJRgSH9Qf8BVMT7+yqz/Li66puQ/9Tv0FxLSm3zQkFtADKMDHFyaEHZDtEkJ4EPeLFjsjmvARo08RUPiwupnhb4QkqQHlrdORpMQkVgSA4bL7MDv0w37ecrBS8/fbzdg1iPxCzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKM5bhHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKM5bhHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D67C4CEE7;
	Tue, 14 Oct 2025 00:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760402043;
	bh=rmCAYd8HmAmz2uTEwJhSVa4lOwo9teCkgGgaKJv+VpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kKM5bhHO8haUvA445kggjPLzNXybbuiI4l7Ghffjyg0Ntr/OJuFOypZtSVpxUUI86
	 DIwR+ZUWWmno1fYNjMzMFzRybIes4hyEhIeuCwKcKeFyqCxV+uPWRsEmAf+3cAL+nu
	 nAEo3CnulJHdfZtwv2+i89s1zsFo4UgaMkBhR8bdZ0VuupsWeklftYv5yz9Fn+1idM
	 6pLDWUaaUT7MBf8rCkMv7HJg9iqic3+3zIGd+ZQRxJhedFrbiMVK9owE3grYLaUN6m
	 jO5jyL2XwSuZhy2fjK4smut7qZBPmp2vz847KWy7gjfZy3OsEburu5AFFN+xvIdsBS
	 tJUdCfbaD1n9g==
Date: Mon, 13 Oct 2025 17:32:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Joachim Vandersmissen <git@jvdsn.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] lib/crypto: Add FIPS self-tests for SHA-1 and SHA-2
Message-ID: <20251014003231.GB2763@sol>
References: <20251011001047.51886-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011001047.51886-1-ebiggers@kernel.org>

On Fri, Oct 10, 2025 at 05:10:47PM -0700, Eric Biggers wrote:
> Add FIPS cryptographic algorithm self-tests for all SHA-1 and SHA-2
> algorithms.  Following the "Implementation Guidance for FIPS 140-3"
> document, to achieve this it's sufficient to just test a single test
> vector for each of HMAC-SHA1, HMAC-SHA256, and HMAC-SHA512.
> 
> Just run these tests in the initcalls, following the example of e.g.
> crypto/kdf_sp800108.c.  Note that this should meet the FIPS self-test
> requirement even in the built-in case, given that the initcalls run
> before userspace, storage, network, etc. are accessible.
> 
> This does not fix a regression, seeing as lib/ has had SHA-1 support
> since 2005 and SHA-256 support since 2018.  Neither ever had FIPS
> self-tests.  Moreover, fips=1 support has always been an unfinished
> feature upstream.  However, with lib/ now being used more widely, it's
> now seeing more scrutiny and people seem to want these now.
> 
> Link: https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
