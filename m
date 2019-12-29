Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D793C2D0D1
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C6721775
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588285;
	bh=vJKdqwj8dIJy+k+3iEw5Y7RPZYJm3Sq2o+jPmuAdqQQ=;
	h=From:To:Subject:Date:List-ID:From;
	b=x165fPGd/i4Rryg0t7c43VU6FlFg5RvxSrmfF3nsKUh7d7tYnQU3u/kfGC4V9cT21
	 wMN+m2fHQ4/Q5VZcxXnnJ1X1VU6rsf88PTJ/K067t96Pq0k92L3rxjeVgpJvBI1KjC
	 2hxQ3XF43BYmtLOdt4uLRMBK5QS2qcveg/wBiCOo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfL2C6D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfL2C6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:03 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CBC8206F4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588282;
        bh=vJKdqwj8dIJy+k+3iEw5Y7RPZYJm3Sq2o+jPmuAdqQQ=;
        h=From:To:Subject:Date:From;
        b=Nix40WXOtZVjcOZqEylQ2fw8UckhiDJ9L33xg5/1LVMp0oYrEVsV3RvrZKRYtT8U9
         rLOPhyHdiJDrKTU8kxm/P5WBMIV0Sz/g7OgKfxzLoF/0nY64KWh1khn7SMwvtpGIp7
         yRdWuUBoWyMPmiQGnA8Bv8qjFXlipGLsYG5tDmdc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 00/28] crypto: template instantiation cleanup
Date:   Sat, 28 Dec 2019 20:56:46 -0600
Message-Id: <20191229025714.544159-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

This series makes all crypto templates initialize their spawns (i.e.
their "inner algorithms") in a consistent way, using a consistent set of
crypto_grab_*() helper functions.  skcipher, aead, and akcipher spawns
already used this approach, but shash, ahash, and cipher spawns were
being initialized differently -- causing confusion and unnecessary code.

As long as it's introducing new crypto_grab_*() functions, this series
also takes the opportunity to first improve the existing ones to take
the instance pointer as a parameter, so that all callers don't have to
store it temporarily to crypto_spawn::inst.

Finally, this series also makes two changes that allow simplifying the
error handling in template ->create() functions: (1) crypto_drop_spawn()
is made a no-op on uninitialized instances, and (2) crypto_grab_spawn()
is made to handle an ERR_PTR() name.

Taking advantage of these two changes, this series also simplifies the
error handling in the template ->create() functions which were being
updated anyway to use a new crypto_grab_*() function.  But to keep this
series manageable, simplifying error handling in the remaining templates
is left for later.

This series is an internal cleanup only; there are no changes for users
of the crypto API.  I've tested that all the templates still get
instantiated correctly and that errors seem to be handled properly.

Eric Biggers (28):
  crypto: algapi - make crypto_drop_spawn() a no-op on uninitialized
    spawns
  crypto: algapi - make crypto_grab_spawn() handle an ERR_PTR() name
  crypto: shash - make struct shash_instance be the full size
  crypto: ahash - make struct ahash_instance be the full size
  crypto: skcipher - pass instance to crypto_grab_skcipher()
  crypto: aead - pass instance to crypto_grab_aead()
  crypto: akcipher - pass instance to crypto_grab_akcipher()
  crypto: algapi - pass instance to crypto_grab_spawn()
  crypto: shash - introduce crypto_grab_shash()
  crypto: ahash - introduce crypto_grab_ahash()
  crypto: cipher - introduce crypto_cipher_spawn and
    crypto_grab_cipher()
  crypto: adiantum - use crypto_grab_{cipher,shash} and simplify error
    paths
  crypto: cryptd - use crypto_grab_shash() and simplify error paths
  crypto: hmac - use crypto_grab_shash() and simplify error paths
  crypto: authenc - use crypto_grab_ahash() and simplify error paths
  crypto: authencesn - use crypto_grab_ahash() and simplify error paths
  crypto: gcm - use crypto_grab_ahash() and simplify error paths
  crypto: ccm - use crypto_grab_ahash() and simplify error paths
  crypto: chacha20poly1305 - use crypto_grab_ahash() and simplify error
    paths
  crypto: skcipher - use crypto_grab_cipher() and simplify error paths
  crypto: cbcmac - use crypto_grab_cipher() and simplify error paths
  crypto: cmac - use crypto_grab_cipher() and simplify error paths
  crypto: vmac - use crypto_grab_cipher() and simplify error paths
  crypto: xcbc - use crypto_grab_cipher() and simplify error paths
  crypto: cipher - make crypto_spawn_cipher() take a crypto_cipher_spawn
  crypto: algapi - remove obsoleted instance creation helpers
  crypto: ahash - unexport crypto_ahash_type
  crypto: algapi - fold crypto_init_spawn() into crypto_grab_spawn()

 crypto/adiantum.c                  |  87 +++++++----------------
 crypto/aead.c                      |   7 +-
 crypto/ahash.c                     |  39 ++++-------
 crypto/akcipher.c                  |   7 +-
 crypto/algapi.c                    |  99 +++++---------------------
 crypto/authenc.c                   |  57 +++++----------
 crypto/authencesn.c                |  57 +++++----------
 crypto/ccm.c                       | 107 +++++++++++------------------
 crypto/chacha20poly1305.c          |  88 ++++++++----------------
 crypto/cipher.c                    |  11 +++
 crypto/cmac.c                      |  38 +++++-----
 crypto/cryptd.c                    |  76 ++++++--------------
 crypto/ctr.c                       |   4 +-
 crypto/cts.c                       |   9 +--
 crypto/essiv.c                     |  16 ++---
 crypto/gcm.c                       |  76 ++++++++------------
 crypto/geniv.c                     |   4 +-
 crypto/hmac.c                      |  36 +++++-----
 crypto/lrw.c                       |  15 ++--
 crypto/pcrypt.c                    |   5 +-
 crypto/rsa-pkcs1pad.c              |   8 ++-
 crypto/shash.c                     |  28 +++-----
 crypto/skcipher.c                  |  41 +++++------
 crypto/vmac.c                      |  38 +++++-----
 crypto/xcbc.c                      |  43 +++++-------
 crypto/xts.c                       |   9 +--
 include/crypto/algapi.h            |  58 +++++++---------
 include/crypto/internal/aead.h     |  11 +--
 include/crypto/internal/akcipher.h |  12 +---
 include/crypto/internal/hash.h     |  70 +++++++++----------
 include/crypto/internal/skcipher.h |  11 +--
 31 files changed, 423 insertions(+), 744 deletions(-)

-- 
2.24.1

