Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB15A1EB193;
	Mon, 20 Oct 2025 00:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921615; cv=none; b=J6o9/sEuWHN4EgAXsv7HdcqC4sLvCbnrg98kS7L+GFm6LdF9RPdu+mXS0ntHt1jcZOXFbdWs97hFsXyaJBNK/F76Q6vjLjoRKJ1dFGPteCtTSxx7PttjXbdfJcJGOEAfyoG+oXjXtSwmn6Rt7a7I11BVB+V4XV0rZN9MXFwAuRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921615; c=relaxed/simple;
	bh=sNfiHzZBvEsZv8KJ6ym8WqKRimzL6B5akfZG5UKLVY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgRf7O5Njq71oaVLBCvOblQFILCbNHAJWGkB5SDlHx3a9UL5LRzmmxCbWWoEp/TAshtsCPniHTLfAwXZruXoHsOnEc1u+LlN1T9tbYyf90QDDjNr+XnjT0GgYszfhOC+9mAIlbyZh1NoEQ0Uf/YGkPwIf1uaBRtluHsgVkmNopg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+1/pb7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+1/pb7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1EEC113D0;
	Mon, 20 Oct 2025 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921614;
	bh=sNfiHzZBvEsZv8KJ6ym8WqKRimzL6B5akfZG5UKLVY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+1/pb7/WHY0BbmCnFWu9ck8/blkeG9BhHkAJWASM6Cj74Mv9oCEUDeDIDlLkFp+3
	 On4VrnUQzZ0UBl6dMT5QlqCvWhbEYI2zDNgrsOIFYXKM71seCNw5tgjBBzubIpUuD5
	 SP1Mkz/jR76paC46zOSymIVpi847dht/kP+m96LQRdE/hc2McrvSoTmu98NEkdTAfO
	 pa+Fp9v0+6myx6kuTNr6DdrJ/kjclGqnQm9/htHrtYHpKoF01Tbrdv8FUSvUSBabiX
	 2GQyfSJfPMSsIzDKLYeMGKYaj5ujP6tTNrPm9FC9AVsIl8YggN1OQsmK2FHjZ5Tk5V
	 e9TfUryjC8esg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/17] lib/crypto: sha3: Fix libsha3 build condition
Date: Sun, 19 Oct 2025 17:50:27 -0700
Message-ID: <20251020005038.661542-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The correct condition is there but is commented out.  Fix it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index b7fa51bfeebb5..2f15cef850507 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -266,13 +266,12 @@ libsha512-$(CONFIG_X86) += x86/sha512-ssse3-asm.o \
 			   x86/sha512-avx2-asm.o
 endif # CONFIG_CRYPTO_LIB_SHA512_ARCH
 
 ################################################################################
 
-#obj-$(CONFIG_CRYPTO_LIB_SHA3) += libsha3.o
-#libsha3-y := sha3.o
-obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
+obj-$(CONFIG_CRYPTO_LIB_SHA3) += libsha3.o
+libsha3-y := sha3.o
 
 ################################################################################
 
 obj-$(CONFIG_MPILIB) += mpi/
 
-- 
2.51.1.dirty

