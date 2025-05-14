Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3213EA98;
	Wed, 14 May 2025 05:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199962; cv=none; b=aFriMEtKUQ+gPu4wr4fdv+yYfTvYrhj9jOEGb2qw4T6M0Z1RmZrFz0xUZAlDXIukKQiqNHLoN2OZF+Z+d0PsFvsm7Es7eRoG+M3NjCuBmMp+vd4y3PCqsjK2tjCb7sw5JVLaE28eUOY+3rltlnaDZFeYtyVHf+tZ+nXx4Zxipyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199962; c=relaxed/simple;
	bh=xmNb52zrG4E27ByLWoVRVDykaFQ8CdtLS6iK9Dk3nV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mEMOmoIVEs/QV/F6ZUMnpatmXCUQBI+Ke+lVQuWUTvOkI5QFJbUBxbkDK4AhnZpYa/iv2Jfdgd7azWTMU39CcsiLt1hI5b89nwyOisvWGXd/i3jt7/CVXd+s4iByHTsm65S1ajV5t4GpKOi0Tw+hOdH5RDg8iins8teYSU8lsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEn/m2PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEn/m2PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A890FC4CEEB;
	Wed, 14 May 2025 05:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747199962;
	bh=xmNb52zrG4E27ByLWoVRVDykaFQ8CdtLS6iK9Dk3nV8=;
	h=From:To:Cc:Subject:Date:From;
	b=dEn/m2PKu0tjxDilPRowrR7HMf0oYqZe39uyPMbSUvqjkiVI3mIfiOAba5z35V6R7
	 q9rfm89UvZjqHoXTT2VKbF6LZzpabQJeObboHdsKFfxu3UGqhVxUmUzpi96w334kS+
	 dY2zcD10zKalVpMAfB4LWdqPksIuy+HJroF8eCKKcamuOtb4xkcY088r1/RjXu7vcf
	 gA6xSBxpMiPWLKUkVoYmgHBR4KwzSUyAPcH1qmpOTneyKjGzW8epFTbRaLi4R7NTp0
	 9iHiVJlmeaVwtvJBhTUmPoKhm5J4uVb2lLX3D5f6RcCz2VH4A+5LDXuSFrEmf21ucF
	 Nb6+Rgu+oWTkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Danny Tsen <dtsen@linux.ibm.com>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Date: Tue, 13 May 2025 22:18:47 -0700
Message-ID: <20250514051847.193996-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

As discussed in the thread containing
https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
Power10-optimized Poly1305 code is currently not safe to call in softirq
context.  Disable it for now.  It can be re-enabled once it is fixed.

Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/lib/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/lib/crypto/Kconfig b/arch/powerpc/lib/crypto/Kconfig
index ffa541ad6d5da..3f9e1bbd9905b 100644
--- a/arch/powerpc/lib/crypto/Kconfig
+++ b/arch/powerpc/lib/crypto/Kconfig
@@ -8,10 +8,11 @@ config CRYPTO_CHACHA20_P10
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_POLY1305_P10
 	tristate
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
+	depends on BROKEN # Needs to be fixed to work in softirq context
 	default CRYPTO_LIB_POLY1305
 	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC
 
 config CRYPTO_SHA256_PPC_SPE

base-commit: 57999ed153ed7e651afecbabe0e998e75cf2d798
-- 
2.49.0

