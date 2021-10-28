Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6404BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DC9610D2
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhJ1SAW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1SAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 14:00:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2BBC061570
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:57:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s15-20020a170902b18f00b0013fb4449cecso3169414plr.19
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dGW8Vt2et+rcne6KwVtymqYHCSGlZ53wYldu0Tzg1PY=;
        b=E41H1VqPdFGwysh2xLCK9BkUQkic8v8Lvz4Hl6GuDateDJxDJJuneXXzgVz0Qm2yIh
         zgbULIiCiVB5zXuQFDJ+2T8qjFuevalztleL3TBfiUA+w9p2wl+v7A21ox/tqu13Y4Si
         KU/cUmsSbyBHMwhlbEv8wzhoPW9d2fsor4lsgWoSduvmKNWwf41/WscVWc+rOQomhLNR
         bYUZin8CpQahy6JIwBAemeXeZ1VEJH9+9EoTqH6jfA4xGEDO0QqQBuJE9yAAJ4kxD1ke
         TytSg3m82JkgPVOhREYb89fnbfD05rlrY7g68/pyCxyKG/iRpl9Zeq7ijcBPVbIf0s+K
         Aydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dGW8Vt2et+rcne6KwVtymqYHCSGlZ53wYldu0Tzg1PY=;
        b=Yy3sxg0s+LVTXju96C9XQ+ty4pJJRQWFcdD3Y+5srhQwfkl9dkJtKAXY52UqXP20Y2
         fCfJu6o05OBYSWjSRkUZjNnmzHSJGkI8VUPa3Oij0F62WbPvkL1v/6wZtIBt5zI+cEEJ
         y2xBaRE/9LDCwfRj/6olHN/fBgM/0MdUfWi9j6dbsIwx0Z+Dg/kVcyb6ic5d4Nj4d4WN
         /9WjBSy15SgXj9bhJ2aYSod8Cn7tUs+s1beFnxGLJFUVp3AN36vDMbHQRb+7UTOyZSdX
         rAkTsCjy+9rCjYUyFlXYUSIxO4qaoPgX110mHa0gQOFwNefNl2Fb5e1V1VcaNFrATKiU
         3MuA==
X-Gm-Message-State: AOAM530igFbIqjwG2N0RFEV5dujCMFVNSqIlHSvtAnHNaiJIJ1aNHO0u
        pn0JIK0YFHLgNUHnHC/N5xcPQC/OYbU=
X-Google-Smtp-Source: ABdhPJyDkWvwmejANP9IaoW4wvFJbAp5K8gMld+mCamLjkK9txvo/aqdtuPsR+KqRb3G3eEGOfB4yK4oWlk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:41d0:ac84:3b61:5938])
 (user=pgonda job=sendgmr) by 2002:a17:90b:60d:: with SMTP id
 gb13mr85565pjb.0.1635443873897; Thu, 28 Oct 2021 10:57:53 -0700 (PDT)
Date:   Thu, 28 Oct 2021 10:57:45 -0700
Message-Id: <20211028175749.1219188-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 0/4] Add SEV_INIT_EX support
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SEV_INIT requires users to unlock their SPI bus for the PSP's non
volatile (NV) storage. Users may wish to lock their SPI bus for numerous
reasons, to support this the PSP firmware supports SEV_INIT_EX. INIT_EX
allows the firmware to use a region of memory for its NV storage leaving
the kernel responsible for actually storing the data in a persistent
way. This series adds a new module parameter to ccp allowing users to
specify a path to a file for use as the PSP's NV storage. The ccp driver
then reads the file into memory for the PSP to use and is responsible
for writing the file whenever the PSP modifies the memory region.

Signed-off-by: Peter Gonda <pgonda@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com> (
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

David Rientjes (1):
  crypto: ccp - Add SEV_INIT_EX support

Peter Gonda (3):
  crypto: ccp - Fix SEV_INIT error logging on init
  crypto: ccp - Move SEV_INIT retry for corrupted data
  crypto: ccp - Refactor out sev_fw_alloc()

 drivers/crypto/ccp/sev-dev.c | 235 ++++++++++++++++++++++++++++++-----
 include/linux/psp-sev.h      |  21 ++++
 2 files changed, 222 insertions(+), 34 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

