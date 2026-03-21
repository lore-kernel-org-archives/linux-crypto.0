Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E309B3385AA;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066319; cv=none; b=gZRbghlQi5ZqJhPPPLuZbRCTrjgZdJzEiRtt4Zb9sM7heHNqrT4oqPuEWkj4ZHAdPKic4qOjjhZKEXaiThdyO3q228EN56oIL7Hl/0Iz6yymmWYJVKDBQE9y2ZQIhp6UBa3wv+KTqwQ780MQZ//azoaJHGhqCx4K2Hi9bz5PlLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066319; c=relaxed/simple;
	bh=LFyrpEF3QvWGOvRWq/UotcrYPoPPntBBC70R8Z4P+no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmWX64tExntu32Im0xYf/YQsa+45rPtJzbcNFQYhkRF6IQhptoJreK4aiPl8ucnXz6RYhktnuhhW2gZXbYNs4JGk8ugFI6jaNN22jVQWV8aUeeqM3BT0S1tmO8c/RuSAk5g67LQinNK/KiG2wgzZnpQRTsBoh+ttEHfjLeFIORg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCF9OFR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCF9OFR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7B8C2BCB1;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066318;
	bh=LFyrpEF3QvWGOvRWq/UotcrYPoPPntBBC70R8Z4P+no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCF9OFR+8ZUEqZzBoCEQ4qqqtsIcx+/I1Dr26HxDTP/JPJwj7gMHMUNAUW4vRvRVb
	 0vXwTN+980MajNK4yucFSoDA+fRIy87a9DWaK0wb4w5kzo+iaSJq4Jom4r49efuMx+
	 Dz7gVTwF1G4iwhGJjLa/A5AfHPmZKZTCKuL1bcdcwwEWdZXlg1yiwiESCKd+zJtQCi
	 t9zp1e4rKdIjn14c4UGu4e9ECKES4c/rzf21LQA5Rl5oxpz1M+8gum+NFnuSO06cO1
	 drZpc8UEXTo/zci0sPWDFhCCQ+P5hWlXJr0HLDeGKOKNgsm16Ffwz9Zz/+jTWAv2jg
	 Dj0N4A/N6zEPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/12] crypto: sm3 - Remove sm3_zero_message_hash and SM3_T[1-2]
Date: Fri, 20 Mar 2026 21:09:25 -0700
Message-ID: <20260321040935.410034-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove these, since they are unused.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/sm3_generic.c | 8 --------
 include/crypto/sm3.h | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index 7529139fcc96..0c606f526347 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -12,18 +12,10 @@
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-const u8 sm3_zero_message_hash[SM3_DIGEST_SIZE] = {
-	0x1A, 0xB2, 0x1D, 0x83, 0x55, 0xCF, 0xA1, 0x7F,
-	0x8e, 0x61, 0x19, 0x48, 0x31, 0xE8, 0x1A, 0x8F,
-	0x22, 0xBE, 0xC8, 0xC7, 0x28, 0xFE, 0xFB, 0x74,
-	0x7E, 0xD0, 0x35, 0xEB, 0x50, 0x82, 0xAA, 0x2B
-};
-EXPORT_SYMBOL_GPL(sm3_zero_message_hash);
-
 static int crypto_sm3_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
 	return sm3_base_do_update_blocks(desc, data, len, sm3_block_generic);
 }
diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
index c09f6bf4c0bf..918d318795ef 100644
--- a/include/crypto/sm3.h
+++ b/include/crypto/sm3.h
@@ -14,24 +14,19 @@
 
 #define SM3_DIGEST_SIZE	32
 #define SM3_BLOCK_SIZE	64
 #define SM3_STATE_SIZE	40
 
-#define SM3_T1		0x79CC4519
-#define SM3_T2		0x7A879D8A
-
 #define SM3_IVA		0x7380166f
 #define SM3_IVB		0x4914b2b9
 #define SM3_IVC		0x172442d7
 #define SM3_IVD		0xda8a0600
 #define SM3_IVE		0xa96f30bc
 #define SM3_IVF		0x163138aa
 #define SM3_IVG		0xe38dee4d
 #define SM3_IVH		0xb0fb0e4e
 
-extern const u8 sm3_zero_message_hash[SM3_DIGEST_SIZE];
-
 struct sm3_state {
 	u32 state[SM3_DIGEST_SIZE / 4];
 	u64 count;
 	u8 buffer[SM3_BLOCK_SIZE];
 };
-- 
2.53.0

