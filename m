Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AF033260B;
	Fri, 17 Apr 2026 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776409074; cv=none; b=myNVvHrFypvyWsGQZq9Rk7LFGlqnHJUNi6C1GMk3yjZHh6tbSxUMSzKMSg+na5Jugoh/PirJtqpAjHkDwPvlodY993PM/8ZnemaBXQYhLLvD7s6eBGa7Xn30ZGKSrB/JjdapWdFPKH414N1I+jlc4UQLRy7gsrjkgAYO+oJDvGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776409074; c=relaxed/simple;
	bh=1neoicsm+sAaMjF/qdatKdX/YHOR+mGOwg+8+PbRhds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gw7SVRrjaRwV7FKR99TegW4LE+Duj3qAHrFUVnrZZaySJIYgS3OnAUJu8mJDfSRyi+U8IrmJu7gYAdtsxXad1dyF/vXMVgf6OWaLZt02JmEezM1tXsB1H0ycgMjD8T2eDKcTtIY53yXgPCPRvZeYlYJ6TaA/c972A0Eawrtr8ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uEUg8B7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEUg8B7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2536EC19425;
	Fri, 17 Apr 2026 06:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776409074;
	bh=1neoicsm+sAaMjF/qdatKdX/YHOR+mGOwg+8+PbRhds=;
	h=From:To:Cc:Subject:Date:From;
	b=uEUg8B7PoDNVmzwaTjA0PXCsTLTAA052tMZNxY8Qj5avl5tHv47sPEU0tGwsu3XSW
	 o4eJLj9KYJvsYADX4rv7BW65bghCcUATX/7TEgqsVXN5w0o+PRcNdAvXpIWlq1vV7C
	 nVskYsEzDIm9h47UYdi8DBvqc8YmwiZWZc1UeNOiWx3ij5VQ1eRWIHYRLB1cuJZGK7
	 ZF7vp41vrJv5XXd6yZt1Lqrh4+l749BsuhCUUv6hxXzruohhoFS/KJelPvUL1wW7F7
	 KmHDt6x6q6nlAKFKpMacaigwfxPV9esT3WsZKyzqX+tjNkxJ2EG0VLPEHUAwpir4XW
	 OPizHj3TzOrrg==
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
Subject: [PATCH 0/2] Improve the crypto library documentation
Date: Thu, 16 Apr 2026 23:55:27 -0700
Message-ID: <20260417065529.64925-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the crypto library already has a lot of kerneldoc, it's not being
included in the HTML or PDF documentation.  Update Documentation/crypto/
to include it, and also add a high-level overview of the library.

I'd like to take this series via the libcrypto tree for 7.1.

Eric Biggers (2):
  docs: kdoc: Expand 'at_least' when creating parameter list
  lib/crypto: docs: Add rst documentation to Documentation/crypto/

 Documentation/crypto/index.rst                |   2 +-
 .../crypto/libcrypto-blockcipher.rst          |  19 ++
 Documentation/crypto/libcrypto-hash.rst       |  86 +++++++++
 Documentation/crypto/libcrypto-signature.rst  |  11 ++
 Documentation/crypto/libcrypto-utils.rst      |   6 +
 Documentation/crypto/libcrypto.rst            | 167 ++++++++++++++++++
 Documentation/crypto/sha3.rst                 |   2 +
 tools/lib/python/kdoc/kdoc_parser.py          |   5 +
 8 files changed, 297 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/crypto/libcrypto-blockcipher.rst
 create mode 100644 Documentation/crypto/libcrypto-hash.rst
 create mode 100644 Documentation/crypto/libcrypto-signature.rst
 create mode 100644 Documentation/crypto/libcrypto-utils.rst
 create mode 100644 Documentation/crypto/libcrypto.rst


base-commit: 3cd8b194bf3428dfa53120fee47e827a7c495815
-- 
2.53.0

