Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B0AC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 456A5206C1
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 14:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aTrG2WNj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfHSOPD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:15:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51186 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSOPD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 10:15:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so1781678wml.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 07:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0rdXhafMVjaKUUvPLb/wKqjrVAJEWD02wI54kwgy7/8=;
        b=aTrG2WNj4nhYSYaFtYaZJ5Gsrrt6i2JczZV9rzkdjXnbsRrhP2s+JDcrtiCgg5Wbop
         YYtQpjiwCviXq702LJ79A+n13Ai2eTRWqysoNdl0CCpYA68Hjcsa9kviUPizw6wKy4mG
         rSXbgXK9u+/I4IIEiNw+o1J0Jh0cfSbZ9Gvh8fep9fPnZEenLCdObs9S8/6aCfijv/qF
         91I4rP/NpPlP3wEBJ75eSaIk/6sWf95vKG96WlXKuFmplZn53xVdriOxWGOlgRhX2MwZ
         kl1/u+APeI9GnC2tQuvrcO0hb1N9kazdA81wYVRW3oS7d8vnFRsnGEy0ben8YR+Uw8YV
         BDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0rdXhafMVjaKUUvPLb/wKqjrVAJEWD02wI54kwgy7/8=;
        b=QkOyiq3AVeW+QH0TITouUI2SUAEYWQTF/BYHkehCr/WpnGc9Hs6zoPIcTsAS5SoI/N
         wkCudbdx+AhH8mZS8tDCg02jxmpSItAcksGKUBnhbl6dwWx4fUSOh5yQRxhSafW4e2iv
         2eDIKMp5mOshsPW8q82rqwwL0e/P6g2r9PfmK7nB09Vt7r34o6IkppDtM+WMhMDx9eD/
         2/Fh5Hqduy94xyvciPKGshT3pWojhuz8knUIh1PtpbN6/gmkHC1Xud4GS1TVqYh3MzkX
         hlGleFVU6jQDMT3GGCooEdt5F2J317E7j4Ed+1qttuuBOkM3vNtVQo60NrfHOdAkWm2K
         yz2g==
X-Gm-Message-State: APjAAAVTz5uozqwwplPaGQGjFDkDii1kLCWNVtiYZdCcRuWxWgbFgB9E
        7f3yCn5zC45lu9OXScXuzIkyn3Fz/rkfWQ==
X-Google-Smtp-Source: APXvYqwBEMblDHhPa+BftLCq+ukB32ByuKEAqDjGhBB0hGhYk4Re8l29h4EMINdWWr1O5A5pBIr1rA==
X-Received: by 2002:a05:600c:24d0:: with SMTP id 16mr20217200wmu.83.1566224101068;
        Mon, 19 Aug 2019 07:15:01 -0700 (PDT)
Received: from localhost.localdomain (11.172.185.81.rev.sfr.net. [81.185.172.11])
        by smtp.gmail.com with ESMTPSA id r4sm11604141wrq.82.2019.08.19.07.14.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:15:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, natechancellor@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm64/aegis128 - use explicit vector load for permute vectors
Date:   Mon, 19 Aug 2019 17:15:00 +0300
Message-Id: <20190819141500.1070-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building the new aegis128 NEON code in big endian mode, Clang
complains about the const uint8x16_t permute vectors in the following
way:

  crypto/aegis128-neon-inner.c:58:40: warning: vector initializers are not
      compatible with NEON intrinsics in big endian mode
      [-Wnonportable-vector-initialization]
                static const uint8x16_t shift_rows = {
                                                     ^
  crypto/aegis128-neon-inner.c:58:40: note: consider using vld1q_u8() to
      initialize a vector from memory, or vcombine_u8(vcreate_u8(), vcreate_u8())
      to initialize from integer constants

Since the same issue applies to the uint8x16x4_t loads of the AES Sbox,
update those references as well. However, since GCC does not implement
the vld1q_u8_x4() intrinsic, switch from IS_ENABLED() to a preprocessor
conditional to conditionally include this code.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128-neon-inner.c | 38 ++++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index ed55568afd1b..f05310ca22aa 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -26,7 +26,7 @@ struct aegis128_state {
 	uint8x16_t v[5];
 };
 
-extern const uint8x16x4_t crypto_aes_sbox[];
+extern const uint8_t crypto_aes_sbox[];
 
 static struct aegis128_state aegis128_load_state_neon(const void *state)
 {
@@ -55,39 +55,39 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
 
 #ifdef CONFIG_ARM64
 	if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
-		static const uint8x16_t shift_rows = {
+		static const uint8_t shift_rows[] = {
 			0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
 			0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb,
 		};
-		static const uint8x16_t ror32by8 = {
+		static const uint8_t ror32by8[] = {
 			0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
 			0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,
 		};
 		uint8x16_t v;
 
 		// shift rows
-		w = vqtbl1q_u8(w, shift_rows);
+		w = vqtbl1q_u8(w, vld1q_u8(shift_rows));
 
 		// sub bytes
-		if (!IS_ENABLED(CONFIG_CC_IS_GCC)) {
-			v = vqtbl4q_u8(crypto_aes_sbox[0], w);
-			v = vqtbx4q_u8(v, crypto_aes_sbox[1], w - 0x40);
-			v = vqtbx4q_u8(v, crypto_aes_sbox[2], w - 0x80);
-			v = vqtbx4q_u8(v, crypto_aes_sbox[3], w - 0xc0);
-		} else {
-			asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
-			w -= 0x40;
-			asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
-			w -= 0x40;
-			asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
-			w -= 0x40;
-			asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
-		}
+#ifndef CONFIG_CC_IS_GCC
+		v = vqtbl4q_u8(vld1q_u8_x4(crypto_aes_sbox), w);
+		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x40), w - 0x40);
+		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x80), w - 0x80);
+		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0xc0), w - 0xc0);
+#else
+		asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
+#endif
 
 		// mix columns
 		w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
 		w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
-		w ^= vqtbl1q_u8(v ^ w, ror32by8);
+		w ^= vqtbl1q_u8(v ^ w, vld1q_u8(ror32by8));
 
 		return w;
 	}
-- 
2.17.1

