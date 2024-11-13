Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA3200BBE;
	Wed, 13 Nov 2024 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731505619; cv=none; b=g33s8Iu3xsj8AOESUHKO5hf64Fu0ichyYm3/T9Ga5O8flXN+w5bYQzLimxLwZ1ILgAz8Tm8dLg40s5VW7toueG2X7BOfKIddAsUwMYTx+vDl/g69h3K+vPvgeAwlY2UCoYwPQ7fPQha9KKVRBFpvTyb+ZP4eU3T8wlt49T8ZMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731505619; c=relaxed/simple;
	bh=qY0HuqpyPZAHE0WeMVBKQut7yRVncP4l4AFCQ0b3BHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UyLk7k/lrpqEpTxdjF7wDrxuiVwidxCSTpbRplpUMZiwkeIhJvnzfYRUWeB2mJ2ZaKIxsl8kdQahchanXoP4UgFC/GEIhlwA3bqb2DQLN4nV8HJeEaPNkV/24G5qfr8chcc5XnuviUdrl870zYKIBdEVX2pN7wUjN7e4mu8Lm3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=soREo1iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="soREo1iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A8CC4CEC3;
	Wed, 13 Nov 2024 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731505618;
	bh=qY0HuqpyPZAHE0WeMVBKQut7yRVncP4l4AFCQ0b3BHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=soREo1iBWYxjGzj+tNELJAQUzEMlXcTurkyYuJ/JMdDScOYK4b1Dw0UHEOmN2qWq4
	 Zyo2S55TSdGwOCiEggLtmsIEZ9taR+vmB+33H0KbtV1Vccs0OK1O0CLMbLksxZhcu+
	 7k06StoKQYurJLak4bF2T5i5GOhT8FXKvpUiaTOTUakFxCT7jVs56oPZJ2F8gPCHwg
	 HMTpMlMRrOZByHWAaeTcf4E58jYa67vCdmn1U3kqodx5YViEdn42QCJKu8enTwcA26
	 Zd0RtzrTH0WscqnvYT8SLlJhc3NV0UqB488aY7ZE4GTfww43vnCY4BDcXhmQBo84EM
	 4TKiFdRD3I0MA==
Date: Wed, 13 Nov 2024 08:46:55 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, palmer@dabbelt.com,
	paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/crct10diftest.c add selftests for crct10dif
Message-ID: <20241113134655.GA794@quark.localdomain>
References: <20241113104036.254491-1-zhihang.shao.iscas@gmail.com>
 <20241113104036.254491-2-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113104036.254491-2-zhihang.shao.iscas@gmail.com>

On Wed, Nov 13, 2024 at 10:40:35AM +0000, Zhihang Shao wrote:
> Add selftests for kernel's implementation of CRC-T10DIF algorithm.
> The test data includes 100 randomly generated test-cases.
> The selftest file is similar to what is done in lib/crc32test.c, and is
> used to verify the correctness and measure performance improvement of
> the CRC-T10DIF algorithm with zbc extension optimization.
> 
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> ---
>  lib/Kconfig         |   9 +
>  lib/Makefile        |   1 +
>  lib/crct10diftest.c | 687 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 697 insertions(+)
>  create mode 100644 lib/crct10diftest.c

crc_t10dif_update() goes through the crypto API, so for now you should be able
to just use the crypto self-tests instead, i.e. boot a kernel with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

I am planning to fix the crct10dif library to be optimized directly (without
going through the crypto API), like what I am doing for crc32.  At that point a
crct10dif library test will be needed, and I'll add one then.

There are also several issues with the existing crc32 test which you're copying,
and which I'd like to address when adding a new test.  For example, the test
does not cover short lengths, and it runs the tests with IRQs disabled which
makes optimized code not used on many architectures.

- Eric
