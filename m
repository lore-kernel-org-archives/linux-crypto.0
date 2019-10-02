Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C42ECE58E
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9564F222CB
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XwzywlC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfJBOSS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:18:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50643 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJBOSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:18:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so7436427wmg.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gFt1eku68f10tBfbHGtW19Txaub7t985t0rIOhlAS/4=;
        b=XwzywlC7M9NjzcSBVmUIKzTrIXlnbNlUN8fF8bFpKuOLmB3f/xWtwStE/QL8RHaEr4
         TLvgtBAYflfGrbpa14XHoRTz3g2COFh/4devkCacsA9HpLuzxImi0x76SDLPIA2NbnCJ
         YAxZRNl6Cb9gcuxWyVOMD8dDFEBJQc70UCw/D8IjLnzgpovPmE91NQmIXGG932wIyloo
         xNBB4MEHJS0wPMDO3AFuvWMkk9fZtKn9qeGA29k4rWhTPEZrBUWlB3E8KhcB4GF2rORk
         CiQ3Z0MRzUCj/qQHVHcXp+26dXT6ggeq9Ia2bMRHlZv0eUwtPlwIECtWFEST8QwU0/Qz
         W54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gFt1eku68f10tBfbHGtW19Txaub7t985t0rIOhlAS/4=;
        b=DKjt7ieryyZ/jpBEHjM5QdPxmBEqFEQGh+rrHb3P+HjrIguZm+XWQblh8y+rId/4aD
         hTotu3Q8arRkrmVu5mG9TQk5yAbQZc3funbCLVnbdVgSn7d6PriC4rYI0tIV70u12pux
         Ix9y9xLII7JHsmXfQdxgQvE0ULN4Bio22/n3g+tMQ1+vCcXzESNZqbZk8ZM4HhbpnzFk
         1mo1cvS/CnxBqTToHC743Y0BcQ+58tTLxxDQ3GNwMDUq4u1FsNUYNBtdz4YU84soBpbT
         7t2tQCin37XNTvRwwFD9adLTHBL/prQ6NCSomZ83S1SsyyLzeDEF6Tx4+DK59LJFxjRe
         OW1Q==
X-Gm-Message-State: APjAAAW4CkNFHZv3XOTOUDHCRHNyPMy2Vpz+gjQbaZ08SZ5DqsxnKzpY
        /INaG5VxdZskwzYnyAEPqMkm8mpf4mguNE+H
X-Google-Smtp-Source: APXvYqzcuojPLGfVcFORnApfQh4uYivD2p2TlG7FaiwW6q27DaCoioAB7REE4KH1xPbDm8ovFXeP4w==
X-Received: by 2002:a1c:9e0b:: with SMTP id h11mr2996769wme.144.1570025895139;
        Wed, 02 Oct 2019 07:18:15 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.18.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:18:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 20/20] crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine
Date:   Wed,  2 Oct 2019 16:17:13 +0200
Message-Id: <20191002141713.31189-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reimplement the library routines to perform chacha20poly1305 en/decryption
on scatterlists, without [ab]using the [deprecated] blkcipher interface,
which is rather heavyweight and does things we don't really need.

Instead, we use the sg_miter API in a novel and clever way, to iterate
over the scatterlist in-place (i.e., source == destination, which is the
only way this library is expected to be used). That way, we don't have to
iterate over two scatterlists in parallel.

Another optimization is that, instead of relying on the blkcipher walker
to present the input in suitable chunks, we recognize that ChaCha is a
streamcipher, and so we can simply deal with partial blocks by keeping a
block of cipherstream on the stack and use crypto_xor() to mix it with
the in/output.

Finally, we omit the scatterwalk_and_copy() call if the last element of
the scatterlist covers the MAC as well (which is the common case),
avoiding the need to walk the scatterlist and kmap() the page twice.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/chacha20poly1305.h      |  11 ++
 lib/crypto/chacha20poly1305-selftest.c |  45 ++++++
 lib/crypto/chacha20poly1305.c          | 150 ++++++++++++++++++++
 3 files changed, 206 insertions(+)

diff --git a/include/crypto/chacha20poly1305.h b/include/crypto/chacha20poly1305.h
index ad3b1de58df8..234ee28078ef 100644
--- a/include/crypto/chacha20poly1305.h
+++ b/include/crypto/chacha20poly1305.h
@@ -7,6 +7,7 @@
 #define __CHACHA20POLY1305_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 enum chacha20poly1305_lengths {
 	XCHACHA20POLY1305_NONCE_SIZE = 24,
@@ -34,4 +35,14 @@ bool __must_check xchacha20poly1305_decrypt(
 	const size_t ad_len, const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
 	const u8 key[CHACHA20POLY1305_KEY_SIZE]);
 
+bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
+					 const u8 *ad, const size_t ad_len,
+					 const u64 nonce,
+					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+
+bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
+					 const u8 *ad, const size_t ad_len,
+					 const u64 nonce,
+					 const u8 key[CHACHA20POLY1305_KEY_SIZE]);
+
 #endif /* __CHACHA20POLY1305_H */
diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
index 618bdd4ab36f..5b496b5c15e3 100644
--- a/lib/crypto/chacha20poly1305-selftest.c
+++ b/lib/crypto/chacha20poly1305-selftest.c
@@ -7251,6 +7251,7 @@ bool __init chacha20poly1305_selftest(void)
 	enum { MAXIMUM_TEST_BUFFER_LEN = 1UL << 12 };
 	size_t i;
 	u8 *computed_output = NULL, *heap_src = NULL;
+	struct scatterlist sg_src;
 	bool success = true, ret;
 
 	heap_src = kmalloc(MAXIMUM_TEST_BUFFER_LEN, GFP_KERNEL);
@@ -7281,6 +7282,29 @@ bool __init chacha20poly1305_selftest(void)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(chacha20poly1305_enc_vectors); ++i) {
+		if (chacha20poly1305_enc_vectors[i].nlen != 8)
+			continue;
+		memcpy(heap_src, chacha20poly1305_enc_vectors[i].input,
+		       chacha20poly1305_enc_vectors[i].ilen);
+		sg_init_one(&sg_src, heap_src,
+			    chacha20poly1305_enc_vectors[i].ilen + POLY1305_DIGEST_SIZE);
+		chacha20poly1305_encrypt_sg_inplace(&sg_src,
+			chacha20poly1305_enc_vectors[i].ilen,
+			chacha20poly1305_enc_vectors[i].assoc,
+			chacha20poly1305_enc_vectors[i].alen,
+			get_unaligned_le64(chacha20poly1305_enc_vectors[i].nonce),
+			chacha20poly1305_enc_vectors[i].key);
+		if (memcmp(heap_src,
+				   chacha20poly1305_enc_vectors[i].output,
+				   chacha20poly1305_enc_vectors[i].ilen +
+							POLY1305_DIGEST_SIZE)) {
+			pr_err("chacha20poly1305 sg encryption self-test %zu: FAIL\n",
+			       i + 1);
+			success = false;
+		}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(chacha20poly1305_dec_vectors); ++i) {
 		memset(computed_output, 0, MAXIMUM_TEST_BUFFER_LEN);
 		ret = chacha20poly1305_decrypt(computed_output,
@@ -7302,6 +7326,27 @@ bool __init chacha20poly1305_selftest(void)
 		}
 	}
 
+	for (i = 0; i < ARRAY_SIZE(chacha20poly1305_dec_vectors); ++i) {
+		memcpy(heap_src, chacha20poly1305_dec_vectors[i].input,
+		       chacha20poly1305_dec_vectors[i].ilen);
+		sg_init_one(&sg_src, heap_src,
+			    chacha20poly1305_dec_vectors[i].ilen);
+		ret = chacha20poly1305_decrypt_sg_inplace(&sg_src,
+			chacha20poly1305_dec_vectors[i].ilen,
+			chacha20poly1305_dec_vectors[i].assoc,
+			chacha20poly1305_dec_vectors[i].alen,
+			get_unaligned_le64(chacha20poly1305_dec_vectors[i].nonce),
+			chacha20poly1305_dec_vectors[i].key);
+		if (!decryption_success(ret,
+			chacha20poly1305_dec_vectors[i].failure,
+			memcmp(heap_src, chacha20poly1305_dec_vectors[i].output,
+			       chacha20poly1305_dec_vectors[i].ilen -
+							POLY1305_DIGEST_SIZE))) {
+			pr_err("chacha20poly1305 sg decryption self-test %zu: FAIL\n",
+			       i + 1);
+			success = false;
+		}
+	}
 
 	for (i = 0; i < ARRAY_SIZE(xchacha20poly1305_enc_vectors); ++i) {
 		memset(computed_output, 0, MAXIMUM_TEST_BUFFER_LEN);
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index a7ec089078f7..01f2c27399c2 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -11,6 +11,7 @@
 #include <crypto/chacha20poly1305.h>
 #include <crypto/chacha.h>
 #include <crypto/poly1305.h>
+#include <crypto/scatterwalk.h>
 
 #include <asm/unaligned.h>
 #include <linux/kernel.h>
@@ -205,6 +206,155 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 }
 EXPORT_SYMBOL(xchacha20poly1305_decrypt);
 
+static
+bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
+				       const size_t src_len,
+				       const u8 *ad, const size_t ad_len,
+				       const u64 nonce,
+				       const u8 key[CHACHA20POLY1305_KEY_SIZE],
+				       int encrypt)
+{
+	const u8 *pad0 = page_address(ZERO_PAGE(0));
+	struct poly1305_desc_ctx poly1305_state;
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	struct sg_mapping_iter miter;
+	size_t partial = 0;
+	unsigned int flags;
+	bool ret = true;
+	int sl;
+	union {
+		struct {
+			u32 k[CHACHA_KEY_WORDS];
+			__le64 iv[2];
+		};
+		u8 block0[POLY1305_KEY_SIZE];
+		u8 chacha_stream[CHACHA_BLOCK_SIZE];
+		struct {
+			u8 mac[2][POLY1305_DIGEST_SIZE];
+		};
+		__le64 lens[2];
+	} b __aligned(16);
+
+	chacha_load_key(b.k, key);
+
+	b.iv[0] = 0;
+	b.iv[1] = cpu_to_le64(nonce);
+
+	chacha_init(chacha_state, b.k, (u8 *)b.iv);
+	chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
+	poly1305_init(&poly1305_state, b.block0);
+
+	if (unlikely(ad_len)) {
+		poly1305_update(&poly1305_state, ad, ad_len);
+		if (ad_len & 0xf)
+			poly1305_update(&poly1305_state, pad0, 0x10 - (ad_len & 0xf));
+	}
+
+	flags = SG_MITER_TO_SG;
+	if (!preemptible())
+		flags |= SG_MITER_ATOMIC;
+
+	sg_miter_start(&miter, src, sg_nents(src), flags);
+
+	for (sl = src_len; sl > 0 && sg_miter_next(&miter); sl -= miter.length) {
+		u8 *addr = miter.addr;
+		size_t length = min_t(size_t, sl, miter.length);
+
+		if (!encrypt)
+			poly1305_update(&poly1305_state, addr, length);
+
+		if (unlikely(partial)) {
+			size_t l = min(length, CHACHA_BLOCK_SIZE - partial);
+
+			crypto_xor(addr, b.chacha_stream + partial, l);
+			partial = (partial + l) & (CHACHA_BLOCK_SIZE - 1);
+
+			addr += l;
+			length -= l;
+		}
+
+		if (likely(length >= CHACHA_BLOCK_SIZE || length == sl)) {
+			size_t l = length;
+
+			if (unlikely(length < sl))
+				l &= ~(CHACHA_BLOCK_SIZE - 1);
+			chacha_crypt(chacha_state, addr, addr, l, 20);
+			addr += l;
+			length -= l;
+		}
+
+		if (unlikely(length > 0)) {
+			chacha_crypt(chacha_state, b.chacha_stream, pad0,
+				     CHACHA_BLOCK_SIZE, 20);
+			crypto_xor(addr, b.chacha_stream, length);
+			partial = length;
+		}
+
+		if (encrypt)
+			poly1305_update(&poly1305_state, miter.addr,
+					min_t(size_t, sl, miter.length));
+	}
+
+	if (src_len & 0xf)
+		poly1305_update(&poly1305_state, pad0, 0x10 - (src_len & 0xf));
+
+	b.lens[0] = cpu_to_le64(ad_len);
+	b.lens[1] = cpu_to_le64(src_len);
+	poly1305_update(&poly1305_state, (u8 *)b.lens, sizeof(b.lens));
+
+	if (likely(sl <= -POLY1305_DIGEST_SIZE)) {
+		if (encrypt) {
+			poly1305_final(&poly1305_state,
+				       miter.addr + miter.length + sl);
+			ret = true;
+		} else {
+			poly1305_final(&poly1305_state, b.mac[0]);
+			ret = !crypto_memneq(b.mac[0],
+					     miter.addr + miter.length + sl,
+					     POLY1305_DIGEST_SIZE);
+		}
+	}
+
+	sg_miter_stop(&miter);
+
+	if (unlikely(sl > -POLY1305_DIGEST_SIZE)) {
+		poly1305_final(&poly1305_state, b.mac[1]);
+		scatterwalk_map_and_copy(b.mac[encrypt], src, src_len,
+					 sizeof(b.mac[1]), encrypt);
+		ret = encrypt ||
+		      !crypto_memneq(b.mac[0], b.mac[1], POLY1305_DIGEST_SIZE);
+	}
+
+	memzero_explicit(chacha_state, sizeof(chacha_state));
+	memzero_explicit(&b, sizeof(b));
+
+	return ret;
+}
+
+bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
+					 const u8 *ad, const size_t ad_len,
+					 const u64 nonce,
+					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+{
+	return chacha20poly1305_crypt_sg_inplace(src, src_len, ad, ad_len,
+						 nonce, key, 1);
+}
+EXPORT_SYMBOL(chacha20poly1305_encrypt_sg_inplace);
+
+bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
+					 const u8 *ad, const size_t ad_len,
+					 const u64 nonce,
+					 const u8 key[CHACHA20POLY1305_KEY_SIZE])
+{
+	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
+		return false;
+
+	return chacha20poly1305_crypt_sg_inplace(src,
+						 src_len - POLY1305_DIGEST_SIZE,
+						 ad, ad_len, nonce, key, 0);
+}
+EXPORT_SYMBOL(chacha20poly1305_decrypt_sg_inplace);
+
 static int __init mod_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
-- 
2.20.1

