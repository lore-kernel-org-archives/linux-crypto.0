Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46034C636C8
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8B8613CC
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhGOVe4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhGOVez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 17:34:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D00C061762
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:32:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so9636417ybp.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5urZ7uwRiJrdSuhvvX8AJs8DjwaDfT7akhflEi1KbAc=;
        b=u6it6dMIdA6SnneFKTcRseATyEmkQe/tTIt6F4GQk6h0ut12t2xszYu/nbyAZIbWo6
         aXK+uRhXHgIe3f4Yoq/mOO/yf50PyuLHyBD9QfSl3zyXE9FBVPmakSftvzpYJp5zU7M2
         4Bk2Fl2rOJ59Rt7WPuPq9MGnBvQZkdzWMZ30Gnz9o7ZxpJRXtlFTg50IqD2Qba9ip3L9
         j3BEB7qiCMehYINm8gUKKsHGA/Trfy2JgbzJ2aTgLZWFwNwa1/D4djahTKSruvaNh2Pj
         JVAOKasc3ow7NpZCpxeN1H24Kw/UzfdI+g/cFNt/noKCw0HZYAvyu530F5eQ6YTOh7hc
         uyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5urZ7uwRiJrdSuhvvX8AJs8DjwaDfT7akhflEi1KbAc=;
        b=p/Dc5qBOl8r7IcRMGsqQQl3iJMVxrKYUnUyFI3giiP0slDIjL4ujcRanSVvRcfh32r
         rwtqg3MAA3DGuNr6FG7qA2yLtQIi+IxqG/rS3mURF2pDxkUlXPKyD3wkkoXSwvLRdk8H
         oWgkeLeQ14NGUYE4Nmfy1qxmpJMFZqavOviujOpUjkVRNkwY5kHQ8WEy4APr/a6Wp39I
         U5zEDgA5ff6jBNm3vxl9ywH/rIi4FyyZ8IepkGqtc4JfANCSSmZ1HX5d1wUbwXQLselu
         F9AG3oNeydLNgkstjpFXQEM/LLz9D039Cc7Ssn6phmyodNCj1awvUNxYgalwR1vUAKrO
         r6bw==
X-Gm-Message-State: AOAM530RcB3vLYrPL+RVG4DURFV/+jnJjmZJFYYeCg7b5Ml5xfpr+cT4
        VfvM7dDS21pTIx1sGufrxQ6IxSAhnxBX9A==
X-Google-Smtp-Source: ABdhPJztbNmw+1ZvGsLKuNYxfpzPt2RZ9rNX8xKSALx3jXzgoRd4Vs72OS8l1jyDtj6KNRXymKtozT0Ohgwy+Q==
X-Received: from dlatypov.svl.corp.google.com ([2620:15c:2cd:202:24a2:4c13:4cc0:8818])
 (user=dlatypov job=sendgmr) by 2002:a25:cc50:: with SMTP id
 l77mr8712114ybf.83.1626384720258; Thu, 15 Jul 2021 14:32:00 -0700 (PDT)
Date:   Thu, 15 Jul 2021 14:31:37 -0700
In-Reply-To: <20210715213138.1363079-1-dlatypov@google.com>
Message-Id: <20210715213138.1363079-2-dlatypov@google.com>
Mime-Version: 1.0
References: <20210715213138.1363079-1-dlatypov@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [RFC v1 1/2] crypto: tcrypt: minimal conversion to run under KUnit
From:   Daniel Latypov <dlatypov@google.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com,
        Daniel Latypov <dlatypov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tcrypt.c calls itself a "[q]uick & dirty crypto testing module."
One that "will only exist until we have a better testing mechanism."

This is a fairly minimal change to get the test running under KUnit,
which is hopefully a "better testing mechanism" than a plain test
module.

THe main benefit is that it provides a more standardized way to run the
test, and one that is hopefully faster and easier, see below.

The test can still be run as a test module, but
* now it prints KTAP output (like kselftest) as a structured means of
reporting pass/fail
* has a dependency on CONFIG_KUNIT
* sadly does not allow controlling the return code from mod_init, it'll
always be 0

If we continue down this path and start splitting up the test cases,
there's a few benefits KUnit can provide:
* When running with CONFIG_KASAN=y, it can mark the current test case as
FAILED with a diagnostic error message
  * UBSAN support is just waiting to be picked up, might get more

* We can try and refactor tests to use KUnit utilities for managed
allocations/deallocations
  * some local hacking suggests this can cut down 100s of lines
  * avoids having to set up chains of labels w/ gotos

* KUnit supports running subsets of tests by suite name
  * this could be extended to filtering by test name
  * would no longer need a large switch statement to do this

== Running the test ==
We can run it like so (uses ARCH=um)
$ ./tools/testing/kunit/kunit.py run --kunitconfig /dev/stdin <<EOF
  CONFIG_KUNIT=y
  CONFIG_CRYPTO=y
  CONFIG_CRYPTO_MANAGER=y
  CONFIG_CRYPTO_TEST=y
EOF

Or instead, thanks to the crypto/.kunitconfig file this patch adds:
$ ./tools/testing/kunit/kunit.py run --kunitconfig=crypto

From a fresh tree, this builds in runs in ~1 minute, and after an
incremental rebuild, it takes only seconds.

We can add on `--arch=x86_64` to instead run it in a QEMU VM, which only
takes a bit longer.

== Questions ==
* does this seem like it would make running the test easier?
* does `tvmem` actually need page-aligned buffers?
* I have no clue how FIPS intersects with all of this.
  * would it be fine to leave the test code built-in for FIPS instead of
  returning -EAGAIN?

Signed-off-by: Daniel Latypov <dlatypov@google.com>
---
 crypto/Kconfig  |   5 +-
 crypto/tcrypt.c | 301 +++++++++++++++++++++++-------------------------
 2 files changed, 143 insertions(+), 163 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ca3b02dcbbfa..73bb14f3c0b6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -200,9 +200,8 @@ config CRYPTO_AUTHENC
 	  This is required for IPSec.
 
 config CRYPTO_TEST
-	tristate "Testing module"
-	depends on m || EXPERT
-	select CRYPTO_MANAGER
+	tristate "Testing module" if !KUNIT_ALL_TESTS
+	depends on CRYPTO_MANAGER && KUNIT
 	help
 	  Quick & dirty crypto test module.
 
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f8d06da78e4f..319fe71a69b5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -22,6 +22,7 @@
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <kunit/test.h>
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/init.h>
@@ -1652,7 +1653,7 @@ static void test_available(void)
 	}
 }
 
-static inline int tcrypt_test(const char *alg)
+static inline void tcrypt_test(struct kunit *test, const char *alg)
 {
 	int ret;
 
@@ -1662,376 +1663,376 @@ static inline int tcrypt_test(const char *alg)
 	/* non-fips algs return -EINVAL in fips mode */
 	if (fips_enabled && ret == -EINVAL)
 		ret = 0;
-	return ret;
+	KUNIT_EXPECT_EQ_MSG(test, ret, 0, "alg_test(%s) failed", alg);
 }
 
-static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
+static void do_test(struct kunit *test, const char *alg, u32 type, u32 mask,
+		    int m, u32 num_mb)
 {
 	int i;
-	int ret = 0;
 
 	switch (m) {
 	case 0:
 		if (alg) {
 			if (!crypto_has_alg(alg, type,
 					    mask ?: CRYPTO_ALG_TYPE_MASK))
-				ret = -ENOENT;
+				KUNIT_FAIL(test, "don't have alg '%s'", alg);
 			break;
 		}
 
 		for (i = 1; i < 200; i++)
-			ret += do_test(NULL, 0, 0, i, num_mb);
+			do_test(test, NULL, 0, 0, i, num_mb);
 		break;
 
 	case 1:
-		ret += tcrypt_test("md5");
+		tcrypt_test(test, "md5");
 		break;
 
 	case 2:
-		ret += tcrypt_test("sha1");
+		tcrypt_test(test, "sha1");
 		break;
 
 	case 3:
-		ret += tcrypt_test("ecb(des)");
-		ret += tcrypt_test("cbc(des)");
-		ret += tcrypt_test("ctr(des)");
+		tcrypt_test(test, "ecb(des)");
+		tcrypt_test(test, "cbc(des)");
+		tcrypt_test(test, "ctr(des)");
 		break;
 
 	case 4:
-		ret += tcrypt_test("ecb(des3_ede)");
-		ret += tcrypt_test("cbc(des3_ede)");
-		ret += tcrypt_test("ctr(des3_ede)");
+		tcrypt_test(test, "ecb(des3_ede)");
+		tcrypt_test(test, "cbc(des3_ede)");
+		tcrypt_test(test, "ctr(des3_ede)");
 		break;
 
 	case 5:
-		ret += tcrypt_test("md4");
+		tcrypt_test(test, "md4");
 		break;
 
 	case 6:
-		ret += tcrypt_test("sha256");
+		tcrypt_test(test, "sha256");
 		break;
 
 	case 7:
-		ret += tcrypt_test("ecb(blowfish)");
-		ret += tcrypt_test("cbc(blowfish)");
-		ret += tcrypt_test("ctr(blowfish)");
+		tcrypt_test(test, "ecb(blowfish)");
+		tcrypt_test(test, "cbc(blowfish)");
+		tcrypt_test(test, "ctr(blowfish)");
 		break;
 
 	case 8:
-		ret += tcrypt_test("ecb(twofish)");
-		ret += tcrypt_test("cbc(twofish)");
-		ret += tcrypt_test("ctr(twofish)");
-		ret += tcrypt_test("lrw(twofish)");
-		ret += tcrypt_test("xts(twofish)");
+		tcrypt_test(test, "ecb(twofish)");
+		tcrypt_test(test, "cbc(twofish)");
+		tcrypt_test(test, "ctr(twofish)");
+		tcrypt_test(test, "lrw(twofish)");
+		tcrypt_test(test, "xts(twofish)");
 		break;
 
 	case 9:
-		ret += tcrypt_test("ecb(serpent)");
-		ret += tcrypt_test("cbc(serpent)");
-		ret += tcrypt_test("ctr(serpent)");
-		ret += tcrypt_test("lrw(serpent)");
-		ret += tcrypt_test("xts(serpent)");
+		tcrypt_test(test, "ecb(serpent)");
+		tcrypt_test(test, "cbc(serpent)");
+		tcrypt_test(test, "ctr(serpent)");
+		tcrypt_test(test, "lrw(serpent)");
+		tcrypt_test(test, "xts(serpent)");
 		break;
 
 	case 10:
-		ret += tcrypt_test("ecb(aes)");
-		ret += tcrypt_test("cbc(aes)");
-		ret += tcrypt_test("lrw(aes)");
-		ret += tcrypt_test("xts(aes)");
-		ret += tcrypt_test("ctr(aes)");
-		ret += tcrypt_test("rfc3686(ctr(aes))");
-		ret += tcrypt_test("ofb(aes)");
-		ret += tcrypt_test("cfb(aes)");
+		tcrypt_test(test, "ecb(aes)");
+		tcrypt_test(test, "cbc(aes)");
+		tcrypt_test(test, "lrw(aes)");
+		tcrypt_test(test, "xts(aes)");
+		tcrypt_test(test, "ctr(aes)");
+		tcrypt_test(test, "rfc3686(ctr(aes))");
+		tcrypt_test(test, "ofb(aes)");
+		tcrypt_test(test, "cfb(aes)");
 		break;
 
 	case 11:
-		ret += tcrypt_test("sha384");
+		tcrypt_test(test, "sha384");
 		break;
 
 	case 12:
-		ret += tcrypt_test("sha512");
+		tcrypt_test(test, "sha512");
 		break;
 
 	case 13:
-		ret += tcrypt_test("deflate");
+		tcrypt_test(test, "deflate");
 		break;
 
 	case 14:
-		ret += tcrypt_test("ecb(cast5)");
-		ret += tcrypt_test("cbc(cast5)");
-		ret += tcrypt_test("ctr(cast5)");
+		tcrypt_test(test, "ecb(cast5)");
+		tcrypt_test(test, "cbc(cast5)");
+		tcrypt_test(test, "ctr(cast5)");
 		break;
 
 	case 15:
-		ret += tcrypt_test("ecb(cast6)");
-		ret += tcrypt_test("cbc(cast6)");
-		ret += tcrypt_test("ctr(cast6)");
-		ret += tcrypt_test("lrw(cast6)");
-		ret += tcrypt_test("xts(cast6)");
+		tcrypt_test(test, "ecb(cast6)");
+		tcrypt_test(test, "cbc(cast6)");
+		tcrypt_test(test, "ctr(cast6)");
+		tcrypt_test(test, "lrw(cast6)");
+		tcrypt_test(test, "xts(cast6)");
 		break;
 
 	case 16:
-		ret += tcrypt_test("ecb(arc4)");
+		tcrypt_test(test, "ecb(arc4)");
 		break;
 
 	case 17:
-		ret += tcrypt_test("michael_mic");
+		tcrypt_test(test, "michael_mic");
 		break;
 
 	case 18:
-		ret += tcrypt_test("crc32c");
+		tcrypt_test(test, "crc32c");
 		break;
 
 	case 19:
-		ret += tcrypt_test("ecb(tea)");
+		tcrypt_test(test, "ecb(tea)");
 		break;
 
 	case 20:
-		ret += tcrypt_test("ecb(xtea)");
+		tcrypt_test(test, "ecb(xtea)");
 		break;
 
 	case 21:
-		ret += tcrypt_test("ecb(khazad)");
+		tcrypt_test(test, "ecb(khazad)");
 		break;
 
 	case 22:
-		ret += tcrypt_test("wp512");
+		tcrypt_test(test, "wp512");
 		break;
 
 	case 23:
-		ret += tcrypt_test("wp384");
+		tcrypt_test(test, "wp384");
 		break;
 
 	case 24:
-		ret += tcrypt_test("wp256");
+		tcrypt_test(test, "wp256");
 		break;
 
 	case 26:
-		ret += tcrypt_test("ecb(anubis)");
-		ret += tcrypt_test("cbc(anubis)");
+		tcrypt_test(test, "ecb(anubis)");
+		tcrypt_test(test, "cbc(anubis)");
 		break;
 
 	case 30:
-		ret += tcrypt_test("ecb(xeta)");
+		tcrypt_test(test, "ecb(xeta)");
 		break;
 
 	case 31:
-		ret += tcrypt_test("pcbc(fcrypt)");
+		tcrypt_test(test, "pcbc(fcrypt)");
 		break;
 
 	case 32:
-		ret += tcrypt_test("ecb(camellia)");
-		ret += tcrypt_test("cbc(camellia)");
-		ret += tcrypt_test("ctr(camellia)");
-		ret += tcrypt_test("lrw(camellia)");
-		ret += tcrypt_test("xts(camellia)");
+		tcrypt_test(test, "ecb(camellia)");
+		tcrypt_test(test, "cbc(camellia)");
+		tcrypt_test(test, "ctr(camellia)");
+		tcrypt_test(test, "lrw(camellia)");
+		tcrypt_test(test, "xts(camellia)");
 		break;
 
 	case 33:
-		ret += tcrypt_test("sha224");
+		tcrypt_test(test, "sha224");
 		break;
 
 	case 35:
-		ret += tcrypt_test("gcm(aes)");
+		tcrypt_test(test, "gcm(aes)");
 		break;
 
 	case 36:
-		ret += tcrypt_test("lzo");
+		tcrypt_test(test, "lzo");
 		break;
 
 	case 37:
-		ret += tcrypt_test("ccm(aes)");
+		tcrypt_test(test, "ccm(aes)");
 		break;
 
 	case 38:
-		ret += tcrypt_test("cts(cbc(aes))");
+		tcrypt_test(test, "cts(cbc(aes))");
 		break;
 
         case 39:
-		ret += tcrypt_test("xxhash64");
+		tcrypt_test(test, "xxhash64");
 		break;
 
         case 40:
-		ret += tcrypt_test("rmd160");
+		tcrypt_test(test, "rmd160");
 		break;
 
 	case 41:
-		ret += tcrypt_test("blake2s-256");
+		tcrypt_test(test, "blake2s-256");
 		break;
 
 	case 42:
-		ret += tcrypt_test("blake2b-512");
+		tcrypt_test(test, "blake2b-512");
 		break;
 
 	case 43:
-		ret += tcrypt_test("ecb(seed)");
+		tcrypt_test(test, "ecb(seed)");
 		break;
 
 	case 45:
-		ret += tcrypt_test("rfc4309(ccm(aes))");
+		tcrypt_test(test, "rfc4309(ccm(aes))");
 		break;
 
 	case 46:
-		ret += tcrypt_test("ghash");
+		tcrypt_test(test, "ghash");
 		break;
 
 	case 47:
-		ret += tcrypt_test("crct10dif");
+		tcrypt_test(test, "crct10dif");
 		break;
 
 	case 48:
-		ret += tcrypt_test("sha3-224");
+		tcrypt_test(test, "sha3-224");
 		break;
 
 	case 49:
-		ret += tcrypt_test("sha3-256");
+		tcrypt_test(test, "sha3-256");
 		break;
 
 	case 50:
-		ret += tcrypt_test("sha3-384");
+		tcrypt_test(test, "sha3-384");
 		break;
 
 	case 51:
-		ret += tcrypt_test("sha3-512");
+		tcrypt_test(test, "sha3-512");
 		break;
 
 	case 52:
-		ret += tcrypt_test("sm3");
+		tcrypt_test(test, "sm3");
 		break;
 
 	case 53:
-		ret += tcrypt_test("streebog256");
+		tcrypt_test(test, "streebog256");
 		break;
 
 	case 54:
-		ret += tcrypt_test("streebog512");
+		tcrypt_test(test, "streebog512");
 		break;
 
 	case 100:
-		ret += tcrypt_test("hmac(md5)");
+		tcrypt_test(test, "hmac(md5)");
 		break;
 
 	case 101:
-		ret += tcrypt_test("hmac(sha1)");
+		tcrypt_test(test, "hmac(sha1)");
 		break;
 
 	case 102:
-		ret += tcrypt_test("hmac(sha256)");
+		tcrypt_test(test, "hmac(sha256)");
 		break;
 
 	case 103:
-		ret += tcrypt_test("hmac(sha384)");
+		tcrypt_test(test, "hmac(sha384)");
 		break;
 
 	case 104:
-		ret += tcrypt_test("hmac(sha512)");
+		tcrypt_test(test, "hmac(sha512)");
 		break;
 
 	case 105:
-		ret += tcrypt_test("hmac(sha224)");
+		tcrypt_test(test, "hmac(sha224)");
 		break;
 
 	case 106:
-		ret += tcrypt_test("xcbc(aes)");
+		tcrypt_test(test, "xcbc(aes)");
 		break;
 
 	case 108:
-		ret += tcrypt_test("hmac(rmd160)");
+		tcrypt_test(test, "hmac(rmd160)");
 		break;
 
 	case 109:
-		ret += tcrypt_test("vmac64(aes)");
+		tcrypt_test(test, "vmac64(aes)");
 		break;
 
 	case 111:
-		ret += tcrypt_test("hmac(sha3-224)");
+		tcrypt_test(test, "hmac(sha3-224)");
 		break;
 
 	case 112:
-		ret += tcrypt_test("hmac(sha3-256)");
+		tcrypt_test(test, "hmac(sha3-256)");
 		break;
 
 	case 113:
-		ret += tcrypt_test("hmac(sha3-384)");
+		tcrypt_test(test, "hmac(sha3-384)");
 		break;
 
 	case 114:
-		ret += tcrypt_test("hmac(sha3-512)");
+		tcrypt_test(test, "hmac(sha3-512)");
 		break;
 
 	case 115:
-		ret += tcrypt_test("hmac(streebog256)");
+		tcrypt_test(test, "hmac(streebog256)");
 		break;
 
 	case 116:
-		ret += tcrypt_test("hmac(streebog512)");
+		tcrypt_test(test, "hmac(streebog512)");
 		break;
 
 	case 150:
-		ret += tcrypt_test("ansi_cprng");
+		tcrypt_test(test, "ansi_cprng");
 		break;
 
 	case 151:
-		ret += tcrypt_test("rfc4106(gcm(aes))");
+		tcrypt_test(test, "rfc4106(gcm(aes))");
 		break;
 
 	case 152:
-		ret += tcrypt_test("rfc4543(gcm(aes))");
+		tcrypt_test(test, "rfc4543(gcm(aes))");
 		break;
 
 	case 153:
-		ret += tcrypt_test("cmac(aes)");
+		tcrypt_test(test, "cmac(aes)");
 		break;
 
 	case 154:
-		ret += tcrypt_test("cmac(des3_ede)");
+		tcrypt_test(test, "cmac(des3_ede)");
 		break;
 
 	case 155:
-		ret += tcrypt_test("authenc(hmac(sha1),cbc(aes))");
+		tcrypt_test(test, "authenc(hmac(sha1),cbc(aes))");
 		break;
 
 	case 156:
-		ret += tcrypt_test("authenc(hmac(md5),ecb(cipher_null))");
+		tcrypt_test(test, "authenc(hmac(md5),ecb(cipher_null))");
 		break;
 
 	case 157:
-		ret += tcrypt_test("authenc(hmac(sha1),ecb(cipher_null))");
+		tcrypt_test(test, "authenc(hmac(sha1),ecb(cipher_null))");
 		break;
 	case 181:
-		ret += tcrypt_test("authenc(hmac(sha1),cbc(des))");
+		tcrypt_test(test, "authenc(hmac(sha1),cbc(des))");
 		break;
 	case 182:
-		ret += tcrypt_test("authenc(hmac(sha1),cbc(des3_ede))");
+		tcrypt_test(test, "authenc(hmac(sha1),cbc(des3_ede))");
 		break;
 	case 183:
-		ret += tcrypt_test("authenc(hmac(sha224),cbc(des))");
+		tcrypt_test(test, "authenc(hmac(sha224),cbc(des))");
 		break;
 	case 184:
-		ret += tcrypt_test("authenc(hmac(sha224),cbc(des3_ede))");
+		tcrypt_test(test, "authenc(hmac(sha224),cbc(des3_ede))");
 		break;
 	case 185:
-		ret += tcrypt_test("authenc(hmac(sha256),cbc(des))");
+		tcrypt_test(test, "authenc(hmac(sha256),cbc(des))");
 		break;
 	case 186:
-		ret += tcrypt_test("authenc(hmac(sha256),cbc(des3_ede))");
+		tcrypt_test(test, "authenc(hmac(sha256),cbc(des3_ede))");
 		break;
 	case 187:
-		ret += tcrypt_test("authenc(hmac(sha384),cbc(des))");
+		tcrypt_test(test, "authenc(hmac(sha384),cbc(des))");
 		break;
 	case 188:
-		ret += tcrypt_test("authenc(hmac(sha384),cbc(des3_ede))");
+		tcrypt_test(test, "authenc(hmac(sha384),cbc(des3_ede))");
 		break;
 	case 189:
-		ret += tcrypt_test("authenc(hmac(sha512),cbc(des))");
+		tcrypt_test(test, "authenc(hmac(sha512),cbc(des))");
 		break;
 	case 190:
-		ret += tcrypt_test("authenc(hmac(sha512),cbc(des3_ede))");
+		tcrypt_test(test, "authenc(hmac(sha512),cbc(des3_ede))");
 		break;
 	case 191:
-		ret += tcrypt_test("ecb(sm4)");
-		ret += tcrypt_test("cbc(sm4)");
-		ret += tcrypt_test("ctr(sm4)");
+		tcrypt_test(test, "ecb(sm4)");
+		tcrypt_test(test, "cbc(sm4)");
+		tcrypt_test(test, "ctr(sm4)");
 		break;
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
@@ -2973,55 +2974,35 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_available();
 		break;
 	}
-
-	return ret;
 }
 
-static int __init tcrypt_mod_init(void)
+static void tcrypt(struct kunit *test)
 {
-	int err = -ENOMEM;
 	int i;
 
 	for (i = 0; i < TVMEMSIZE; i++) {
-		tvmem[i] = (void *)__get_free_page(GFP_KERNEL);
-		if (!tvmem[i])
-			goto err_free_tv;
-	}
-
-	err = do_test(alg, type, mask, mode, num_mb);
-
-	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
-		goto err_free_tv;
-	} else {
-		pr_debug("all tests passed\n");
+		// TODO: is this properly equivalent to __get_free_page?
+		// Or do they really really need these to be individual pages???
+		tvmem[i] = kunit_kmalloc(test, PAGE_SIZE, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, tvmem[i]);
 	}
 
-	/* We intentionaly return -EAGAIN to prevent keeping the module,
-	 * unless we're running in fips mode. It does all its work from
-	 * init() and doesn't offer any runtime functionality, but in
-	 * the fips case, checking for a successful load is helpful.
-	 * => we don't need it in the memory, do we?
-	 *                                        -- mludvig
-	 */
-	if (!fips_enabled)
-		err = -EAGAIN;
-
-err_free_tv:
-	for (i = 0; i < TVMEMSIZE && tvmem[i]; i++)
-		free_page((unsigned long)tvmem[i]);
-
-	return err;
+	do_test(test, alg, type, mask, mode, num_mb);
+	// TODO: I don't think we need to return -EAGAIN if !fips_enabled, do
+	// we?
 }
 
-/*
- * If an init function is provided, an exit function must also be provided
- * to allow module unload.
- */
-static void __exit tcrypt_mod_fini(void) { }
+static struct kunit_case crypto_test_cases[] = {
+	KUNIT_CASE(tcrypt),
+	{}
+};
+
+static struct kunit_suite crypto_test_suite = {
+	.name = "tcrypt",
+	.test_cases = crypto_test_cases,
+};
 
-late_initcall(tcrypt_mod_init);
-module_exit(tcrypt_mod_fini);
+kunit_test_suites(&crypto_test_suite);
 
 module_param(alg, charp, 0);
 module_param(type, uint, 0);
-- 
2.32.0.402.g57bb445576-goog

