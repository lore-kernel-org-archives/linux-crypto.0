Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7603AD51
	for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2024 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730022342; cv=none; b=c9sdywJ349mVkhWanrthZtSXyWtRgEXx99L1wlbbEchjKUoF3Onyy7j4/PqQJRf1/cMFHr/H5IzeX86EMrHSR0+U+ij6qFApHTEcHUGibMYXWf/OCofIJxkkW1hxpzJGYMYRGW/r5BGSvjpOGDMkkLVKeRpTjeRaYyGZG0qoZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730022342; c=relaxed/simple;
	bh=HXH2tPzEAEAHrCYv6K4fJIKXQeXYyycjIJWXE2noBi0=;
	h=Date:Message-Id:From:Subject:To:Cc; b=tWG7cTZAaur+YgqWl65e1EdVjQvxcVbFXCxy7jgyQJ7fPkg/lFe2PeusSAittnrSrm2yHMvHftAd+Q+wmHU/9+RzZbgS1HnvX1BJYeY6SdUt/SQL5QSw9rJFvaQMORWrxD8DhqGN27swaJXe6ACfxlvrvvWT6ejQIep5YisCVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j/1Fb+fg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j/1Fb+fg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jaJNHzYY4wiAffM4JhOIuKuSKdmUqEbjOQtnFfXnm/M=; b=j/1Fb+fgAikGW2epxsMkcpRHhh
	y/WXKO0PWDEBngRiHIjhJvxxG4wF+s1ae9hAzKa0kdIUGFV1MAVk606x0n8UTfKXLr/cOmcWewO1P
	KLI5Q1t+b5jLqaVX87paUIDcAlfR0tRuFIJwZdbn3TU0DS/se3dnzMhVV1WJFa7cBQ6cmO9RgWI3U
	Jviwp9lDoWPMJQxSlnveAHySGqkuebMiFdgpLsCbfU0C3w1/zdZgdGlG4zvz7Hpq0bBvKeyKvwCaW
	99/AZhAdw82UvCyZZ/kksunTyzntY7zjr648p5ON3ef6FckTSLsfYTmfMH4Rhi5qJtKPw06oK1bQy
	Q4mHjFHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4zpw-00CRFj-1b;
	Sun, 27 Oct 2024 17:45:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Oct 2024 17:45:28 +0800
Date: Sun, 27 Oct 2024 17:45:28 +0800
Message-Id: <cover.1730021644.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/6] Multibuffer hashing take two
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Multibuffer hashing was a constant sore while it was part of the
kernel.  It was very buggy and unnecessarily complex.  Finally
it was removed when it had been broken for a while without anyone
noticing.

Peace reigned in its absence, until Eric Biggers made a proposal
for its comeback :)

Link: https://lore.kernel.org/all/20240415213719.120673-1-ebiggers@kernel.org/

The issue is that the SHA algorithm (and possibly others) is
inherently not parallelisable.  Therefore the only way to exploit
parallelism on modern CPUs is to hash multiple indendent streams
of data.

Eric's proposal is a simple interface bolted onto shash that takes
two streams of data of identical length.  I thought the limitation
of two was too small, and Eric addressed that in his latest version:

Link: https://lore.kernel.org/all/20241001153718.111665-2-ebiggers@kernel.org/

However, I still disliked the addition of this to shash as it meant
that users would have to spend extra effort in order to accumulate
and maintain multiple streams of data.

My preference is to use ahash as the basis of multibuffer, because
its request object interface is perfectly suited to chaining.

The ahash interface is almost universally hated because of its
use of the SG list.  So to sweeten the deal I have added virtual
address support to ahash, thus rendering the shash interface
redundant.

Note that ahash can already be used synchronously by asking for
sync-only algorithms.  Thus there is no need to handle callbacks
and such *if* you don't want to.

This patch-set introduces two additions to the ahash interface.
First of all request chaining is added so that an arbitrary number
of requests can be submitted in one go.  Incidentally this also
reduces the cost of indirect calls by amortisation.

It then adds virtual address support to ahash.  This allows the
user to supply a virtual address as the input instead of an SG
list.

This is assumed to be not DMA-capable so it is always copied
before it's passed to an existing ahash driver.  New drivers can
elect to take virtual addresses directly.  Of course existing shash
algorithms are able to take virtual addresses without any copying.

The final patch resurrects the old SHA2 AVX2 muiltibuffer code as
a proof of concept that this API works.  The result shows that with
a full complement of 8 requests, this API is able to achieve parity
with the more modern but single-threaded SHA-NI code.

Herbert Xu (6):
  crypto: ahash - Only save callback and data in ahash_save_req
  crypto: hash - Add request chaining API
  crypto: tcrypt - Restore multibuffer ahash tests
  crypto: ahash - Add virtual address support
  crypto: ahash - Set default reqsize from ahash_alg
  crypto: x86/sha2 - Restore multibuffer AVX2 support

 arch/x86/crypto/Makefile                   |   2 +-
 arch/x86/crypto/sha256_mb_mgr_datastruct.S | 304 +++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c        | 523 ++++++++++++++++--
 arch/x86/crypto/sha256_x8_avx2.S           | 596 +++++++++++++++++++++
 crypto/ahash.c                             | 566 ++++++++++++++++---
 crypto/tcrypt.c                            | 227 ++++++++
 include/crypto/algapi.h                    |  10 +
 include/crypto/hash.h                      |  68 ++-
 include/crypto/internal/hash.h             |  17 +-
 include/linux/crypto.h                     |  26 +
 10 files changed, 2209 insertions(+), 130 deletions(-)
 create mode 100644 arch/x86/crypto/sha256_mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/sha256_x8_avx2.S

-- 
2.39.5

