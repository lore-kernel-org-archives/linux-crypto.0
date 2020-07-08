Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCF7C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C809207C4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594226434;
	bh=Cd7Bu4p7Bm0T49BmT0LqPwauCVc+JZVWsU6Z1dNfMqM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=0F84AXzqsC6cIKJyAksRzLdmD2zvSWUDvlrGcbjUCOtgQWdsIad1f//rvs7BhGYAo
	 Ktm65D8dMDHwJRuy00ixej6ap/ylJHh5I9+LMw4BxAhyUn2xcd/Sfp8Vp7kz1za2Zy
	 LrIX3px1WOjyQEtwtXetEsZy7ouNfjNQf4fYUMkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgGHQkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbgGHQkc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 12:40:32 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB3020786;
        Wed,  8 Jul 2020 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594226431;
        bh=Cd7Bu4p7Bm0T49BmT0LqPwauCVc+JZVWsU6Z1dNfMqM=;
        h=From:To:Cc:Subject:Date:From;
        b=LyVLEL0NmgBwWs3sKZjfDTSSxyyoDgg3mc2EJASD16iKxpCI1uCiVw3RCrDCQGL02
         XED4dpeT7QEqS5N1rFCfkLlm4G4UzM7W5E9aHmMweKVpNiNmotCz0gz8sio6PsNufw
         +eCyOywVhvD22k1yqVZGV4T+eISs9vnPRBuNB1AE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     sparclinux@vger.kernel.org, linux-efi@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        alsa-devel@alsa-project.org,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        Tzung-Bi Shih <tzungbi@google.com>
Subject: [PATCH v2 0/5] crypto: add sha256() function
Date:   Wed,  8 Jul 2020 09:39:38 -0700
Message-Id: <20200708163943.52071-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series adds a function sha256() to the sha256 library so that users
who want to compute a hash in one step can just call sha256() instead of
sha256_init() + sha256_update() + sha256_final().

Patches 3-5 then convert some users to use it.

Changed v1 => v2:
  - Added sparc patch to fix a build breakage caused by a
    static variable already named "sha256".
  - Added Reviewed-by, Acked-by, and Tested-by tags.

Eric Biggers (5):
  crypto: sparc - rename sha256 to sha256_alg
  crypto: lib/sha256 - add sha256() function
  efi: use sha256() instead of open coding
  mptcp: use sha256() instead of open coding
  ASoC: cros_ec_codec: use sha256() instead of open coding

 arch/sparc/crypto/sha256_glue.c          | 14 ++++++------
 drivers/firmware/efi/embedded-firmware.c |  9 +++-----
 include/crypto/sha.h                     |  1 +
 lib/crypto/sha256.c                      | 10 +++++++++
 net/mptcp/crypto.c                       | 15 +++----------
 sound/soc/codecs/cros_ec_codec.c         | 27 ++----------------------
 6 files changed, 26 insertions(+), 50 deletions(-)


base-commit: 57c8aa43b9f272c382c253573c82be5cb68fe22d
-- 
2.27.0

