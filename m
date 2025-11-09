Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A795727B349;
	Sun,  9 Nov 2025 23:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732200; cv=none; b=KWnUb6vTLiSCLg5wGvV7VEstA2wSy0PggS3+yl243JmJz1YPzDv/9GNpcdTyhZn8q+786cQtMAcDyLW/XG4s7B6iSVkExDXB6HW25+FlekpvKcqnmfdZaBQwDqcS3azFks4rETgaDmi4/369atZtPXrQtaQ07E0Jr6SPM53W0WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732200; c=relaxed/simple;
	bh=7gddUMmP2coCrWDBPHW0Qp0T0QzSnROq55ixSxyk3eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4+3NhYWxWCbwFSQnxj14N1XzQ0MigArDF2BDSSjGSTQKgfgCXamDkpoVGKjECAIi/DQD8TaGMPqoL5E4Y9wxIIyGKmbQDIpzWwtzN1FnI4wf9ENS/zOEA0W8eNx+Kh8aT3ud/luA9HH90MYUyuTOG5MIwwFDSlMrym8HAX5BkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aep2Ic4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aep2Ic4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17266C4CEFB;
	Sun,  9 Nov 2025 23:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732200;
	bh=7gddUMmP2coCrWDBPHW0Qp0T0QzSnROq55ixSxyk3eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aep2Ic4mAOPEy+UzZYgxrcqU0Vc0IuKyB9GT0ijy2wWrUZCCr0TJjQ4sWV5RrXDBz
	 +z276rb7zAJHWRnhqTchQ4FfGfx/eH+5H+EP7rJNZejjjUClO3qNZ+3jroRdLsC1Cb
	 9IgCW15wWGZeizwbowEGZKPJR3ZL7i7Ne1uTonvktqbt0XONmQ09aQsgA/9a3xXZBU
	 Q5idrcFJ4beRn05+Sb4Zj8wbQ2/xrH+2QBbKIwc/977EeKhG8ENexjF4xTUxPwJoma
	 Ll0IrZl5KfVIRV0xSBa7f3vXf1tREL6bSy9PlhvtJDyiJjuU79z6DCKfsPHSrbZuQ4
	 w6Nga/fLzOnOg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 9/9] fscrypt: Drop obsolete recommendation to enable optimized POLYVAL
Date: Sun,  9 Nov 2025 15:47:24 -0800
Message-ID: <20251109234726.638437-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_CRYPTO_POLYVAL_ARM64_CE and CONFIG_CRYPTO_POLYVAL_CLMUL_NI no
longer exist.  The architecture-optimized POLYVAL code is now just
enabled automatically when HCTR2 support is enabled.  Update the fscrypt
documentation accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 696a5844bfa3..70af896822e1 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -448,13 +448,11 @@ API, but the filenames mode still does.
 - AES-256-HCTR2
     - Mandatory:
         - CONFIG_CRYPTO_HCTR2
     - Recommended:
         - arm64: CONFIG_CRYPTO_AES_ARM64_CE_BLK
-        - arm64: CONFIG_CRYPTO_POLYVAL_ARM64_CE
         - x86: CONFIG_CRYPTO_AES_NI_INTEL
-        - x86: CONFIG_CRYPTO_POLYVAL_CLMUL_NI
 
 - Adiantum
     - Mandatory:
         - CONFIG_CRYPTO_ADIANTUM
     - Recommended:
-- 
2.51.2

