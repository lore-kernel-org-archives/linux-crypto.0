Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DF41228F;
	Fri, 25 Sep 2026 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790325441; cv=none; b=utRAleWwXkri23zCi5zvVN2duU9GA1h4bM7Rj/EiDp5YELiQkB/tuEA3KJDLqsGIshIRjrLo1KReEdNXpB1RUXsNDhFierUtfoxPH5czNJYHfnlexcbQLRvCUd9wNOazbKgA8UF6nW+iQK5LKbCW5OCYzZ0ed6eCcxCZaXFJyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790325441; c=relaxed/simple;
	bh=+FBsepkJ6Y3XNfjsGiTj1vwWswDmBr4aVAo1Jy8pMAU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=HwdhUL5glse7wPt+SCrq4Fkvyp2ev+QAwd2eqXDo4y6fsycKlpthhkoeX29e1ftt+rcx6aG78gjZS5OL/sWAGqUXsV/X5lSeeYEqXswtdUr7IyFzelvrxF47TFkK1jtH8wItn2sNNCU7KvPRIlWzgnr8Q9N4f4rDbm77AbrqoVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMB1UXAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMB1UXAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAED11F000FF;
	Fri, 25 Sep 2026 08:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790325436;
	bh=bRsZeRFz8cJozPYZtoFiDrWaw9uX8/BJgmertbsBXUY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=kMB1UXAaN4fnhnFOQVQ1+AOu57u8/dbc1sk5/GYORjBHXlg3y0wLofNaYarLABg6j
	 SmH7JxQvpuAHmHSP0/8uLLKjxNNA8wCeiFaDypwYee4EgfzqjJEyAkmGqDqgYgFm9U
	 Mwzo9t2omtOaefxAzHpuQHH0wZJHFYWlo2sRGv23DmjBd/NZoS+9xXVfxV6FYlo5Lw
	 0X1zBS279zF7BeX7cj4HHR9yYAG3e0JI9ciwtrgpSCTnubPaaSipC5ZZjSWqcIK3j4
	 9kkgz+0aB+R91dPs3+DE2Ow+MzOuX8pHIj+28qdlSZXL7/m/gMyhBfzZRe1TsKoiVM
	 lnhJ8hZAHPhQA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4B910198005A;
	Fri, 25 Sep 2026 04:37:14 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 04:37:14 -0400
X-ME-Sender: <xms:uDK2agyTh7be6Me99CAgCM6sDnbQnvoFhVBdJkFJ4sgXUx1_WH487A>
    <xme:uDK2avE3dViwd3oYgBLXqhU4SUl60PJRazV2g5GHalpBrbo8I1lHk4nbpgWJi1aqq
    HeZXo2L6sJN4D3pneMeZjgpii5yjy8l60BkLbHZUFkWdUIov7inUnk>
X-ME-Proxy-Cause: dmFkZTGaE3UMzseiTLxJTytQW8aTRqyr9uoY/MNOV6I0BZeTnttp6P0tiPOijmADuPJiQA
    MVx4DgsZ1JFpCsp4jVgkN7g9lqueyY8K5Il0gMmRYoagGLfeM4oReajxCbJCVCLmYh8PZr
    pfw8wwNluR9TWDCdusFRjBR3TIt2RwUOCoGdlkv3A1zKCRCnf/LVcaoX3h17/sajVhGMlG
    YtvBIfFePrGwrYnNefK4WTZbooc1WHLfJ4PGdF57575OjTVkm82nvX71/5RVG3+AL32LNU
    LYDjvzk36bsECS1RsMlgUcHAuo/cgtwBn/CV2CzpjvVAYzZCVwX7G/4OPAvb0bReRQdFN4
    PJJx7LlnMs9mK+gal79J93LZriPI1Qx7a0XhI+JAjBFOl1HgwWFGCFVZ7zleyRdkOq1bAa
    a7iciiAxkNQRgofkZaGGg10Hk8FFVqTNbE3uP+hca+zWSiEMl8/7DnWGlkw/gasy/xNmyx
    xlNAtD5qIu8jyaBcXRikYSDgNVn9mIZAkC0ye+zZwKgpEd9QkylPReINBsnMGO6Dbw1mMJ
    Ydg8EK6HExIQLjGDOopRRjltzYdmF0zrd5/JGa4/8cYdmefWNUeMo8Gq3Tqpsg2LlXu21K
    bra9E8Ah2ap+rt6XnvnDB1GURuI1GTNglUrgxJ2jy3wTOwvQOErZxS8ZdOuA
X-ME-Proxy: <xmx:ujK2amYmckFweFby8RtXjsoAxHfRY0vXi9lCCHaLEV6xPfv-m24uTQ>
    <xmx:ujK2ajddb5j-hjBjYZXxyzErKqhuiyGaVHHz_VZPI1HtUc-Yn7IWUA>
    <xmx:ujK2ag12uAkhb3OVI1dLO9w_PMb55O5xxj8revT2K0fSs3AsDIe6pw>
    <xmx:ujK2aqLs_oXc4n9zgKRpz10ZWwAzEF_XlpSrQpRhnkkTQR_a4sHscg>
    <xmx:ujK2avEKCUsJWoeVLoDM3nvldMFNMsCb6iJeRBGOAvdaxW0o6z5em3a1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D7E90F80084; Fri, 25 Sep 2026 04:37:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 10:36:51 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org
Message-Id: <ceb5dd8a-9268-4376-b46e-5bda44349122@app.fastmail.com>
In-Reply-To: <20260925052502.188024-1-ebiggers@kernel.org>
References: <20260925052502.188024-1-ebiggers@kernel.org>
Subject: Re: [PATCH] Documentation: libcrypto: Add additional testing information
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 25 Sep 2026, at 07:25, Eric Biggers wrote:
> Link to the KUnit documentation, mention the existence of the benchmarks
> and how to enable them, explicitly mention that the tests can be run on
> real hardware, and mention that it's often possible to clear CPU
> features via the kernel command line.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is intended to be taken through libcrypto-next
>
>  Documentation/crypto/libcrypto.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/Documentation/crypto/libcrypto.rst 
> b/Documentation/crypto/libcrypto.rst
> index e911e0521597..53037e62728e 100644
> --- a/Documentation/crypto/libcrypto.rst
> +++ b/Documentation/crypto/libcrypto.rst
> @@ -127,6 +127,8 @@ The crypto library uses standard KUnit tests.  Like 
> many of the kernel's other
>  KUnit tests, they are included in the set of tests that is run by
>  ``tools/testing/kunit/kunit.py run --alltests``.
> 
> +For more information about KUnit, see Documentation/dev-tools/kunit/start.rst.
> +
>  A ``.kunitconfig`` file is also provided to run just the crypto library tests.
>  For example, here's how to run them in user-mode Linux:
> 
> @@ -148,6 +150,17 @@ emulate the correct type of hardware for the code 
> to be reached.
>  Since correctness is essential in cryptographic code, new 
> architecture-optimized
>  code is accepted only if it can be tested in QEMU.
> 
> +Most of the crypto KUnit tests also include benchmarks.  To enable 
> these, enable
> +``CONFIG_CRYPTO_LIB_BENCHMARK=y`` (in addition to the tests 
> themselves).  The
> +benchmark results are printed to the kernel log when the test runs.
> +
> +Of course, the crypto KUnit tests can also be run on real hardware.  
> Note that
> +it is generally still possible to test and benchmark non-default code 
> paths in
> +this case (for example, the software implementation of AES when the 
> CPU has
> +hardware-accelerated AES), since on many architectures the kernel 
> supports
> +disabling CPU features via the kernel command line.  For example, on 
> x86,
> +the ``clearcpuid=aes`` kernel command line option disables AES 
> acceleration.
> +
>  Note: the crypto library also includes FIPS 140 self-tests.  These are
>  lightweight, are designed specifically to meet FIPS 140 requirements, 
> and exist
>  *only* to meet those requirements.  Normal testing done by kernel 
> developers and
>
> base-commit: 165768bb70265b5c38cf0b73fafd75be235f8b14
> -- 
> 2.55.0
