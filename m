Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BFE2877DC;
	Thu, 29 Jan 2026 01:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649522; cv=none; b=QXAY7Q1kpzNh6l+Q5Kws7+qzTGzMjkQ+yspzSARxtc4jxmjrmyXeZZ6A2b3V59Cgj0WTSn09YvWWd+nAgIcjwclFWLz9wec41iIhOb1Zzv2dCO2E8HnwtH79yvqZhBctkNFSUo5k8Xe71NhpEpzva0l2870nOK5pw5h+2X/CPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649522; c=relaxed/simple;
	bh=H2sV14e8HI+wblwa6bhREObIhAM/EZogM3B1BAXkhJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd0YFs5JrBJiKJCSPPECwcKmClDiVSGkON1/d8CMGoVc8/iNwW47j02IzdOQkXTy4UzgJDbGIxnEa4Ur4lf/gQFSHnp2PtAStvnetSoOBphOZT/ZY4UarduGvj0mKTSDfZWBStwaOiMdMuumGWcPEwhbcJsWAlaHM+FOi9L2cTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4VYaoSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4VYaoSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89471C19421;
	Thu, 29 Jan 2026 01:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769649521;
	bh=H2sV14e8HI+wblwa6bhREObIhAM/EZogM3B1BAXkhJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q4VYaoSRn7twMXf5dckHiykohg1AoZGoBOMc8zL2cM/Y13dwDlBaIIBnky0wk/M3G
	 2iFK7fAJO7AVkFlYcFgAWsbzPrO90ymEix2yHwvX35LtAMhJ4ET8Jknm53xQAV4xWI
	 hj+7AxoURBFvzOPoX7gr7kPm1O7a0ZvlNOI3fhPizW+sF4ab1CoVM13IXOGr+K0BfZ
	 eQ0ZpuxeXdGEf2HY56H45MVJr/wNPWxp6KLLIzYu4tRDS0R6aaaBUExBNj3koNxuvf
	 2dMfDBluZNQRUDJZIrtfK7vzIf420106pLymvY/Fjvo8enJLBRjymBP723EgXtPHG/
	 qRILwj0RDbdng==
Date: Wed, 28 Jan 2026 17:18:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
Message-ID: <20260129011838.GG2024@quark>
References: <20260119121210.2662-1-dengler@linux.ibm.com>
 <20260119121210.2662-2-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119121210.2662-2-dengler@linux.ibm.com>

On Mon, Jan 19, 2026 at 01:12:10PM +0100, Holger Dengler wrote:
> +static __always_inline u64 time_aes_op(bool encrypt, struct aes_key *aes_key,
> +				       u8 *out, const u8 *in)
> +{
> +	void (*aes_op)(const struct aes_key *key, u8 *out, const u8 *in);
> +	u64 t;
> +
> +	aes_op = encrypt ? &aes_encrypt : &aes_decrypt;
> +
> +	preempt_disable();
> +	t = ktime_get_ns();
> +	aes_op(aes_key, out, in);
> +	t = ktime_get_ns() - t;
> +	preempt_enable();
> +
> +	return t;
> +}
> +
> +static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
> +{
> +	const size_t num_iters = 100;
> +	struct aes_key aes_key;
> +	u8 out[AES_BLOCK_SIZE];
> +	u64 t, t_enc, t_dec;
> +	int rc;
> +
> +	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
> +		kunit_skip(test, "not enabled");
> +
> +	rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
> +	KUNIT_ASSERT_EQ(test, 0, rc);
> +
> +	/* warm-up */
> +	for (size_t i = 0; i < num_iters; i++) {
> +		aes_encrypt(&aes_key, out, tv->plain);
> +		aes_decrypt(&aes_key, out, tv->cipher);
> +	}
> +
> +	t_enc = NSEC_PER_SEC;
> +	t_dec = NSEC_PER_SEC;
> +	for (size_t i = 0; i < num_iters; i++) {
> +		t = time_aes_op(true, &aes_key, out, tv->plain);
> +		t_enc = MIN_T(u64, t, t_enc);
> +
> +		t = time_aes_op(false, &aes_key, out, tv->cipher);
> +		t_dec = MIN_T(u64, t, t_dec);
> +	}
> +
> +	kunit_info(test, "enc (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
> +		   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
> +			     (t_enc ?: 1)));
> +	kunit_info(test, "dec (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
> +		   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
> +			     (t_dec ?: 1)));
> +}

"AES_BLOCK_SIZE * NSEC_PER_SEC" is missing a cast to u64, as reported by
the kernel test robot.

But also as discussed in v1, using ktime_get_ns() to time one AES block
en/decryption at a time doesn't really work.  Even on x86 which has a
high precision timer, it's spending longer getting the time than doing
the actual AES en/decryption.

You may have meant to use get_cycles() instead, which has less overhead.

However, not all architectures have a cycle counter.

So I recommend we go with the simple strategy that I suggested, and
which v1 had.  Just the number of iterations in v1 was way too high.

- Eric
