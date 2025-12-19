Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3AD259CAF;
	Fri, 19 Dec 2025 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766169247; cv=none; b=YcMhml+0CP9cjdvmf3Y6Sfv90t2IWqF6wBx/gTiEaacxMoeByhULvXT4pBdIvknEOMvYJ8bkr+Qp84gpXQlF2kJmy5srPnsMPFtyR5vWVXkGenL8AY/P7CYnnjFB8SMcQmPbsKHApT3taXN+eASzIllPRAqHdTzfKZDf8Uone7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766169247; c=relaxed/simple;
	bh=+uogymK57zULfDdyws0ik8psWiCgtEFRHjKdKpK97AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vzx5usQh9rzWqgCUA4Noq25znye6rp3wEJ7UzgJv7p8u4JJr6HZLal3xIM4qJmUaOwvJ8cKYBMiSjzDEx6K25vshU9A5WFmNe1py4Y0XnXEni4/prGW+BkAco9A6+5DTnx/GyzUXYVysA4h3DLq64Fg3zR00utlkwT1mmLDoWgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJMrMJCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJMrMJCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5524EC116D0;
	Fri, 19 Dec 2025 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766169246;
	bh=+uogymK57zULfDdyws0ik8psWiCgtEFRHjKdKpK97AE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJMrMJCEowh7kr5KT62H4slxUi/9HSj+tbEewGll1VJPWin/nLbjXrmE6N2Os9K9i
	 j17fumRjozhuENrK2eFf4449Irx1eLa6SUwsYqioLQqkIcIEcSSlaKuz29rqfq5utB
	 nZJArtGlZTVsDwqi+LdjPyOUWp+kxV9eNXvhv4mHnm4ZAmKCAvWFXhwOI+pPVcxbS4
	 ndSLKVOCH7ulu3LRZatKajfdqxL6H7w06228QujxwWa6cFFSOBZRJJ3bvM8C+EUHwC
	 IHCTb+lZylKGpDYJPIy3khv+EK//6AOc972o175LH4vRw/7fI84XJlY4VMQiEuZr4L
	 mM8NCDx6QLF4A==
Date: Fri, 19 Dec 2025 10:33:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, Jason@zx2c4.com, ardb@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	CobeChen@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH v2 0/2] lib/crypto: x86/sha: Add PHE Extensions support
Message-ID: <20251219183357.GA1602@sol>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>

On Fri, Dec 19, 2025 at 04:03:04PM +0800, AlanSong-oc wrote:
> For Zhaoxin processors, the XSHA1 instruction requires the total memory
> allocated at %rdi register must be 32 bytes, while the XSHA1 and
> XSHA256 instruction doesn't perform any operation when %ecx is zero.
> 
> Due to these requirements, the current padlock-sha driver does not work
> correctly with Zhaoxin processors. It cannot pass the self-tests and
> therefore does not activate the driver on Zhaoxin processors. This issue
> has been reported in Debian [1]. The self-tests fail with the
> following messages [2]:
> 
> alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
> alg: self-tests for sha1 using sha1-padlock-nano failed (rc=-22)
> ------------[ cut here ]------------
> 
> alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
> alg: self-tests for sha256 using sha256-padlock-nano failed (rc=-22)
> ------------[ cut here ]------------

This cover letter is misleading, as those self-test failures will still
exist regardless of this patch series.

> To enable XSHA1 and XSHA256 instruction support on Zhaoxin processors,
> this series adds PHE Extensions support to lib/crypto for SHA-1 and
> SHA-256, following the suggestion in [3].
> 
> v1 link is below:
> https://lore.kernel.org/linux-crypto/20250611101750.6839-1-AlanSong-oc@zhaoxin.com/

Please run the sha1 and sha256 KUnit test suites
(CRYPTO_LIB_SHA1_KUNIT_TEST and CRYPTO_LIB_SHA256_KUNIT_TEST) before and
after this series, with the benchmark enabled (CRYPTO_LIB_BENCHMARK),
and show the results.  For this series to be considered, the tests need
to pass and there needs to be a significant performance improvement.

- Eric
