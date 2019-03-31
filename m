Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E6FC4360F
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8E3C20872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062758;
	bh=h5nbxMrkDN9r1n8d3vLeRrQk1naUjeM5HskaTVLyW7U=;
	h=From:To:Subject:Date:List-ID:From;
	b=Q9dLAx84t3xvIjPKDaPwS5AAJm4eUwVrK4pJn98ihZtKAVwUROUbmNmXIGZWsbwb7
	 ull07d77xJARy5cnpI7hr1T2Q/qVQYxawaEM5PU6WFRIFISmus38Zodpokud+6Tb4d
	 JW//VX6RPCQ+dnYUsZJjY7HBCwVW91uQHVvGsOSI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbfCaUF5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731283AbfCaUF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0330120866
        for <linux-crypto@vger.kernel.org>; Sun, 31 Mar 2019 20:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062756;
        bh=h5nbxMrkDN9r1n8d3vLeRrQk1naUjeM5HskaTVLyW7U=;
        h=From:To:Subject:Date:From;
        b=cac7Grl1J6Fl+Z1ggKdREqnodAvHvtaDTOWaclbB1gJ+EULrGdMaPERmq2BG3QXRh
         J4aqDAonTIwSx7wcyJ9shboFLqnj8ddt9ZTGhUKOfSr7PB22MhKZKozZKuQUnF/0pa
         wmg5xL35QiGJ/4TYmLAWKSYLTOleDfUtp/JMuFNU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC/RFT PATCH 00/18] crypto: fuzz algorithms against their generic implementation
Date:   Sun, 31 Mar 2019 13:04:10 -0700
Message-Id: <20190331200428.26597-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

In the crypto API, all implementations of each algorithm are supposed to
produce the same results.  However, testing of this is currently limited
to the list of test vectors hardcoded for each algorithm.  Although
after recent improvements the self-tests do much more with each test
vector, hardcoded test vectors can never cover all cases.

This series improves the situation by making the self-tests
automatically generate random test vectors using the corresponding
generic implementation, then run them against the algorithm under test.
This detects bugs where the implementations don't match.

These new fuzz tests are behind CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

As usual, the series begins with fixes for the bugs found, roughly in
order of decreasing importance.  Please consider sending the Poly1305
fix to Linus soon.

Patches 12-17 make the testmgr improvements.

Patch 18 makes all templates and generic implementations be registered
earlier so that they're available when optimized implementations are
being tested, when both are built-in.  Note that even after this, for
many algorithms it's still possible to make the generic implementation
unset or modular.  Thus a missing generic implementation just causes the
comparison tests to be skipped with a warning; they aren't failed.

Also as usual, I've only tested all generic, x86, arm, and arm64
software algorithms.  I encourage people to run the tests on drivers and
other architectures, as they will find more bugs.

This series can also be found in git at:

	URL: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
	Branch: cryptofuzz-vs-generic

Eric Biggers (18):
  crypto: x86/poly1305 - fix overflow during partial reduction
  crypto: crct10dif-generic - fix use via crypto_shash_digest()
  crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
  crypto: skcipher - restore default skcipher_walk::iv on error
  crypto: skcipher - don't WARN on unprocessed data after slow walk step
  crypto: chacha20poly1305 - set cra_name correctly
  crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
  crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
  crypto: streebog - fix unaligned memory accesses
  crypto: cts - don't support empty messages
  crypto: arm64/cbcmac - handle empty messages in same way as template
  crypto: testmgr - expand ability to test for errors
  crypto: testmgr - identify test vectors by name rather than number
  crypto: testmgr - add helpers for fuzzing against generic
    implementation
  crypto: testmgr - fuzz hashes against their generic implementation
  crypto: testmgr - fuzz skciphers against their generic implementation
  crypto: testmgr - fuzz AEADs against their generic implementation
  crypto: run initcalls for generic implementations earlier

 arch/arm64/crypto/aes-glue.c            |   2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c |  13 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S  |  14 +-
 arch/x86/crypto/poly1305-sse2-x86_64.S  |  22 +-
 crypto/842.c                            |   2 +-
 crypto/Makefile                         |   7 +-
 crypto/adiantum.c                       |   2 +-
 crypto/aegis128.c                       |   2 +-
 crypto/aegis128l.c                      |   2 +-
 crypto/aegis256.c                       |   2 +-
 crypto/aes_generic.c                    |   2 +-
 crypto/ansi_cprng.c                     |   2 +-
 crypto/anubis.c                         |   2 +-
 crypto/arc4.c                           |   2 +-
 crypto/authenc.c                        |   2 +-
 crypto/authencesn.c                     |   2 +-
 crypto/blowfish_generic.c               |   2 +-
 crypto/camellia_generic.c               |   2 +-
 crypto/cast5_generic.c                  |   2 +-
 crypto/cast6_generic.c                  |   2 +-
 crypto/cbc.c                            |   2 +-
 crypto/ccm.c                            |  40 +-
 crypto/cfb.c                            |   2 +-
 crypto/chacha20poly1305.c               |   6 +-
 crypto/chacha_generic.c                 |   2 +-
 crypto/cmac.c                           |   2 +-
 crypto/crc32_generic.c                  |   2 +-
 crypto/crc32c_generic.c                 |   2 +-
 crypto/crct10dif_generic.c              |  13 +-
 crypto/crypto_null.c                    |   2 +-
 crypto/ctr.c                            |   2 +-
 crypto/cts.c                            |  20 +-
 crypto/deflate.c                        |   2 +-
 crypto/des_generic.c                    |   2 +-
 crypto/dh.c                             |   2 +-
 crypto/drbg.c                           |   2 +-
 crypto/ecb.c                            |   2 +-
 crypto/ecdh.c                           |   2 +-
 crypto/echainiv.c                       |   2 +-
 crypto/fcrypt.c                         |   2 +-
 crypto/fips.c                           |   2 +-
 crypto/gcm.c                            |  32 +-
 crypto/ghash-generic.c                  |   2 +-
 crypto/hmac.c                           |   2 +-
 crypto/jitterentropy-kcapi.c            |   2 +-
 crypto/keywrap.c                        |   2 +-
 crypto/khazad.c                         |   2 +-
 crypto/lrw.c                            |   2 +-
 crypto/lz4.c                            |   2 +-
 crypto/lz4hc.c                          |   2 +-
 crypto/lzo-rle.c                        |   2 +-
 crypto/lzo.c                            |   2 +-
 crypto/md4.c                            |   2 +-
 crypto/md5.c                            |   2 +-
 crypto/michael_mic.c                    |   2 +-
 crypto/morus1280.c                      |   2 +-
 crypto/morus640.c                       |   2 +-
 crypto/nhpoly1305.c                     |   2 +-
 crypto/ofb.c                            |   2 +-
 crypto/pcbc.c                           |   2 +-
 crypto/poly1305_generic.c               |   2 +-
 crypto/rmd128.c                         |   2 +-
 crypto/rmd160.c                         |   2 +-
 crypto/rmd256.c                         |   2 +-
 crypto/rmd320.c                         |   2 +-
 crypto/rsa.c                            |   2 +-
 crypto/salsa20_generic.c                |   2 +-
 crypto/seed.c                           |   2 +-
 crypto/seqiv.c                          |   2 +-
 crypto/serpent_generic.c                |   2 +-
 crypto/sha1_generic.c                   |   2 +-
 crypto/sha256_generic.c                 |   2 +-
 crypto/sha3_generic.c                   |   2 +-
 crypto/sha512_generic.c                 |   2 +-
 crypto/skcipher.c                       |  21 +-
 crypto/sm3_generic.c                    |   2 +-
 crypto/sm4_generic.c                    |   2 +-
 crypto/streebog_generic.c               |  27 +-
 crypto/tcrypt.c                         |   2 +-
 crypto/tea.c                            |   2 +-
 crypto/testmgr.c                        | 978 +++++++++++++++++++++---
 crypto/testmgr.h                        |  66 +-
 crypto/tgr192.c                         |   2 +-
 crypto/twofish_generic.c                |   2 +-
 crypto/vmac.c                           |   2 +-
 crypto/wp512.c                          |   2 +-
 crypto/xcbc.c                           |   2 +-
 crypto/xts.c                            |   2 +-
 crypto/zstd.c                           |   2 +-
 include/crypto/streebog.h               |   5 +-
 90 files changed, 1115 insertions(+), 301 deletions(-)

-- 
2.21.0

