Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBA934AB17;
	Tue, 17 Mar 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765598; cv=none; b=AJF45LbdvebRKs7BKLuAIQE+w31JsRLYllNb5JWlAvvfsbi6cz9OytzemTV1c0/jUyAVU87uwyrF4yBFdB1izGFFlCqFGD+ImWhlD4hibFMRk5rHChGckBMQKIkeCOcEH6nrT9Kkn/mRCgqZBzzeLvjmK1LUPWqXWqxCzeb3Jp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765598; c=relaxed/simple;
	bh=BApu/WFPxgPgAnu1bKlUbS1Jf84hMHyqhjirnXdBwkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5SMEI8HHvdiyNg+j4D5CW448H5N5R3aPy+SN8+lrWD4UsYdPeqCVOEWuLd3Tdv8FTDLZtaGpq3rBHQJxVA3QND7RPIpiNKiFmIAKiVNcgduFQr1NukW79mKByomjlytU3c02UD/I6+dmuz8+sjGx0MewsVoNfS/tJxw8hd8IqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw/5l1KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw/5l1KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A0CC4CEF7;
	Tue, 17 Mar 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765598;
	bh=BApu/WFPxgPgAnu1bKlUbS1Jf84hMHyqhjirnXdBwkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fw/5l1KSd9s1emhJNsLccaqQn9OcNqmbmVgtzWUZzlgQCBZSwryulpytL7/JaAyM5
	 Xt/vW88KO83utay0j4nlCf7yd21V7Zr/f8kShN2CF3WLAf2/0vSVEqGs1nsUFgIPu9
	 I5gplWF21We/WtBLvIsPps0Ipggf/KNAIupQjekJ33vE51t49R8oQp1zDIz4ouaXHw
	 R327GxuxSMhazPijcWb0iPeg9gj8trY/R3oh+Zt7Ti8PtDWjElha/0OHu/H+6uPzUg
	 /pM/qtiq7mIXfovq+xMF1VugFHTEZwNo12hEzvqQ7E8di6fnLwab8I7z+iLyyGq93P
	 Gh9VA6qUPl0pQ==
Date: Tue, 17 Mar 2026 09:38:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/2] Make 'kunit.py run --alltests' run all crypto
 library tests
Message-ID: <20260317163858.GA6226@sol>
References: <20260314035927.51351-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314035927.51351-1-ebiggers@kernel.org>

On Fri, Mar 13, 2026 at 08:59:25PM -0700, Eric Biggers wrote:
> This series makes the KUnit all_tests.config enable all the crypto
> library options that have KUnit tests, so that all these tests will be
> run in testing systems use 'kunit.py run --alltests'.  (For example,
> KernelCI is planned to start doing that [1].)  To do this easily in both
> that file and in lib/crypto/.kunitconfig, introduce a kconfig option
> CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT for this purpose.
> 
> This series is targeting libcrypto-next.
> 
> [1] https://lore.kernel.org/kernelci/4fd302e0-ffa7-4bbf-a94a-c8879fde32f4@sirena.org.uk
> 
> Eric Biggers (2):
>   lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
>   kunit: configs: Enable all crypto library tests in all_tests.config
> 
>  lib/crypto/.kunitconfig                      | 22 +-----------------
>  lib/crypto/tests/Kconfig                     | 24 ++++++++++++++++++++
>  tools/testing/kunit/configs/all_tests.config |  2 ++
>  3 files changed, 27 insertions(+), 21 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
