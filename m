Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073492E7F17;
	Sat, 18 Apr 2026 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776540249; cv=none; b=ssOFNPw0Qm1zNR5HWjXWBmsSY5HdpxmMpyvGWSJhOSmJgOV7qBMGNmbQ6bq77ONKlHiA1ItHETLxvKNkNeYQRgaIFtgX3xAXmzIliG4c+MqSWMhJ8qW/K8aIX6cqx0aO9Y8xVQ9sjK+hj2Wk0d1lJ3CEecw2syiDGVsPHNZvZ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776540249; c=relaxed/simple;
	bh=tdg4zOtm2+jWeFUWUcvNyKmrLirMTYPG+xQCk+Ju4qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b43quQEXG4JOt7oSvA0jiwO/lJAuz/RienYUW3lEJ076xwU1nUlO/YmW4p1k1gR2eCf4eQJ1mdWD5Myac69e+/DThg1/nSOawYI6N8sp4rdEcWW+U0boMWUQPVzAuR0vssgtvClqc3xXhDtLzrwZMPDm7hJNRGtdobUnxYNjiuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYyxCzzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYyxCzzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4913BC19424;
	Sat, 18 Apr 2026 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776540248;
	bh=tdg4zOtm2+jWeFUWUcvNyKmrLirMTYPG+xQCk+Ju4qo=;
	h=From:To:Cc:Subject:Date:From;
	b=tYyxCzzT1R89UW9F2aL4j7LYHsN2rKCfKC0EDNFBuJNDwkQjCYl+On/Qar2nGEqG5
	 lIVglS5Vf8P25/YDYvj9RXRJDr2MxYn4Oic7eyF6hKLPLpJk/3CBcqdL+Q0BswIQpD
	 R0AWU99P7Mpqlrja8f2SKT8lh/qEEQ/ct+s5a+Y1SNFKo2kH17dV+Bld8zo8KKwvtG
	 ePSA1hGoWarmM1IGRTL11vKVaVrTMH2zuhtiLAOLt8K6B/6mjdJvRibjjqwPV1kehP
	 xlNrxbIqJ2EHs++QY/RKgqymagtfls+kr19aLK4UZBXvaC2j39Sop+hIN/exvTZiXi
	 bWg2JgETXrGXg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/2] Improve the crypto library documentation
Date: Sat, 18 Apr 2026 12:21:36 -0700
Message-ID: <20260418192138.15556-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the crypto library already has a lot of kernel-doc, it's not being
included in the HTML or PDF documentation (except for the SHA-3
kernenl-doc which is already included).  Update Documentation/crypto/ to
include it, and also add a high-level overview of the library.

I'd like to take this series via the libcrypto tree for 7.1.

Changed in v2:
   - Use simple string replacement instead of regex in kdoc_parser.py
   - Minor editorial revisions

Eric Biggers (2):
  docs: kdoc: Expand 'at_least' when creating parameter list
  lib/crypto: docs: Add rst documentation to Documentation/crypto/

 Documentation/crypto/index.rst                |   2 +-
 .../crypto/libcrypto-blockcipher.rst          |  19 ++
 Documentation/crypto/libcrypto-hash.rst       |  86 +++++++++
 Documentation/crypto/libcrypto-signature.rst  |  11 ++
 Documentation/crypto/libcrypto-utils.rst      |   6 +
 Documentation/crypto/libcrypto.rst            | 165 ++++++++++++++++++
 Documentation/crypto/sha3.rst                 |   2 +
 tools/lib/python/kdoc/kdoc_parser.py          |   5 +
 8 files changed, 295 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/crypto/libcrypto-blockcipher.rst
 create mode 100644 Documentation/crypto/libcrypto-hash.rst
 create mode 100644 Documentation/crypto/libcrypto-signature.rst
 create mode 100644 Documentation/crypto/libcrypto-utils.rst
 create mode 100644 Documentation/crypto/libcrypto.rst


base-commit: 8541d8f725c673db3bd741947f27974358b2e163
-- 
2.53.0

