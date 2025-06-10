Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D029D19
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 19:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749583098; cv=none; b=gHt8aqKxC724v8Gv5bvUOto48VR63mED64szEFR1yNRk3o3IAjDlVA8SZSkiJeoKQJ+pvZAyrbz0KtrLjDBOZdW+uYDv0nDrvL02N4dp4njCKkGTf6la1Q0RqpBJPU3YLj64mBtrnrhyj3xkQhaRu/7OflJDPIL40SDit6xX4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749583098; c=relaxed/simple;
	bh=Hgi9E8q0mLSLZfB/ljNw8agdvIzOBd6qO7E7LF0qQT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm7GKoScbNdRv+GbXvfbLBZ3c3j9mfwqURBTL85M3p6cPmw2bT12RrQJIInOK6SJB2qqVzenfDe7Ado3odDNz+0nLqp2tBPGL9JbjRzLsij9cagdv65unOIobn8synD2bGKNbVEjkclkqAr0bNfafc9p7tYZ9VsOGxABlhUgQBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rueBjuRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rueBjuRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C7C4CEED;
	Tue, 10 Jun 2025 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749583094;
	bh=Hgi9E8q0mLSLZfB/ljNw8agdvIzOBd6qO7E7LF0qQT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rueBjuRAZHO82dzCNAiJlxhyyftdDjlKuwDK1wYGhtRTe26/3GFllynVfNJZ/oPPe
	 NkN9pGA4NOwWwLM25UUzvcMgoqx3TVBHlVxaqDFtZSmLGueL2Vs6vnqkDaUsl7R4UE
	 EB7g9lgQafdfpjP7285CO0G09j2SrKAYa6gwvd2qXuk3I7ueTydcBJ1jqKqHWtizTX
	 HDy8pJGt94m/gg7OZtSQPffDji/n/gMTa6rAcnuwvenCjUXfUuBXZ+hfYwAP+dvRcG
	 OuNC7+4WzpGeaCJjqbfRfWPwO6SAN5o4MfqadN6210WuQkAxfNPBzF+U0taL0HoiOh
	 gRBg+ZqzM9heg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
	freude@linux.ibm.com,
	dengler@linux.ibm.com
Subject: [PATCH] crypto: hkdf - move to late_initcall
Date: Tue, 10 Jun 2025 12:16:00 -0700
Message-ID: <20250610191600.54994-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <8bf5f1b2-db97-4923-aab0-0d2a8b269221@linux.ibm.com>
References: <8bf5f1b2-db97-4923-aab0-0d2a8b269221@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The HKDF self-tests depend on the HMAC algorithms being registered.
HMAC is now registered at module_init, which put it at the same level as
HKDF.  Move HKDF to late_initcall so that it runs afterwards.

Fixes: ef93f1562803 ("Revert "crypto: run initcalls for generic implementations earlier"")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hkdf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/hkdf.c b/crypto/hkdf.c
index f24c2a8d4df99..82d1b32ca6ce4 100644
--- a/crypto/hkdf.c
+++ b/crypto/hkdf.c
@@ -564,10 +564,10 @@ static int __init crypto_hkdf_module_init(void)
 	return 0;
 }
 
 static void __exit crypto_hkdf_module_exit(void) {}
 
-module_init(crypto_hkdf_module_init);
+late_initcall(crypto_hkdf_module_init);
 module_exit(crypto_hkdf_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("HMAC-based Key Derivation Function (HKDF)");

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0

