Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD01C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiKNANN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiKNANM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB3C63BF
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A71760DEF
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B05DC433B5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384790;
        bh=6hKWU9oGW/j1JEP9AO9UTld3/H3VeoI1QVr1eYiqVng=;
        h=From:To:Subject:Date:From;
        b=VPeTQKphJeRS4UDuh9hscXnWOZHvaVo85YY5ApHDRYoyDbaOTBBkqYK8mMqvEPLvN
         urJfopPUA6TWpbhkFE06+YuSY0zzDZz/w1hluASPBgaP/D81HgtU7VZcd1Gwk8uQFT
         o45KFvetaNk0fEIjshg2c1t1ipQzg5sGohZ75UUigdmFZBDMNCdBmi2DEk85Vv8h7V
         cTHTs9IZjhgSU1rElHe3hH7SF5KgdCfbW+BzySQGgKgKiD384wsCAuEC+kBUSGHDx0
         gVeJQeGC7olxDllODE/rZDCCO++Oedfr3OVmU+cDUfvjL9TO+mU2GX5u74LsBo2wRX
         61vPmymVhPJ3Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/6] crypto: reduce overhead when self-tests disabled
Date:   Sun, 13 Nov 2022 16:12:32 -0800
Message-Id: <20221114001238.163209-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset makes it so that the self-test code doesn't still slow
things down when self-tests are disabled via the kconfig.

It also optimizes the registration of "internal" algorithms and silences
a noisy log message.

Changed in v3:
  - Made sure CRYPTO_MSG_ALG_LOADED still always gets sent.
  - Fixed a race condition with larval->test_started.
  - Used IS_ENABLED() in a couple places to avoid #ifdefs.

Eric Biggers (6):
  crypto: optimize algorithm registration when self-tests disabled
  crypto: optimize registration of internal algorithms
  crypto: compile out crypto_boot_test_finished when tests disabled
  crypto: skip kdf_sp800108 self-test when tests disabled
  crypto: silence noisy kdf_sp800108 self-test
  crypto: compile out test-related algboss code when tests disabled

 crypto/algapi.c       | 160 ++++++++++++++++++++++++------------------
 crypto/algboss.c      |  22 ++----
 crypto/api.c          |  11 ++-
 crypto/internal.h     |  20 +++++-
 crypto/kdf_sp800108.c |  10 ++-
 5 files changed, 127 insertions(+), 96 deletions(-)


base-commit: 557ffd5a4726f8b6f0dd1d4b632ae02c1c063233
-- 
2.38.1

