Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6781C3C11;
	Mon, 15 Sep 2025 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757953252; cv=none; b=D/3xIiTXxfYBITSsaKiUtas0ccyow19r4YJhZfadzGLdwma07OAmNYL7caddaOWil6Lu5nqgc1mv0OaKkZtts8s93QBAjMG7edjCbrDGtWXjjitKYz+4WPPruEioW/HcVu6HqmqeRn2yA9CzC50aAwxqdrExuiPduU8FeIHncF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757953252; c=relaxed/simple;
	bh=yO0OtTf4tibabKMaQbj6as/6p1x2/RbPqYkzFHJWeRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/PJ1LKfUd1hTfLfYWVBdEzKL4aTBxfl9OxjjfNLGofn432d6d0tu7q0lRy+1UUUMsjJQH8RVpgjXIspTKtBxltzt5qbntbMpyhcLNMIwSxQdxgiJ/885u89jjoFyr5mudW7hHkHlulsPA11tNlhzUsEbedKsZaDdnAOlFtfUf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1eEEi3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1eEEi3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C939C4CEF1;
	Mon, 15 Sep 2025 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757953251;
	bh=yO0OtTf4tibabKMaQbj6as/6p1x2/RbPqYkzFHJWeRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F1eEEi3P8Oal2RdCJlQQLkn9HUmgO/RjO0pcyhVlEhHUE45Tcg2bB9KCEl3guO60w
	 80hTMQPzrAZ7I3DIB2hxaR6V1PjuGALE3T/QBVWxYvnnTsVmuuBBoyOboNqd2EMKwZ
	 8N9V7w+/YSi52aErC4s5/CEEYCP+9naxq9YD2ZqqkPi9cGrwD72xSgpSbLvrc3s1p3
	 kxDqrfodmlF4cPwsQy3FWVBkK1xyRpwTO7VzsYHjzELlF9eV2j5fTzyukBtEUpxorN
	 EJAyL5RQJJyv1UEgD/7sfw2yAmaXpdGzCimPxze2Y3cYwFD+PFx7CsZbreqgtJVuxi
	 F4JzAtnmzr2Rg==
Date: Mon, 15 Sep 2025 11:20:44 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 00/12] Curve25519 cleanup
Message-ID: <20250915162044.GD1993@quark>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>

On Sat, Sep 06, 2025 at 02:35:11PM -0700, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git curve25519-v2
> 
> This series removes the unused crypto_kpp support for Curve25519,
> migrates curve25519-selftest to a KUnit test suite, and reorganizes the
> generic and arch-optimized Curve25519 code to all be located in
> lib/crypto/ and built into a single libcurve25519 module.
> 
> Changed from v1:
> - Split kpp removal into multiple patches
> - Don't select CRYPTO_LIB_CURVE25519_GENERIC from KUnit test
> - Removed unnecessary parameter from hpre_ecc_clear_ctx()
> - Removed unnecessary 'return' from arm curve25519_base_arch()
> - Updated file comment in lib/crypto/curve25519.c
> - Made kconfig help text for KUnit test more consistent with other tests
> - Used initializer in test_curve25519()
> - Removed unnecessary newlines from messages in test_curve25519()
> - Use NSEC_PER_SEC instead of literal 1000000000
> - Added an Acked-by

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Reviews and acks would still be appreciated, of course.

- Eric
