Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2C7FA3738
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B579621925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FksfOC6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503403AbfJQTKf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42961 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503397AbfJQTKc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:32 -0400
Received: by mail-wr1-f68.google.com with SMTP id n14so3580845wrw.9
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2uxMy1p3EwPMbuhcEJ3kB3BjYDhkPiDM1ZU0+/Hzyk=;
        b=FksfOC6lQMCo88HqRGjHEnIg8Nm07GSUsdvR0TeIjLgGZjvs5nhPeFGgkTKilIawA3
         4i86Gm2CgWiV7a9VJq3q37lBR/UT9RnDARbAjo08nBec8EdDfqFD/qHvmYl/1eAY2SrU
         ovuLwWQEmZkt8dhEH6AEIKw+n7REuVZ8JTcz4fpDtyrOSUwMS/usxv6b7LS9xzyirFdp
         mWlpWb57x0OmeY4DxR/59EF9d0unwr9c8gcH7g3ZL+J5WHOdmXgGMB3IFtx7I1ayJip2
         A1UmoCtzqjoOxa90xjOUqp1gVijaa5FZXaani8VZXnlhnl/9MW0XUELYStGeHERAymkt
         CFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2uxMy1p3EwPMbuhcEJ3kB3BjYDhkPiDM1ZU0+/Hzyk=;
        b=UGwsnRrLlaNuGCum8kJEaZ1zBLz/Fo+N7JAkfT7+vxc12fPgHdL1blyikuRzNj5IJL
         hbDckgvsIIMx9fjg0JhbbvPqCOCqv/l3qLAsdBRAzvI8pJ8CDptznOYXHtytUFiLyvf7
         /GMm7ACZAXeSZtirgU41bi+isfyA7DzRUeisMU4Rgj2bVsfUmwtWMl8q7AC7Nuti94R7
         YbUJ7ZU3GqVpTq+EcbrImGDNOU44OQMcuZCoP/ubppiASvtm2XJEgl8fyKVS4BhPZ9Ns
         qMPRBLULio/Iq+pfbluUNByOeXYDwtES6dCg7dmDu06KvTzQTfyXFR7q+6ckad7mzF2K
         l9EQ==
X-Gm-Message-State: APjAAAVEXE6aPujgbzZKixAROQ3DsgfINVw6jFbf/8FKb48QXqKqm6aG
        bj1mVNS7O7zk/m6VHYGTiHKk85Cen8xKUp20
X-Google-Smtp-Source: APXvYqzo+8yjFBsW+RRuHNJbNtK/B2JouYlGH/TiooAxYAhm1BmTM3rdbPU0VQV1GBnoLQ0gHSrXvA==
X-Received: by 2002:a5d:5011:: with SMTP id e17mr4389722wrt.160.1571339430021;
        Thu, 17 Oct 2019 12:10:30 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:29 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 23/35] crypto: testmgr - add test cases for Blake2s
Date:   Thu, 17 Oct 2019 21:09:20 +0200
Message-Id: <20191017190932.1947-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As suggested by Eric for the Blake2b implementation contributed by
David, introduce a set of test vectors for Blake2s covering different
digest and key sizes.

          blake2s-128  blake2s-160  blake2s-224  blake2s-256
         ---------------------------------------------------
len=0   | klen=0       klen=1       klen=16      klen=32
len=1   | klen=16      klen=32      klen=0       klen=1
len=7   | klen=32      klen=0       klen=1       klen=16
len=15  | klen=1       klen=16      klen=32      klen=0
len=64  | klen=0       klen=1       klen=16      klen=32
len=247 | klen=16      klen=32      klen=0       klen=1
len=256 | klen=32      klen=0       klen=1       klen=16

Cc: David Sterba <dsterba@suse.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c |  24 ++
 crypto/testmgr.h | 251 ++++++++++++++++++++
 2 files changed, 275 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82084f6d84b6..767fc5444771 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4022,6 +4022,30 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
 		.test = alg_test_null,
 		.fips_allowed = 1,
+	}, {
+		.alg = "blake2s-128",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(blakes2s_128_tv_template)
+		}
+	}, {
+		.alg = "blake2s-160",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(blakes2s_160_tv_template)
+		}
+	}, {
+		.alg = "blake2s-224",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(blakes2s_224_tv_template)
+		}
+	}, {
+		.alg = "blake2s-256",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(blakes2s_256_tv_template)
+		}
 	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d1d89101f1b5..b717afc0926e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -31942,4 +31942,255 @@ static const struct aead_testvec essiv_hmac_sha256_aes_cbc_tv_temp[] = {
 	},
 };
 
+static const char blake2s_ordered_sequence[] =
+	"\x00\x01\x02\x03\x04\x05\x06\x07"
+	"\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+	"\x10\x11\x12\x13\x14\x15\x16\x17"
+	"\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
+	"\x20\x21\x22\x23\x24\x25\x26\x27"
+	"\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+	"\x30\x31\x32\x33\x34\x35\x36\x37"
+	"\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f"
+	"\x40\x41\x42\x43\x44\x45\x46\x47"
+	"\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f"
+	"\x50\x51\x52\x53\x54\x55\x56\x57"
+	"\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f"
+	"\x60\x61\x62\x63\x64\x65\x66\x67"
+	"\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f"
+	"\x70\x71\x72\x73\x74\x75\x76\x77"
+	"\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f"
+	"\x80\x81\x82\x83\x84\x85\x86\x87"
+	"\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
+	"\x90\x91\x92\x93\x94\x95\x96\x97"
+	"\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f"
+	"\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7"
+	"\xa8\xa9\xaa\xab\xac\xad\xae\xaf"
+	"\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7"
+	"\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf"
+	"\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+	"\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf"
+	"\xd0\xd1\xd2\xd3\xd4\xd5\xd6\xd7"
+	"\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf"
+	"\xe0\xe1\xe2\xe3\xe4\xe5\xe6\xe7"
+	"\xe8\xe9\xea\xeb\xec\xed\xee\xef"
+	"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+	"\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff";
+
+static const struct hash_testvec blakes2s_128_tv_template[] = {{
+	.digest = (u8[]){ 0x64, 0x55, 0x0d, 0x6f, 0xfe, 0x2c, 0x0a, 0x01,
+			  0xa1, 0x4a, 0xba, 0x1e, 0xad, 0xe0, 0x20, 0x0c, },
+}, {
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 64,
+	.digest = (u8[]){ 0xdc, 0x66, 0xca, 0x8f, 0x03, 0x86, 0x58, 0x01,
+			  0xb0, 0xff, 0xe0, 0x6e, 0xd8, 0xa1, 0xa9, 0x0e, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 1,
+	.digest = (u8[]){ 0x88, 0x1e, 0x42, 0xe7, 0xbb, 0x35, 0x80, 0x82,
+			  0x63, 0x7c, 0x0a, 0x0f, 0xd7, 0xec, 0x6c, 0x2f, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 7,
+	.digest = (u8[]){ 0xcf, 0x9e, 0x07, 0x2a, 0xd5, 0x22, 0xf2, 0xcd,
+			  0xa2, 0xd8, 0x25, 0x21, 0x80, 0x86, 0x73, 0x1c, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 15,
+	.digest = (u8[]){ 0xf6, 0x33, 0x5a, 0x2c, 0x22, 0xa0, 0x64, 0xb2,
+			  0xb6, 0x3f, 0xeb, 0xbc, 0xd1, 0xc3, 0xe5, 0xb2, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 247,
+	.digest = (u8[]){ 0x72, 0x66, 0x49, 0x60, 0xf9, 0x4a, 0xea, 0xbe,
+			  0x1f, 0xf4, 0x60, 0xce, 0xb7, 0x81, 0xcb, 0x09, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 256,
+	.digest = (u8[]){ 0xd5, 0xa4, 0x0e, 0xc3, 0x16, 0xc7, 0x51, 0xa6,
+			  0x3c, 0xd0, 0xd9, 0x11, 0x57, 0xfa, 0x1e, 0xbb, },
+}};
+
+static const struct hash_testvec blakes2s_160_tv_template[] = {{
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 7,
+	.digest = (u8[]){ 0xb4, 0xf2, 0x03, 0x49, 0x37, 0xed, 0xb1, 0x3e,
+			  0x5b, 0x2a, 0xca, 0x64, 0x82, 0x74, 0xf6, 0x62,
+			  0xe3, 0xf2, 0x84, 0xff, },
+}, {
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 256,
+	.digest = (u8[]){ 0xaa, 0x56, 0x9b, 0xdc, 0x98, 0x17, 0x75, 0xf2,
+			  0xb3, 0x68, 0x83, 0xb7, 0x9b, 0x8d, 0x48, 0xb1,
+			  0x9b, 0x2d, 0x35, 0x05, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.digest = (u8[]){ 0x50, 0x16, 0xe7, 0x0c, 0x01, 0xd0, 0xd3, 0xc3,
+			  0xf4, 0x3e, 0xb1, 0x6e, 0x97, 0xa9, 0x4e, 0xd1,
+			  0x79, 0x65, 0x32, 0x93, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 1,
+	.digest = (u8[]){ 0x1c, 0x2b, 0xcd, 0x9a, 0x68, 0xca, 0x8c, 0x71,
+			  0x90, 0x29, 0x6c, 0x54, 0xfa, 0x56, 0x4a, 0xef,
+			  0xa2, 0x3a, 0x56, 0x9c, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 15,
+	.digest = (u8[]){ 0x36, 0xc3, 0x5f, 0x9a, 0xdc, 0x7e, 0xbf, 0x19,
+			  0x68, 0xaa, 0xca, 0xd8, 0x81, 0xbf, 0x09, 0x34,
+			  0x83, 0x39, 0x0f, 0x30, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 64,
+	.digest = (u8[]){ 0x86, 0x80, 0x78, 0xa4, 0x14, 0xec, 0x03, 0xe5,
+			  0xb6, 0x9a, 0x52, 0x0e, 0x42, 0xee, 0x39, 0x9d,
+			  0xac, 0xa6, 0x81, 0x63, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 247,
+	.digest = (u8[]){ 0x2d, 0xd8, 0xd2, 0x53, 0x66, 0xfa, 0xa9, 0x01,
+			  0x1c, 0x9c, 0xaf, 0xa3, 0xe2, 0x9d, 0x9b, 0x10,
+			  0x0a, 0xf6, 0x73, 0xe8, },
+}};
+
+static const struct hash_testvec blakes2s_224_tv_template[] = {{
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 1,
+	.digest = (u8[]){ 0x61, 0xb9, 0x4e, 0xc9, 0x46, 0x22, 0xa3, 0x91,
+			  0xd2, 0xae, 0x42, 0xe6, 0x45, 0x6c, 0x90, 0x12,
+			  0xd5, 0x80, 0x07, 0x97, 0xb8, 0x86, 0x5a, 0xfc,
+			  0x48, 0x21, 0x97, 0xbb, },
+}, {
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 247,
+	.digest = (u8[]){ 0x9e, 0xda, 0xc7, 0x20, 0x2c, 0xd8, 0x48, 0x2e,
+			  0x31, 0x94, 0xab, 0x46, 0x6d, 0x94, 0xd8, 0xb4,
+			  0x69, 0xcd, 0xae, 0x19, 0x6d, 0x9e, 0x41, 0xcc,
+			  0x2b, 0xa4, 0xd5, 0xf6, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.digest = (u8[]){ 0x32, 0xc0, 0xac, 0xf4, 0x3b, 0xd3, 0x07, 0x9f,
+			  0xbe, 0xfb, 0xfa, 0x4d, 0x6b, 0x4e, 0x56, 0xb3,
+			  0xaa, 0xd3, 0x27, 0xf6, 0x14, 0xbf, 0xb9, 0x32,
+			  0xa7, 0x19, 0xfc, 0xb8, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 7,
+	.digest = (u8[]){ 0x73, 0xad, 0x5e, 0x6d, 0xb9, 0x02, 0x8e, 0x76,
+			  0xf2, 0x66, 0x42, 0x4b, 0x4c, 0xfa, 0x1f, 0xe6,
+			  0x2e, 0x56, 0x40, 0xe5, 0xa2, 0xb0, 0x3c, 0xe8,
+			  0x7b, 0x45, 0xfe, 0x05, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 15,
+	.digest = (u8[]){ 0x16, 0x60, 0xfb, 0x92, 0x54, 0xb3, 0x6e, 0x36,
+			  0x81, 0xf4, 0x16, 0x41, 0xc3, 0x3d, 0xd3, 0x43,
+			  0x84, 0xed, 0x10, 0x6f, 0x65, 0x80, 0x7a, 0x3e,
+			  0x25, 0xab, 0xc5, 0x02, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 64,
+	.digest = (u8[]){ 0xca, 0xaa, 0x39, 0x67, 0x9c, 0xf7, 0x6b, 0xc7,
+			  0xb6, 0x82, 0xca, 0x0e, 0x65, 0x36, 0x5b, 0x7c,
+			  0x24, 0x00, 0xfa, 0x5f, 0xda, 0x06, 0x91, 0x93,
+			  0x6a, 0x31, 0x83, 0xb5, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 256,
+	.digest = (u8[]){ 0x90, 0x02, 0x26, 0xb5, 0x06, 0x9c, 0x36, 0x86,
+			  0x94, 0x91, 0x90, 0x1e, 0x7d, 0x2a, 0x71, 0xb2,
+			  0x48, 0xb5, 0xe8, 0x16, 0xfd, 0x64, 0x33, 0x45,
+			  0xb3, 0xd7, 0xec, 0xcc, },
+}};
+
+static const struct hash_testvec blakes2s_256_tv_template[] = {{
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 15,
+	.digest = (u8[]){ 0xd9, 0x7c, 0x82, 0x8d, 0x81, 0x82, 0xa7, 0x21,
+			  0x80, 0xa0, 0x6a, 0x78, 0x26, 0x83, 0x30, 0x67,
+			  0x3f, 0x7c, 0x4e, 0x06, 0x35, 0x94, 0x7c, 0x04,
+			  0xc0, 0x23, 0x23, 0xfd, 0x45, 0xc0, 0xa5, 0x2d, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.digest = (u8[]){ 0x48, 0xa8, 0x99, 0x7d, 0xa4, 0x07, 0x87, 0x6b,
+			  0x3d, 0x79, 0xc0, 0xd9, 0x23, 0x25, 0xad, 0x3b,
+			  0x89, 0xcb, 0xb7, 0x54, 0xd8, 0x6a, 0xb7, 0x1a,
+			  0xee, 0x04, 0x7a, 0xd3, 0x45, 0xfd, 0x2c, 0x49, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 1,
+	.digest = (u8[]){ 0x22, 0x27, 0xae, 0xaa, 0x6e, 0x81, 0x56, 0x03,
+			  0xa7, 0xe3, 0xa1, 0x18, 0xa5, 0x9a, 0x2c, 0x18,
+			  0xf4, 0x63, 0xbc, 0x16, 0x70, 0xf1, 0xe7, 0x4b,
+			  0x00, 0x6d, 0x66, 0x16, 0xae, 0x9e, 0x74, 0x4e, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 7,
+	.digest = (u8[]){ 0x58, 0x5d, 0xa8, 0x60, 0x1c, 0xa4, 0xd8, 0x03,
+			  0x86, 0x86, 0x84, 0x64, 0xd7, 0xa0, 0x8e, 0x15,
+			  0x2f, 0x05, 0xa2, 0x1b, 0xbc, 0xef, 0x7a, 0x34,
+			  0xb3, 0xc5, 0xbc, 0x4b, 0xf0, 0x32, 0xeb, 0x12, },
+}, {
+	.ksize = 32,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 64,
+	.digest = (u8[]){ 0x89, 0x75, 0xb0, 0x57, 0x7f, 0xd3, 0x55, 0x66,
+			  0xd7, 0x50, 0xb3, 0x62, 0xb0, 0x89, 0x7a, 0x26,
+			  0xc3, 0x99, 0x13, 0x6d, 0xf0, 0x7b, 0xab, 0xab,
+			  0xbd, 0xe6, 0x20, 0x3f, 0xf2, 0x95, 0x4e, 0xd4, },
+}, {
+	.ksize = 1,
+	.key = "B",
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 247,
+	.digest = (u8[]){ 0x2e, 0x74, 0x1c, 0x1d, 0x03, 0xf4, 0x9d, 0x84,
+			  0x6f, 0xfc, 0x86, 0x32, 0x92, 0x49, 0x7e, 0x66,
+			  0xd7, 0xc3, 0x10, 0x88, 0xfe, 0x28, 0xb3, 0xe0,
+			  0xbf, 0x50, 0x75, 0xad, 0x8e, 0xa4, 0xe6, 0xb2, },
+}, {
+	.ksize = 16,
+	.key = blake2s_ordered_sequence,
+	.plaintext = blake2s_ordered_sequence,
+	.psize = 256,
+	.digest = (u8[]){ 0xb9, 0xd2, 0x81, 0x0e, 0x3a, 0xb1, 0x62, 0x9b,
+			  0xad, 0x44, 0x05, 0xf4, 0x92, 0x2e, 0x99, 0xc1,
+			  0x4a, 0x47, 0xbb, 0x5b, 0x6f, 0xb2, 0x96, 0xed,
+			  0xd5, 0x06, 0xb5, 0x3a, 0x7c, 0x7a, 0x65, 0x1d, },
+}};
+
 #endif	/* _CRYPTO_TESTMGR_H */
-- 
2.20.1

