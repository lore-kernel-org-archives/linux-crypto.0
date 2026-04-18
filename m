Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2238930C35C;
	Sat, 18 Apr 2026 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776540249; cv=none; b=Io3qn6G3WkKwqGjIG3XpHEPF175vXqAbZa8CcPlvu/TWR0GMQXwGMjD7lQGQa/nbsK7o/tFVVqi6lPjyHtinUsIJfEvpJogEF6InjpFeue/NfGjkFVpb6fxnx7iOgfn7NrpEN9+mYVUS2mygWGlanKD07oX3XOme51WfMbXcpKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776540249; c=relaxed/simple;
	bh=DsZR9ORQr2xRMvmkTl1b+Qpd6GTPh8kidWL3zvzrYVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8NcDO3GYpe2DMiwVsXX0o23hdU5ib29urEEQccC3m6A2cQYPVduRv01l8BEMaMaJsuCPXgMvwx+saCIxcxp05BC0pi81sAk5ZKm1d5F/YeZW6K8+cxCQqLhvz28TUe30fbgqQF+gIAg2PUszWC/uB6FIPvYYpWz3XOc3da01yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sF/vCHAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sF/vCHAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C38C2BCB3;
	Sat, 18 Apr 2026 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776540249;
	bh=DsZR9ORQr2xRMvmkTl1b+Qpd6GTPh8kidWL3zvzrYVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sF/vCHAZkw4T6O5NdEcFBy7ZgCI0zbM0HGXoCyhUWzt4KjtJPpQwsiOugVWOZHcLr
	 pmvwz3DnwccQM6TuiURREEwsdyxtQ2+5y+boEAAKMdf6IO5epe7ka5uc3jych8hYa/
	 xq3c8LXzJxeA8XhmydCzCBbm07fzHrW1ApciuVkV9Bkxldw7itJ9nD1NTKKqsHDnec
	 LRQcFoFDiO5zbEa51yPVkQu2ilkAeUmcpNa99qLRndjlpq2P+zkX3RXKtig5Hmt3Yj
	 9zzFI//0bY9rpV0ddLPBbEL8nzKS0KWxMltT8rGI1WwGJ8TCY+5rlksFr0t4ZGltPm
	 93/oiNl4aHJpg==
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
Subject: [PATCH v2 1/2] docs: kdoc: Expand 'at_least' when creating parameter list
Date: Sat, 18 Apr 2026 12:21:37 -0700
Message-ID: <20260418192138.15556-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418192138.15556-1-ebiggers@kernel.org>
References: <20260418192138.15556-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sphinx doesn't know that the kernel headers do:

    #define at_least static

Do this replacement before declarations are passed to it.

This prevents errors like the following from appearing once the
lib/crypto/ kernel-doc is wired up to the sphinx build:

   linux/Documentation/crypto/libcrypto:128: ./include/crypto/sha2.h:773: WARNING: Error in declarator or parameters
Error in declarator or parameters
Invalid C declaration: Expected ']' in end of array operator. [error at 59]
  void sha512_final (struct sha512_ctx *ctx, u8 out[at_least SHA512_DIGEST_SIZE])

Acked-by: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/lib/python/kdoc/kdoc_parser.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/python/kdoc/kdoc_parser.py b/tools/lib/python/kdoc/kdoc_parser.py
index 74af7ae47aa47..c3f966da533e0 100644
--- a/tools/lib/python/kdoc/kdoc_parser.py
+++ b/tools/lib/python/kdoc/kdoc_parser.py
@@ -437,10 +437,15 @@ class KernelDoc:
 
         for arg in args.split(splitter):
             # Ignore argument attributes
             arg = KernRe(r'\sPOS0?\s').sub(' ', arg)
 
+            # Replace '[at_least ' with '[static '.  This allows sphinx to parse
+            # array parameter declarations like 'char A[at_least 4]', where
+            # 'at_least' is #defined to 'static' by the kernel headers.
+            arg = arg.replace('[at_least ', '[static ')
+
             # Strip leading/trailing spaces
             arg = arg.strip()
             arg = KernRe(r'\s+').sub(' ', arg, count=1)
 
             if arg.startswith('#'):
-- 
2.53.0

