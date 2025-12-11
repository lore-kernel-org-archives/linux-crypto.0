Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D77A23909C;
	Thu, 11 Dec 2025 01:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416059; cv=none; b=j5jRMCtzwepl7eWpM6f1pgmYNXwhms1omKpumzrG9kS4v72hBSFxgZREfkfml4jnNBvMzpOREVTp8xvLM7oA28MONwCKUMS1ZzqAy9oMenJdt4TzCdd1yvXsXLCoOEeTnHSJTg6XLvSeMMYNaLKrpyCWJ3y5vlH7eFciB/1jg7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416059; c=relaxed/simple;
	bh=c7Wxsv2qMnAP++ftzBA0W0ugHU/R9/cZbMizhIM4xBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYtjaAjj+DHzHJUrHDFIwmYvXfhZ2YrBoRjseYxXPsxupq6TUOHjIDJF9NAT4KxCHTtohsRdfyvOmFzXfsN6TjmR5ef2qHLRj59KXZlmSzza5zNpvX3YRAKCB4fCJvNi1zjTcBvlNLxP+Ev4SwYW/ZI0KEP2WTqcOA4N5JT7Lf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7WuFitk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7WuFitk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC50C19423;
	Thu, 11 Dec 2025 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416058;
	bh=c7Wxsv2qMnAP++ftzBA0W0ugHU/R9/cZbMizhIM4xBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7WuFitkE7uaxLhYqf6hpILerfgFpEIQLzFcN1Ho/WhQzTmIywxWkHO4r2Xbs24HE
	 dvusjL9951+QWK+A13fhL/kZgFJT5ikI+0ZBC6MAmf5SUNjxAxgkpFWmFIgGI9NPd7
	 vg5QAFDRFCXO1PRP+lUIuQ6xk5A5+fjHmriUDpyzPD3pGmImYY25nLMgv/gbgVXt6p
	 pSSbVcG3FFWZURfrGYgJvgUtPdgCIdg/l5ekhSaIbRk8Kpun5K+U0k1OldieLSE9ms
	 3fm37MMtO746y4O4+gMdUGbrTNRpeefwoc+ha+bKHx5SZzmDEiwZ4eCMVRvjkzqwqA
	 ojCucoKSpYEvQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/12] fscrypt: Drop obsolete recommendation to enable optimized NHPoly1305
Date: Wed, 10 Dec 2025 17:18:44 -0800
Message-ID: <20251211011846.8179-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_CRYPTO_NHPOLY1305_NEON, CONFIG_CRYPTO_NHPOLY1305_SSE2, and
CONFIG_CRYPTO_NHPOLY1305_AVX2 no longer exist.  The equivalent
optimizations are now just enabled automatically when Adiantum support
is enabled.  Update the fscrypt documentation accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 70af896822e1..c0dd35f1af12 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -453,15 +453,10 @@ API, but the filenames mode still does.
         - x86: CONFIG_CRYPTO_AES_NI_INTEL
 
 - Adiantum
     - Mandatory:
         - CONFIG_CRYPTO_ADIANTUM
-    - Recommended:
-        - arm32: CONFIG_CRYPTO_NHPOLY1305_NEON
-        - arm64: CONFIG_CRYPTO_NHPOLY1305_NEON
-        - x86: CONFIG_CRYPTO_NHPOLY1305_SSE2
-        - x86: CONFIG_CRYPTO_NHPOLY1305_AVX2
 
 - AES-128-CBC-ESSIV and AES-128-CBC-CTS:
     - Mandatory:
         - CONFIG_CRYPTO_ESSIV
         - CONFIG_CRYPTO_SHA256 or another SHA-256 implementation
-- 
2.52.0

