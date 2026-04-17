Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEF736D51D;
	Fri, 17 Apr 2026 06:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776409075; cv=none; b=rXTkmTNuWfuOPQAqjbtajA0c9Oezhl7/Z78TEC0/Eqt36c3SJShFxx/y/8QdKeY2HjQjXe+aljjHtBUNAMFvg89BZtGJKce9UlJslZ1H4El65vLnNFQEUY118RMIRMsZkDzGg9wTw3X3JiKDLKTSNoOnKaC0jSpKpXbM0RU3p1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776409075; c=relaxed/simple;
	bh=1pn8XGi6lKw0Bve1bbYGGWLCv35x/ywkE1kaA1Lwpzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPKY0O0Ku3V7UplPFvjRNL8niGGqAKSnk3wN7KEQFB3J/sL4LoAg0F56botBFQth9KMWglb828qWxhs3wgNh1MeiBCxr7xnkMgMYBzasGZBh//rvNw8GzWKkCW+vBWxQP9XE4PLWgqCJ+fmOJxb0uilmul8TMUD7wVHmE+kvxFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+9uFmbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+9uFmbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95133C2BCB5;
	Fri, 17 Apr 2026 06:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776409074;
	bh=1pn8XGi6lKw0Bve1bbYGGWLCv35x/ywkE1kaA1Lwpzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+9uFmbO9jMFwR/rwIMH6MU9m9GI22/yJLrkQ+h73lWaNyIR4y9F+d80+IvWRshiD
	 kDy/sj4Xf1PqiGmAdmPtqJLljY2w7eiIh4TF2x5f+UcCjbtbMQ3PN+KFrdO6Y4AO52
	 e2XNk1jqmreI0kM7wCFfG05b0O4lsWFi4St1vNLdL6cjNtQ69FFfQqb8xi7PZTcJks
	 9zImnZryY735PltYuCGdCSu+8dFEm4UNpQp5uGhc3jdxMC2O0xVmmogGGzLn/KyHhY
	 63tRiKZqgPJYbkaUyov1MVvFx2uIWMo9GaR2/8Yp/30a5nCYi5Qfb+7FATRujCrZZv
	 poqaBj6M8daxg==
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
Subject: [PATCH 1/2] docs: kdoc: Expand 'at_least' when creating parameter list
Date: Thu, 16 Apr 2026 23:55:28 -0700
Message-ID: <20260417065529.64925-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260417065529.64925-1-ebiggers@kernel.org>
References: <20260417065529.64925-1-ebiggers@kernel.org>
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
lib/crypto/ kerneldoc is wired up to the sphinx build:

   linux/Documentation/crypto/libcrypto:128: ./include/crypto/sha2.h:773: WARNING: Error in declarator or parameters
Error in declarator or parameters
Invalid C declaration: Expected ']' in end of array operator. [error at 59]
  void sha512_final (struct sha512_ctx *ctx, u8 out[at_least SHA512_DIGEST_SIZE])

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 tools/lib/python/kdoc/kdoc_parser.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/python/kdoc/kdoc_parser.py b/tools/lib/python/kdoc/kdoc_parser.py
index 74af7ae47aa47..f982db7fddac2 100644
--- a/tools/lib/python/kdoc/kdoc_parser.py
+++ b/tools/lib/python/kdoc/kdoc_parser.py
@@ -437,10 +437,15 @@ class KernelDoc:
 
         for arg in args.split(splitter):
             # Ignore argument attributes
             arg = KernRe(r'\sPOS0?\s').sub(' ', arg)
 
+            # Replace '[at_least ' with '[static '.  This allows sphinx to parse
+            # array parameter declarations like 'char A[at_least 4]', where
+            # 'at_least' is #defined to 'static' by the kernel headers.
+            arg = KernRe(r'\[at_least ').sub('[static ', arg)
+
             # Strip leading/trailing spaces
             arg = arg.strip()
             arg = KernRe(r'\s+').sub(' ', arg, count=1)
 
             if arg.startswith('#'):
-- 
2.53.0

