Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE5720550D;
	Fri, 21 Feb 2025 09:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129683; cv=none; b=ZEzaaMbjW3f7BWZ3IKmvg6+F95b70c/QpvlPJu7dacTkTWIRerzTWIhTvr3wvVljkV3xdrttJv+a5SRZQwmSpao7PAgvHWwU3vfXrHpd+k+ykCWnjV7AUOf4IXcGm7mlueiIc91g3Q7GQx9VrPzeYsw3JmX+PNnsHf02xN5DnQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129683; c=relaxed/simple;
	bh=r/JYk7PVoZgX1PiudIGzhixT0TfXZLYQg5QITxhRhMg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=m1vchTE63hOr5Yh6w8OH1IoFZ6Ra4F32G6OQfHMWaUACJfmW17WG6S7yn4UeKqi3CIfQ9Mosqc5fD1xGUmfjLTdpbwwz0TNci6qOcxxanLwk0XBwUoAISV/oC0PdzUgTwxw8Z80ODtqC3QvaZZYfPekau82/OWvaVtohtMUl+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l2eH+wGw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l2eH+wGw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=v+1AdOg7TszpzCiI0OkxXyYFIZ6YpB3UOuASX63bLQQ=; b=l2eH+wGw2hYSGhraKeE2DVTrHO
	Hqf/RQ45MpWF5oJN8NukX71aTvWaf4cHDPDL52lKYy5sz18fwjp2NgEeScMtFq3+anaJQ71mQpko/
	fA5YfT72xMTDrC83YpnCeL4G63uHBBCunWHHNXOsTzeTpOmYl+VTccHFVtlWTwu5KkwHOzcLA0GCE
	I36oNtrMHsS1C9frWto3xnLDd09GeJlqVFeR5XHa0pqV797TBCYes7Dy4mviK90JVpmkUe40B7lcj
	XGRnrbgk/Fzn0GuF856BpoFrCtK6dGAcI27ihsfVWewv1R6ay5JV9GikhFWmTYNANNn/dC8Tct58A
	now1ZX1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPDg-000YHJ-1m;
	Fri, 21 Feb 2025 17:21:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:21:16 +0800
Date: Fri, 21 Feb 2025 17:21:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, ardb@kernel.org
Subject: Re: [PATCH v4] crypto: x86/aes-ctr - rewrite AESNI+AVX optimized CTR
 and add VAES support
Message-ID: <Z7hFjHWVtxncb1VB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210165020.42611-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Delete aes_ctrby8_avx-x86_64.S and add a new assembly file
> aes-ctr-avx-x86_64.S which follows a similar approach to
> aes-xts-avx-x86_64.S in that it uses a "template" to provide AESNI+AVX,
> VAES+AVX2, VAES+AVX10/256, and VAES+AVX10/512 code, instead of just
> AESNI+AVX.  Wire it up to the crypto API accordingly.
> 
> This greatly improves the performance of AES-CTR and AES-XCTR on
> VAES-capable CPUs, with the best case being AMD Zen 5 where an over 230%
> increase in throughput is seen on long messages.  Performance on
> non-VAES-capable CPUs remains about the same, and the non-AVX AES-CTR
> code (aesni_ctr_enc) is also kept as-is for now.  There are some slight
> regressions (less than 10%) on some short message lengths on some CPUs;
> these are difficult to avoid, given how the previous code was so heavily
> unrolled by message length, and they are not particularly important.
> Detailed performance results are given in the tables below.
> 
> Both CTR and XCTR support is retained.  The main loop remains
> 8-vector-wide, which differs from the 4-vector-wide main loops that are
> used in the XTS and GCM code.  A wider loop is appropriate for CTR and
> XCTR since they have fewer other instructions (such as vpclmulqdq) to
> interleave with the AES instructions.
> 
> Similar to what was the case for AES-GCM, the new assembly code also has
> a much smaller binary size, as it fixes the excessive unrolling by data
> length and key length present in the old code.  Specifically, the new
> assembly file compiles to about 9 KB of text vs. 28 KB for the old file.
> This is despite 4x as many implementations being included.
> 
> The tables below show the detailed performance results.  The tables show
> percentage improvement in single-threaded throughput for repeated
> encryption of the given message length; an increase from 6000 MB/s to
> 12000 MB/s would be listed as 100%.  They were collected by directly
> measuring the Linux crypto API performance using a custom kernel module.
> The tested CPUs were all server processors from Google Compute Engine
> except for Zen 5 which was a Ryzen 9 9950X desktop processor.
> 
> Table 1: AES-256-CTR throughput improvement,
>         CPU microarchitecture vs. message length in bytes:
> 
>                     | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  232% |  203% |  212% |  143% |   71% |   95% |
> Intel Emerald Rapids |  116% |  116% |  117% |   91% |   78% |   79% |
> Intel Ice Lake       |  109% |  103% |  107% |   81% |   54% |   56% |
> AMD Zen 4            |  109% |   91% |  100% |   70% |   43% |   59% |
> AMD Zen 3            |   92% |   78% |   87% |   57% |   32% |   43% |
> AMD Zen 2            |    9% |    8% |   14% |   12% |    8% |   21% |
> Intel Skylake        |    7% |    7% |    8% |    5% |    3% |    8% |
> 
>                     |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   57% |   39% |   -9% |    7% |   -7% |
> Intel Emerald Rapids |   37% |   42% |   -0% |   13% |   -8% |
> Intel Ice Lake       |   39% |   30% |   -1% |   14% |   -9% |
> AMD Zen 4            |   42% |   38% |   -0% |   18% |   -3% |
> AMD Zen 3            |   38% |   35% |    6% |   31% |    5% |
> AMD Zen 2            |   24% |   23% |    5% |   30% |    3% |
> Intel Skylake        |    9% |    1% |   -4% |   10% |   -7% |
> 
> Table 2: AES-256-XCTR throughput improvement,
>         CPU microarchitecture vs. message length in bytes:
> 
>                     | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  240% |  201% |  216% |  151% |   75% |  108% |
> Intel Emerald Rapids |  100% |   99% |  102% |   91% |   94% |  104% |
> Intel Ice Lake       |   93% |   89% |   92% |   74% |   50% |   64% |
> AMD Zen 4            |   86% |   75% |   83% |   60% |   41% |   52% |
> AMD Zen 3            |   73% |   63% |   69% |   45% |   21% |   33% |
> AMD Zen 2            |   -2% |   -2% |    2% |    3% |   -1% |   11% |
> Intel Skylake        |   -1% |   -1% |    1% |    2% |   -1% |    9% |
> 
>                     |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   78% |   56% |   -4% |   38% |   -2% |
> Intel Emerald Rapids |   61% |   55% |    4% |   32% |   -5% |
> Intel Ice Lake       |   57% |   42% |    3% |   44% |   -4% |
> AMD Zen 4            |   35% |   28% |   -1% |   17% |   -3% |
> AMD Zen 3            |   26% |   23% |   -3% |   11% |   -6% |
> AMD Zen 2            |   13% |   24% |   -1% |   14% |   -3% |
> Intel Skylake        |   16% |    8% |   -4% |   35% |   -3% |
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Changed in v4:
> - Used 'varargs' in assembly macros where appropriate.
> 
> Changed in v3:
> - Dropped the patch removing the non-AVX AES-CTR for now
> - Changed license of aes-ctr-avx-x86_64.S to Apache-2.0 OR BSD-2-Clause,
>  same as what I used for the AES-GCM assembly files.  I've received
>  interest in this code possibly being reused in other projects.
> - Updated commit message to remove an ambiguous statement
> - Updated commit message to clarify that the non-AVX code is unchanged
> - Added comment above ctr_crypt_aesni() noting that it's non-AVX
> 
> Changed in v2:
> - Split the removal of the non-AVX implementation of AES-CTR into a
>  separate patch, and removed the assembly code too.
> - Made some minor tweaks to the new assembly file, including fixing a
>  build error when aesni-intel is built as a module.
> 
> arch/x86/crypto/Makefile                |   2 +-
> arch/x86/crypto/aes-ctr-avx-x86_64.S    | 592 +++++++++++++++++++++++
> arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 597 ------------------------
> arch/x86/crypto/aesni-intel_glue.c      | 404 ++++++++--------
> 4 files changed, 803 insertions(+), 792 deletions(-)
> create mode 100644 arch/x86/crypto/aes-ctr-avx-x86_64.S
> delete mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
