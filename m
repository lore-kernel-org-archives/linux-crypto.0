Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33355198A17;
	Wed, 10 Jun 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781117173; cv=none; b=WjsrOnGw88iP0k7EBVC5gO3DyWDl7n81bhr20tYwEvP/JrRUoBdgadKGZTxKJC6cqmpch/7BhmOcRz0TsjnxeCU7u1OF4SwN994hM5Xl59grktcIzZnDeGBrJfbSYTwiTq35YsXdHlSEetuCOkf4ri7lZK0mGQQ2nazC3Nqxb4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781117173; c=relaxed/simple;
	bh=cKa0C7RWNxna7+igPsyvuyrZuAkIXCY/m7gqxTWNX1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRx93R/ch2z/RK+9FXBigoXM38SLysV3FKLpAROmxDyKdon1s/kPk7S3odNjg5k/kaUSIG+xKTKHpFO+YRlzFS6YLcJxXx1byKq4nBcYoCny4LTZOb3zIfg/0+i8uEwZ4Qw/3dzLW37rldla6DJEISUWdkB65+2cWvsZ6zZROA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iutapL2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iutapL2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE631F00893;
	Wed, 10 Jun 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781117172;
	bh=Tmu2H2I/38vgEjISS8LN6iSZ2VEkEfA+KHPORyr5q3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iutapL2+t8wP+RR2xr8fON5bRWPsB/4+ldBmrPw2ClkHLIGl2OipriMB4OPXUdH8I
	 xJoEF6ZD507N3paMFpzHTn4zW4Uet85EPeGx+5v8U0fpgxOceYY5rAd0Hwg+I8JD0R
	 uGCpWOkzROyob5hDy//bmLn675nHWB++pTuMXia2Wj4Y8vopkiePHkuF+caAhjLvrg
	 0WoU/1dleFVTVmD6xxypZviSwt2Sq1aRHtzpBFVfd5WMQenrf19zMTW8JwG8nmz4K5
	 lciLOGghndERy+/NETQqHGR7vPh/DhEsGn7Zf+Lk1zG7D9ERZubATNCqAsYtDFDZze
	 P2jM2C+WPqBrQ==
Date: Wed, 10 Jun 2026 18:46:10 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Thara Gopinath <thara.gopinath@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: qce: Fix CTR-AES for partial block requests
Message-ID: <20260610184610.GC1158828@google.com>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610-qce_selftest_fix-v1-2-1b0504783a46@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-qce_selftest_fix-v1-2-1b0504783a46@oss.qualcomm.com>

On Wed, Jun 10, 2026 at 11:24:05AM +0530, Kuldeep Singh wrote:
> In CTR mode, the IV acts as the initial counter block.
> APer NIST SP 800-38A, after a CTR mode operation the next unused counter
> value is:
> 
> IV_next = IV_in + ceil(cryptlen / AES_BLOCK_SIZE)
> 
> The skcipher requires req->iv to hold this updated counter on
> completion, ensuring chained requests produce correct results.
> 
> Referring to Crypto6.0 documentation, Section 2.2.5 says:
> "The count value increments automatically once per block of data (in
> AES, a block is 16 bytes) based on the value in the
> CRYPTO_ENCR_CNTR_MASK registers."
> 
> QCE increments internal counter register once per full 16-byte block(for
> ctr-aes) is processed. In case of partial request length, the hardware
> uses the current counter to generate keystreams but does not increment
> the counter register afterwards. So the counter value written in
> CRYPTO_ENCR_CNTRn_IVn later once read by software is one less than the
> expected value.
> 
> Crypto selftest framework capture this scenario with test vector
> 4 comprising of a 499-byte payload (31 full blocks + 3 partial bytes).
> Error:
> [    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
> [    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
> [    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
> Expected iv_out: 0x62 (iv_in + 32)
> Obtained iv_out: 0x61 (iv_in + 31, partial block not counted)
> 
> To fix this, just increase the counter value for partial block requests
> by 1 and for the full block size requests, don't take any action as
> expected value is already returned by the hardware.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

This fix isn't Cc'ed to stable, so stable kernels will remain vulnerable
to this bug.

- Eric
