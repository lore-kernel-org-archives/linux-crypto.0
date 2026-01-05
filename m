Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE819326D55;
	Mon,  5 Jan 2026 05:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590093; cv=none; b=Uqlsl3UlvJg6OHF5cuXRxIaAJlZ8JIxTsVQf5DNO4uj+zYnKOS4PAJjaUrD+boLfOnCx9ZJ7rg83dxaNkYBjY2om6FaZGS3M/lVhMfMJvxNkMXkEEWXBZ47a6ANePZoSmGBIyL61kfMB7p8G03kReXjomCjic0lIDbx9p8d+FU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590093; c=relaxed/simple;
	bh=GVpfgLYStBAX0V1nv+zpcwWE8NNlDpzM24qOLk0l6H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+DKu/F7eeqmoKQ/lFP8kJBTet6AiTShqzSPcT1DZT1qUfDhpetVM3Je8cWrumLZI4Hz2usj3K3Vn9AIE1O47Ry1oI9h7RKZ31IZlx4fY0fthILKfCI+qjIPyy46u8NqT25OiqxvNOpHIZyPVSWIYSLEg6CCsXzzNvtZDDN/qkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcaDwAKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcaDwAKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0776FC16AAE;
	Mon,  5 Jan 2026 05:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590093;
	bh=GVpfgLYStBAX0V1nv+zpcwWE8NNlDpzM24qOLk0l6H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcaDwAKvV9yG8G8Pz4lAe99jwm46Fe9LLX8+KbH5dMJSycqIAUz83Pyr5V6Cd1b04
	 YoMgKpCPcIYuZMn4nHnOWiMAoLtfwubSrFn7sUIu8xppL3qu0xo6ojvfww4gONJB8V
	 rq7To3cHCghDjntKqSetWW5zMDKnbMruaVIHEDQ7PPwotlLt//+yJcjrzB/XygRUXR
	 IgzDKNgYpYIrxCD+tJf/ynFCWwPV4C88wsk+otewUC3xwsxr4ezuJsjKuRaoi2otT4
	 5L4MHdL6JsCiBx8xOZs9AaNExwgKNNXW1ADOHPLOADwT+cGkHm5IJyFSx+sEZiR77g
	 QVn77rj2ogf/g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/36] crypto: arm64/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
Date: Sun,  4 Jan 2026 21:12:38 -0800
Message-ID: <20260105051311.1607207-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of crypto_ft_tab and crypto_it_tab from aes_generic.c, use
aes_enc_tab and aes_dec_tab from lib/crypto/aes.c.  These contain the
same data in the first 1024 bytes (which is the part that this code
uses), so the result is the same.  This will allow aes_generic.c to
eventually be removed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index c9d6955f8404..651f701c56a8 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -121,12 +121,12 @@ CPU_BE(	rev		w7, w7		)
 	stp		w6, w7, [out, #8]
 	ret
 	.endm
 
 SYM_FUNC_START(__aes_arm64_encrypt)
-	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
+	do_crypt	fround, aes_enc_tab, aes_enc_tab + 1, 2
 SYM_FUNC_END(__aes_arm64_encrypt)
 
 	.align		5
 SYM_FUNC_START(__aes_arm64_decrypt)
-	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
+	do_crypt	iround, aes_dec_tab, crypto_aes_inv_sbox, 0
 SYM_FUNC_END(__aes_arm64_decrypt)
-- 
2.52.0

