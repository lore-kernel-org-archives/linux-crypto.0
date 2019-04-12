Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF129C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF86218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045251;
	bh=yqwpHOGSQv4z5BLMB47rzKcGkok3PF2Ot/U+VJCY1j8=;
	h=From:To:Subject:Date:List-ID:From;
	b=rQjlijacUv5VuSzABoNjh+7T+Ui/XZfGtDoP36MOQo5oLfwp+8DqrEMlYb14eGLTH
	 tMXvEtaSVBKbf7CZOIIyYc2BfB8hqFzoPGB4K6uvLY8fqwqdDWCsWVifXlMq9uL6sO
	 nrqjd8RiuqDg4kXols3phpWZCEkbgFRi0wu8xgos=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbfDLFAu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbfDLFAu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:50 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D4A20652;
        Fri, 12 Apr 2019 05:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045249;
        bh=yqwpHOGSQv4z5BLMB47rzKcGkok3PF2Ot/U+VJCY1j8=;
        h=From:To:Subject:Date:From;
        b=FbBe4l9WkbejYhCoWO4k/OqAqJwP2ovckmeq4ad700PqEbow5f6Rxt74jGVNaqXsH
         ltUIla6WKHKxhHiuhgj0UzkRNY4UUhaXTx26r/VZReuDh39vkH0pT/fg0O+GGjC1Cm
         AL6qX0E7FINHIP2guqKrm4TAFRV/TGsc1VymbGA4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 0/7] crypto: fuzz algorithms against their generic implementation
Date:   Thu, 11 Apr 2019 21:57:35 -0700
Message-Id: <20190412045742.1725-1-ebiggers@kernel.org>
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

This has already found many bugs and inconsistencies, including an
integer overflow bug in the x86_64 implementation of Poly1305.

These new fuzz tests are behind CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

Patch 1-6 are the testmgr changes themselves.  Patch 7 makes the generic
implementations be registered earlier so that they're available when
optimized implementations are being tested, when both are built-in.
Note that even after this, for many algorithms it's still possible to
make the generic implementation unset or modular.  Thus a missing
generic implementation just causes the comparison tests to be skipped
with a warning; they aren't failed.

So far I've tested all generic, x86, arm, and arm64 algorithms, plus
some PowerPC algorithms.  I have not tested hardware drivers.  I
encourage people to run the tests on drivers and other architectures, as
they will find more bugs.

This can also be found in git at:

	URL: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
	Branch: cryptofuzz-vs-generic

Changed since v1:

    - Make cryptomgr use arch_initcall(), so we don't rely on the order
      in which the object files are linked.

    - Show the expected error code when a test fails due to the wrong
      error code being returned.

    - Generate zero-length associated data more often for AEADs
      (about 1/4 of the time rather than about 1/256 of the time).

    - A few other minor cleanups.

Eric Biggers (7):
  crypto: testmgr - expand ability to test for errors
  crypto: testmgr - identify test vectors by name rather than number
  crypto: testmgr - add helpers for fuzzing against generic
    implementation
  crypto: testmgr - fuzz hashes against their generic implementation
  crypto: testmgr - fuzz skciphers against their generic implementation
  crypto: testmgr - fuzz AEADs against their generic implementation
  crypto: run initcalls for generic implementations earlier

 crypto/842.c                 |   2 +-
 crypto/adiantum.c            |   2 +-
 crypto/aegis128.c            |   2 +-
 crypto/aegis128l.c           |   2 +-
 crypto/aegis256.c            |   2 +-
 crypto/aes_generic.c         |   2 +-
 crypto/algboss.c             |   8 +-
 crypto/ansi_cprng.c          |   2 +-
 crypto/anubis.c              |   2 +-
 crypto/arc4.c                |   2 +-
 crypto/authenc.c             |   2 +-
 crypto/authencesn.c          |   2 +-
 crypto/blowfish_generic.c    |   2 +-
 crypto/camellia_generic.c    |   2 +-
 crypto/cast5_generic.c       |   2 +-
 crypto/cast6_generic.c       |   2 +-
 crypto/cbc.c                 |   2 +-
 crypto/ccm.c                 |   2 +-
 crypto/cfb.c                 |   2 +-
 crypto/chacha20poly1305.c    |   2 +-
 crypto/chacha_generic.c      |   2 +-
 crypto/cmac.c                |   2 +-
 crypto/crc32_generic.c       |   2 +-
 crypto/crc32c_generic.c      |   2 +-
 crypto/crct10dif_generic.c   |   2 +-
 crypto/crypto_null.c         |   2 +-
 crypto/ctr.c                 |   2 +-
 crypto/cts.c                 |   2 +-
 crypto/deflate.c             |   2 +-
 crypto/des_generic.c         |   2 +-
 crypto/dh.c                  |   2 +-
 crypto/drbg.c                |   2 +-
 crypto/ecb.c                 |   2 +-
 crypto/ecdh.c                |   2 +-
 crypto/echainiv.c            |   2 +-
 crypto/fcrypt.c              |   2 +-
 crypto/fips.c                |   2 +-
 crypto/gcm.c                 |   2 +-
 crypto/ghash-generic.c       |   2 +-
 crypto/hmac.c                |   2 +-
 crypto/jitterentropy-kcapi.c |   2 +-
 crypto/keywrap.c             |   2 +-
 crypto/khazad.c              |   2 +-
 crypto/lrw.c                 |   2 +-
 crypto/lz4.c                 |   2 +-
 crypto/lz4hc.c               |   2 +-
 crypto/lzo-rle.c             |   2 +-
 crypto/lzo.c                 |   2 +-
 crypto/md4.c                 |   2 +-
 crypto/md5.c                 |   2 +-
 crypto/michael_mic.c         |   2 +-
 crypto/morus1280.c           |   2 +-
 crypto/morus640.c            |   2 +-
 crypto/nhpoly1305.c          |   2 +-
 crypto/ofb.c                 |   2 +-
 crypto/pcbc.c                |   2 +-
 crypto/pcrypt.c              |   2 +-
 crypto/poly1305_generic.c    |   2 +-
 crypto/rmd128.c              |   2 +-
 crypto/rmd160.c              |   2 +-
 crypto/rmd256.c              |   2 +-
 crypto/rmd320.c              |   2 +-
 crypto/rsa.c                 |   2 +-
 crypto/salsa20_generic.c     |   2 +-
 crypto/seed.c                |   2 +-
 crypto/seqiv.c               |   2 +-
 crypto/serpent_generic.c     |   2 +-
 crypto/sha1_generic.c        |   2 +-
 crypto/sha256_generic.c      |   2 +-
 crypto/sha3_generic.c        |   2 +-
 crypto/sha512_generic.c      |   2 +-
 crypto/sm3_generic.c         |   2 +-
 crypto/sm4_generic.c         |   2 +-
 crypto/streebog_generic.c    |   2 +-
 crypto/tcrypt.c              |   2 +-
 crypto/tea.c                 |   2 +-
 crypto/testmgr.c             | 989 +++++++++++++++++++++++++++++++----
 crypto/testmgr.h             |  22 +-
 crypto/tgr192.c              |   2 +-
 crypto/twofish_generic.c     |   2 +-
 crypto/vmac.c                |   2 +-
 crypto/wp512.c               |   2 +-
 crypto/xcbc.c                |   2 +-
 crypto/xts.c                 |   2 +-
 crypto/zstd.c                |   2 +-
 85 files changed, 986 insertions(+), 197 deletions(-)

-- 
2.21.0

