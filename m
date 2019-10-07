Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F5CECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC2D22070B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XyLNL356"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfJGQrE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:47:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39272 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbfJGQrD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:47:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id v17so193004wml.4
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptVEPi1+21330fzygKJEswMpXlPGXyeoY6xDdlb4XMc=;
        b=XyLNL356sjjC/E4wffWFBEyNv3Aqsc/DBjj4ExuG8iMlBsumSZbD32cVyr/XjnBeb2
         omQEAWuqLYE4fJ/5xlXQV9ZC566CMXJ/h+fD0dkSCK5jzHIFevBNi+CYKw7RDMF7qj+3
         TVVCJ67xK3XN2aXsOM+GH1YwDTb9tkKDNKrByxOm+oFj2aBaZHqcc/rnZJ4HWjo9wbXV
         z5Jch6iZfUE1BZcl50UGtHzvlFU2oYJ88Ha/SxzyvtxPRjk6c0zsIJIfwxV85N/LfF/O
         rpEgJJXRx5WzA+8GKOZwfTT+E2CyRG5gPMWlW1F8xda0xwQtJM8zJ+FXqXrRkGk2MGIc
         d54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptVEPi1+21330fzygKJEswMpXlPGXyeoY6xDdlb4XMc=;
        b=p/AJaj1mZomCDA5JOYWvWYrI4nrCHgYpIaCVY6WXDALDc3tlm/L/oZcwKNo77Xa+3f
         qYAQXV3Z1Iv0DYD5waBBQufNEhtjegqa21Dj3ASGPP8Zh+S+7h367Gq5oA7WeCsnl3ak
         gfIK9zbj3pDJuAsbNjKuqyNvEjgz33QBbfeiTuLHrBa0djqUd1HwFQXbclmymnd5Bljd
         T31Ly9k7Ouhr67itqgI63zzlcGher7vc3tHgvCwvJWKxLPc/cFf9AD+v4knygiFMJxQf
         xHrwNXRw9pZMIYdiHsIvAbyJ8Eg5Y0N5d1Dv2bo+UAF7Xcl1Qac7TKTVtBKrQJR3dAPu
         tWeQ==
X-Gm-Message-State: APjAAAUE2d8WyITnw+hHGyWKPGXGc8wpA4Qed8hy+YEh5v/9DM8GFP7g
        59w85Zro6FCS1m871tLhd6ql0QXak4Q/Rw==
X-Google-Smtp-Source: APXvYqytosUfs8HyDwuqNFzyOC+AM2Q5CG86bqS7JETJ9I38hrY3SqXVQs5xk6NJlqzO8wBkt++kRw==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr145745wma.153.1570466820454;
        Mon, 07 Oct 2019 09:47:00 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 29/29] crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine
Date:   Mon,  7 Oct 2019 18:46:10 +0200
Message-Id: <20191007164610.6881-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
index d1ed0f27cfdb..465de46dbdef 100644
--- a/lib/crypto/chacha20poly1305-selftest.c
+++ b/lib/crypto/chacha20poly1305-selftest.c
@@ -7250,6 +7250,7 @@ bool __init chacha20poly1305_selftest(void)
 	enum { MAXIMUM_TEST_BUFFER_LEN = 1UL << 12 };
 	size_t i;
 	u8 *computed_output = NULL, *heap_src = NULL;
+	struct scatterlist sg_src;
 	bool success = true, ret;
 
 	heap_src = kmalloc(MAXIMUM_TEST_BUFFER_LEN, GFP_KERNEL);
@@ -7280,6 +7281,29 @@ bool __init chacha20poly1305_selftest(void)
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
@@ -7301,6 +7325,27 @@ bool __init chacha20poly1305_selftest(void)
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
index bf9e993ba388..9d7a753689ab 100644
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
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
-- 
2.20.1

