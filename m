Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1022A2563
	for <linux-crypto@vger.kernel.org>; Sat, 20 Apr 2024 05:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713592624; cv=none; b=n4j9e/OrzorROYt/LDeagZHLPTc7YmjPXvlre8oIU0TXU+DZuAtoyNRC0fD1HtR/SOpwAjwCDdSX2R3p8xHiMGJLawR9EJnyXFcytkdswNRXxE18X+U3xCv+slyu0PrCcK6A3jRe7wYDjzhD0WuI90YWv3fL38HLMC5nRkviXXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713592624; c=relaxed/simple;
	bh=9snsSe98tLNo23FRNWKWuUXu5OenVZEpV8woPgKEGSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gbybIynZGDya4DhGWgUPN30Lym68u5zSI0O1Ztf7OLqT0MPv0rj5pfWhkRcIGQj60phYrhiQnAF2Jn0Jt6j/A2kDGWOzjMRihqRHk6gbSGW3xWkx1o5MLsrfbYeDpwMTn+P0u+ZMI9G8UvRsRJKHsLmJtDnb54wVqLsy2Wb1TMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPVB1jBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPVB1jBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59862C072AA;
	Sat, 20 Apr 2024 05:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713592623;
	bh=9snsSe98tLNo23FRNWKWuUXu5OenVZEpV8woPgKEGSM=;
	h=From:To:Cc:Subject:Date:From;
	b=mPVB1jBi2VWEPK7Ztgh/NkTG1Fu8HrvppF7hwuIKq2Th/m2+mB18Sqq4S7ysY4Ip3
	 sc1rWic8pJ/+wTBeGxl4pKXCw/OeHduJrOHPQWCWehLE9/2H3jJQPXOz2J9j2GgPrO
	 68MhT+C9EB/w/c87HWsWjr8P50Xcxc0ZK4Ru6mLqpDn81ORlzD9h2JHou7sL8klrTa
	 xfEMDjGVbBPjglOT4TTSQz6FJlfeRvGTM7lGw4MQvZpqMJQgLXIrjI0loZbQy5pqO7
	 rfhsvLV1dEHK9l3wVcz2lUQW+7rWuD2OmXC/Y95NC8GPsxvTE0k0OPxE4WfXs36iEF
	 lyFTzWqpygGbA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] crypto: x86/aes-gcm - delete unused GCM assembly code
Date: Fri, 19 Apr 2024 22:56:42 -0700
Message-ID: <20240420055642.25409-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Delete aesni_gcm_enc() and aesni_gcm_dec() because they are unused.
Only the incremental AES-GCM functions (aesni_gcm_init(),
aesni_gcm_enc_update(), aesni_gcm_finalize()) are actually used.

This saves 17 KB of object code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 186 ------------------------------
 1 file changed, 186 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 3a3e46188dec..39066b57a70e 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -81,13 +81,10 @@ SHIFT_MASK: .octa 0x0f0e0d0c0b0a09080706050403020100
 ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
             .octa 0x00000000000000000000000000000000
 
 .text
 
-
-#define	STACK_OFFSET    8*3
-
 #define AadHash 16*0
 #define AadLen 16*1
 #define InLen (16*1)+8
 #define PBlockEncKey 16*2
 #define OrigIV 16*3
@@ -114,15 +111,10 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 #define arg2 rsi
 #define arg3 rdx
 #define arg4 rcx
 #define arg5 r8
 #define arg6 r9
-#define arg7 STACK_OFFSET+8(%rsp)
-#define arg8 STACK_OFFSET+16(%rsp)
-#define arg9 STACK_OFFSET+24(%rsp)
-#define arg10 STACK_OFFSET+32(%rsp)
-#define arg11 STACK_OFFSET+40(%rsp)
 #define keysize 2*15*16(%arg1)
 #endif
 
 
 #define STATE1	%xmm0
@@ -1505,188 +1497,10 @@ _esb_loop_\@:
 	jnz		_esb_loop_\@
 
 	MOVADQ		(%r10),\TMP1
 	aesenclast	\TMP1,\XMM0
 .endm
-/*****************************************************************************
-* void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
-*                   struct gcm_context_data *data
-*                                      // Context data
-*                   u8 *out,           // Plaintext output. Encrypt in-place is allowed.
-*                   const u8 *in,      // Ciphertext input
-*                   u64 plaintext_len, // Length of data in bytes for decryption.
-*                   u8 *iv,            // Pre-counter block j0: 4 byte salt (from Security Association)
-*                                      // concatenated with 8 byte Initialisation Vector (from IPSec ESP Payload)
-*                                      // concatenated with 0x00000001. 16-byte aligned pointer.
-*                   u8 *hash_subkey,   // H, the Hash sub key input. Data starts on a 16-byte boundary.
-*                   const u8 *aad,     // Additional Authentication Data (AAD)
-*                   u64 aad_len,       // Length of AAD in bytes. With RFC4106 this is going to be 8 or 12 bytes
-*                   u8  *auth_tag,     // Authenticated Tag output. The driver will compare this to the
-*                                      // given authentication tag and only return the plaintext if they match.
-*                   u64 auth_tag_len); // Authenticated Tag Length in bytes. Valid values are 16
-*                                      // (most likely), 12 or 8.
-*
-* Assumptions:
-*
-* keys:
-*       keys are pre-expanded and aligned to 16 bytes. we are using the first
-*       set of 11 keys in the data structure void *aes_ctx
-*
-* iv:
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                             Salt  (From the SA)               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                     Initialization Vector                     |
-*       |         (This is the sequence number from IPSec header)       |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x1                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*
-*
-* AAD:
-*       AAD padded to 128 bits with 0
-*       for example, assume AAD is a u32 vector
-*
-*       if AAD is 8 bytes:
-*       AAD[3] = {A0, A1};
-*       padded AAD in xmm register = {A1 A0 0 0}
-*
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                               SPI (A1)                        |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                     32-bit Sequence Number (A0)               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x0                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*                                       AAD Format with 32-bit Sequence Number
-*
-*       if AAD is 12 bytes:
-*       AAD[3] = {A0, A1, A2};
-*       padded AAD in xmm register = {A2 A1 A0 0}
-*
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                               SPI (A2)                        |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                 64-bit Extended Sequence Number {A1,A0}       |
-*       |                                                               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x0                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*                        AAD Format with 64-bit Extended Sequence Number
-*
-* poly = x^128 + x^127 + x^126 + x^121 + 1
-*
-*****************************************************************************/
-SYM_FUNC_START(aesni_gcm_dec)
-	FUNC_SAVE
-
-	GCM_INIT %arg6, arg7, arg8, arg9
-	GCM_ENC_DEC dec
-	GCM_COMPLETE arg10, arg11
-	FUNC_RESTORE
-	RET
-SYM_FUNC_END(aesni_gcm_dec)
-
-
-/*****************************************************************************
-* void aesni_gcm_enc(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
-*                    struct gcm_context_data *data
-*                                        // Context data
-*                    u8 *out,            // Ciphertext output. Encrypt in-place is allowed.
-*                    const u8 *in,       // Plaintext input
-*                    u64 plaintext_len,  // Length of data in bytes for encryption.
-*                    u8 *iv,             // Pre-counter block j0: 4 byte salt (from Security Association)
-*                                        // concatenated with 8 byte Initialisation Vector (from IPSec ESP Payload)
-*                                        // concatenated with 0x00000001. 16-byte aligned pointer.
-*                    u8 *hash_subkey,    // H, the Hash sub key input. Data starts on a 16-byte boundary.
-*                    const u8 *aad,      // Additional Authentication Data (AAD)
-*                    u64 aad_len,        // Length of AAD in bytes. With RFC4106 this is going to be 8 or 12 bytes
-*                    u8 *auth_tag,       // Authenticated Tag output.
-*                    u64 auth_tag_len);  // Authenticated Tag Length in bytes. Valid values are 16 (most likely),
-*                                        // 12 or 8.
-*
-* Assumptions:
-*
-* keys:
-*       keys are pre-expanded and aligned to 16 bytes. we are using the
-*       first set of 11 keys in the data structure void *aes_ctx
-*
-*
-* iv:
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                             Salt  (From the SA)               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                     Initialization Vector                     |
-*       |         (This is the sequence number from IPSec header)       |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x1                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*
-*
-* AAD:
-*       AAD padded to 128 bits with 0
-*       for example, assume AAD is a u32 vector
-*
-*       if AAD is 8 bytes:
-*       AAD[3] = {A0, A1};
-*       padded AAD in xmm register = {A1 A0 0 0}
-*
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                               SPI (A1)                        |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                     32-bit Sequence Number (A0)               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x0                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*                                 AAD Format with 32-bit Sequence Number
-*
-*       if AAD is 12 bytes:
-*       AAD[3] = {A0, A1, A2};
-*       padded AAD in xmm register = {A2 A1 A0 0}
-*
-*       0                   1                   2                   3
-*       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                               SPI (A2)                        |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                 64-bit Extended Sequence Number {A1,A0}       |
-*       |                                                               |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*       |                              0x0                              |
-*       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-*
-*                         AAD Format with 64-bit Extended Sequence Number
-*
-* poly = x^128 + x^127 + x^126 + x^121 + 1
-***************************************************************************/
-SYM_FUNC_START(aesni_gcm_enc)
-	FUNC_SAVE
-
-	GCM_INIT %arg6, arg7, arg8, arg9
-	GCM_ENC_DEC enc
-
-	GCM_COMPLETE arg10, arg11
-	FUNC_RESTORE
-	RET
-SYM_FUNC_END(aesni_gcm_enc)
 
 /*****************************************************************************
 * void aesni_gcm_init(void *aes_ctx,      // AES Key schedule. Starts on a 16 byte boundary.
 *                     struct gcm_context_data *data,
 *                                         // context data

base-commit: 543ea178fbfadeaf79e15766ac989f3351349f02
-- 
2.44.0

