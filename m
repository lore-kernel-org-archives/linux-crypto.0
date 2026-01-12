Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3777D322B88;
	Mon, 12 Jan 2026 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245800; cv=none; b=Mney7UdsEV9Oed51WXC7dacspkim0yleTXur1F721pJ+8sFS+hZJ7cc6yUWc4rwaIL4bVMZ7MGUTMDGmQ+4Fnz6/ZeE0PgmKNA9LAVp6ftthxSY+yv2AzPWHp+Dgk2b2d0xm88wrbrdwblRNveX4kFEwdoP/YK2qR02L1AMv9E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245800; c=relaxed/simple;
	bh=2M8Gb/YRtberadtTzhIXpTjnvGh0/0hqHwkqCXSjCBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGXz78fPSbw5mkWeD4j5aVDGXe9HKDLqqgsb/GGGms3zjKfiiI8PJzL9Tj+oaRcrCUzLfEg4MhujfW6XZmPpYB2jmAunbquyuGzme+3+xkpi/+r+akiT5fibOfUhrtk/Sspn7W2eyvMGtlq2lr14P4Jbomtzq9Be+78f8d3dp0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeWo/wwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeWo/wwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1A5C19425;
	Mon, 12 Jan 2026 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245800;
	bh=2M8Gb/YRtberadtTzhIXpTjnvGh0/0hqHwkqCXSjCBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeWo/wwnv7GJEhSx1Rr6KXtyzCKz82DrZzBSGOzoyh9p4L5PDGU+fcJJAszf9aOvC
	 3nQ1ZzuD+/BhBCf3I+xz0Ga4TD6uXEJPz4pgcGUfHRNMN773cTSbwpo42TUOQTgpLQ
	 p8/MShjCL6T2gM8EL3Q8azFme2TsUyDO4bZGXnEQgI3xm/Z69jIGxg4THjBVqgTQgn
	 nFFvA/3thNtyEHoSxe2YGfG024AqgG+7kvBldYZurP6i60JW4o+nM7NA9zh9EcitJW
	 eStkXyo61YXmHmBT7eoGdyDpRaxFgDXyv5lqvfT0EMmxoAqngYIrbCTHZOTCG9bumH
	 nX/6iHZThwKEw==
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
Subject: [PATCH v2 04/35] crypto: arm/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
Date: Mon, 12 Jan 2026 11:20:02 -0800
Message-ID: <20260112192035.10427-5-ebiggers@kernel.org>
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
 arch/arm/crypto/aes-cipher-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index 1da3f41359aa..87567d6822ba 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -190,12 +190,12 @@
 	.align		3
 	.ltorg
 	.endm
 
 ENTRY(__aes_arm_encrypt)
-	do_crypt	fround, crypto_ft_tab,, 2
+	do_crypt	fround, aes_enc_tab,, 2
 ENDPROC(__aes_arm_encrypt)
 
 	.align		5
 ENTRY(__aes_arm_decrypt)
-	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
+	do_crypt	iround, aes_dec_tab, crypto_aes_inv_sbox, 0
 ENDPROC(__aes_arm_decrypt)
-- 
2.52.0

