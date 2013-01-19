From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/12] crypto: aesni-intel - add ENDPROC statements for
 assembler functions
Date: Sat, 19 Jan 2013 13:38:55 +0200
Message-ID: <20130119113855.22319.92670.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36786 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLi6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:38:58 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aesni-intel_asm.S |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 3470624..04b7977 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1262,7 +1262,6 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 *
 *****************************************************************************/
-
 ENTRY(aesni_gcm_dec)
 	push	%r12
 	push	%r13
@@ -1437,6 +1436,7 @@ _return_T_done_decrypt:
 	pop	%r13
 	pop	%r12
 	ret
+ENDPROC(aesni_gcm_dec)
 
 
 /*****************************************************************************
@@ -1700,10 +1700,12 @@ _return_T_done_encrypt:
 	pop	%r13
 	pop	%r12
 	ret
+ENDPROC(aesni_gcm_enc)
 
 #endif
 
 
+.align 4
 _key_expansion_128:
 _key_expansion_256a:
 	pshufd $0b11111111, %xmm1, %xmm1
@@ -1715,6 +1717,8 @@ _key_expansion_256a:
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
 	ret
+ENDPROC(_key_expansion_128)
+ENDPROC(_key_expansion_256a)
 
 .align 4
 _key_expansion_192a:
@@ -1739,6 +1743,7 @@ _key_expansion_192a:
 	movaps %xmm1, 0x10(TKEYP)
 	add $0x20, TKEYP
 	ret
+ENDPROC(_key_expansion_192a)
 
 .align 4
 _key_expansion_192b:
@@ -1758,6 +1763,7 @@ _key_expansion_192b:
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
 	ret
+ENDPROC(_key_expansion_192b)
 
 .align 4
 _key_expansion_256b:
@@ -1770,6 +1776,7 @@ _key_expansion_256b:
 	movaps %xmm2, (TKEYP)
 	add $0x10, TKEYP
 	ret
+ENDPROC(_key_expansion_256b)
 
 /*
  * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
@@ -1882,6 +1889,7 @@ ENTRY(aesni_set_key)
 	popl KEYP
 #endif
 	ret
+ENDPROC(aesni_set_key)
 
 /*
  * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
@@ -1903,6 +1911,7 @@ ENTRY(aesni_enc)
 	popl KEYP
 #endif
 	ret
+ENDPROC(aesni_enc)
 
 /*
  * _aesni_enc1:		internal ABI
@@ -1960,6 +1969,7 @@ _aesni_enc1:
 	movaps 0x70(TKEYP), KEY
 	AESENCLAST KEY STATE
 	ret
+ENDPROC(_aesni_enc1)
 
 /*
  * _aesni_enc4:	internal ABI
@@ -2068,6 +2078,7 @@ _aesni_enc4:
 	AESENCLAST KEY STATE3
 	AESENCLAST KEY STATE4
 	ret
+ENDPROC(_aesni_enc4)
 
 /*
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
@@ -2090,6 +2101,7 @@ ENTRY(aesni_dec)
 	popl KEYP
 #endif
 	ret
+ENDPROC(aesni_dec)
 
 /*
  * _aesni_dec1:		internal ABI
@@ -2147,6 +2159,7 @@ _aesni_dec1:
 	movaps 0x70(TKEYP), KEY
 	AESDECLAST KEY STATE
 	ret
+ENDPROC(_aesni_dec1)
 
 /*
  * _aesni_dec4:	internal ABI
@@ -2255,6 +2268,7 @@ _aesni_dec4:
 	AESDECLAST KEY STATE3
 	AESDECLAST KEY STATE4
 	ret
+ENDPROC(_aesni_dec4)
 
 /*
  * void aesni_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2312,6 +2326,7 @@ ENTRY(aesni_ecb_enc)
 	popl LEN
 #endif
 	ret
+ENDPROC(aesni_ecb_enc)
 
 /*
  * void aesni_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2370,6 +2385,7 @@ ENTRY(aesni_ecb_dec)
 	popl LEN
 #endif
 	ret
+ENDPROC(aesni_ecb_dec)
 
 /*
  * void aesni_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2411,6 +2427,7 @@ ENTRY(aesni_cbc_enc)
 	popl IVP
 #endif
 	ret
+ENDPROC(aesni_cbc_enc)
 
 /*
  * void aesni_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2501,6 +2518,7 @@ ENTRY(aesni_cbc_dec)
 	popl IVP
 #endif
 	ret
+ENDPROC(aesni_cbc_dec)
 
 #ifdef __x86_64__
 .align 16
@@ -2527,6 +2545,7 @@ _aesni_inc_init:
 	MOVQ_R64_XMM TCTR_LOW INC
 	MOVQ_R64_XMM CTR TCTR_LOW
 	ret
+ENDPROC(_aesni_inc_init)
 
 /*
  * _aesni_inc:		internal ABI
@@ -2555,6 +2574,7 @@ _aesni_inc:
 	movaps CTR, IV
 	PSHUFB_XMM BSWAP_MASK IV
 	ret
+ENDPROC(_aesni_inc)
 
 /*
  * void aesni_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
@@ -2615,4 +2635,5 @@ ENTRY(aesni_ctr_enc)
 	movups IV, (IVP)
 .Lctr_enc_just_ret:
 	ret
+ENDPROC(aesni_ctr_enc)
 #endif
