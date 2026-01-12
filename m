Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B63242CC;
	Mon, 12 Jan 2026 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245800; cv=none; b=i7HOQ8vhsv8pv2umq/kTSp13jCwTzB9aD4MYVS0wl9Dv2MSA5ieD0vEA034ojx34DLNe7Lngz7d2Yq7q7MD6meFDkA1rFlHMVhINLL7n7NXbNroqPZ4jCJ/4bYvRGs78vopDdIHzMQJM6iTdjQRTGQUH9w05QM4/ueoGoxs/Gm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245800; c=relaxed/simple;
	bh=gKPegVOdOTFBLkcvg5JmDNGwdQNryqhr4ZKUObZBWW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlZfw+R1sub96e5uJ1QhP+Oh6HVjUt13jveWYKWtCgFJFXwmpoxpRR1dpqFpSEbQltlR4+aYlAWJArJuK4B/o5r8UIZzJmTL3krwuqXt0S+Xm5bt5kqlCDdcKq24W9aLbVBY13ltzmA6f8Dmg0K104IkZQiroJCKdfB7WBnTuX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNPns4AU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNPns4AU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E026C16AAE;
	Mon, 12 Jan 2026 19:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245800;
	bh=gKPegVOdOTFBLkcvg5JmDNGwdQNryqhr4ZKUObZBWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNPns4AUB6IFYkxnPq0QTR0KPVOq3rh9saC/xeXyfAgv9l7GY6JKe+/ai5CwNlIPR
	 iGV6sf7GOMCBBOYUb6H3OemOH4f0g6N9AG2nXiw8MnO+tA3tugcAtvxQqKnV3wluci
	 CNlzp0Ma1shaRGZYoPxW2/PCGl2HlkvDHX5GMsHR2vVw459z2L4rOsXmc2FKKbdEhI
	 +ewZn43Ewtf0TB04PGOvVXvALgW7sfw7QjVuX3tpNLWP5O3XRs1n6498AkFf8vKHKm
	 UGJ/3SARiNeXl8ArBO42WR5Nd43Lsq6qn6Kov12nIGPBMpG3+ccumgdWyzNVCVnU7I
	 PAhpO3zmzFy3w==
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
Subject: [PATCH v2 05/35] crypto: arm64/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
Date: Mon, 12 Jan 2026 11:20:03 -0800
Message-ID: <20260112192035.10427-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
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

Acked-by: Ard Biesheuvel <ardb@kernel.org>
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

