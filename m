Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30610C433E4
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6C120791
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DlYAU7i0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgGMQtC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMQtC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 12:49:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177E7C061755
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2020 09:49:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u189so14976343ybg.17
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2020 09:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q4swQt+v4fyy3TMJcFGSFXeoIem3Xd+mM7FBvSMUEpo=;
        b=DlYAU7i0wPUANloi9uSjm3sCK9o9iAe1t2uANgIzexCoThJdrZIrGmzkyCSYSETZZ3
         PJg9Qd+ty1fzeYysPz/l9RoUbeiJoJXQRpmJtv/vooG4ryuUMBbpDx/xFWEnvjGuepIT
         U8Ym87elsgU7p1P5OX0Dbf0BpYBdc7MZYT/120dEM43nKRdzEaSbhATClpKzmVWKc1jf
         jxIjO5kj41fdosltFXEF2f3rQZMeReVza0sfPL7JD12oMcDxyf4BoQrdeQ1zgJqD73Rl
         Z3gNrXOy1sg8I+6bLYl6roJIGrx8ngQGKETETvJJAclrQas8+nQ14csRNIYMn71ZVaob
         YvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q4swQt+v4fyy3TMJcFGSFXeoIem3Xd+mM7FBvSMUEpo=;
        b=N3TGkqaCxXVXtLlMbfL0/9iYx0J3++B91+6DrTQpFHfLHYM5NI9YJwJNn6ceKII1mJ
         ZxwnXrpBxsCsfF/mE+OHQMC3cq/Ek3Qit185AFvSQ3z/HKt8JoMY7gNKnFwlM88VB4GE
         KF1zQyvnfRfuDN/9S49j+ZcN5yw9LZuK+RCZ+xiT5dqoWkk69v1FCsXjpYYQmlSr9HVm
         f7A8odLOIg9psaEzq32MU7q4lq02ySUWhf9Ph9a+LWJuMF43+1fhmY/yPNnl/P2ey3Xb
         4heiq2oOUql/PL3PrGVhlsRFlAS0Gg47zh0SMw6HVZ2WYYXY13HeRXTJZLesn77sTT10
         Xijw==
X-Gm-Message-State: AOAM533VPVQIllD8L9lC+422u4m/DPGIIG7mFAWz0o1gOyOycUBIdCRl
        ojJRHpt4IomEHr3j6biWkhpG7oU4vB+5+55M9kSnVBxwLY9Om97ZIhgIsd/XP4D5TDn+b/WNpPU
        fSzyHJcFDzW04HQGnBt0IpyeoqAwcjy4Ae0Z6xnfDfV03KrCZVaxjkfCGfKeNvEaeADVXf+aN
X-Google-Smtp-Source: ABdhPJyPh8VUwUGopNRnRGY039LZPReWXaEp73rtrAE02kk5c6cW02iED3ehsluL43hwjoxzq2Yzs37Mwp1t
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr1428406ybg.257.1594658941173;
 Mon, 13 Jul 2020 09:49:01 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:48:56 +0100
Message-Id: <20200713164857.1031117-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 0/1] crypto: af_alg - add extra parameters for DRBG interface
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch extends the userspace RNG interface to make it usable for
CAVS testing. This is achieved by adding ALG_SET_DRBG_ENTROPY
option to the setsockopt interface for specifying the entropy, and using
sendmsg syscall for specifying the additional data.

See libkcapi patch [1] to test the added functionality. The libkcapi
patch is not intended for merging into libkcapi as is: it is only a
quick plug to manually verify that the extended AF_ALG RNG interface
generates the expected output on DRBG800-90A CAVS inputs.

[1] https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa592cb531

Elena Petrova (1):
  crypto: af_alg - add extra parameters for DRBG interface

 Documentation/crypto/userspace-if.rst | 14 +++-
 crypto/af_alg.c                       |  8 +++
 crypto/algif_rng.c                    | 99 +++++++++++++++++++++++++--
 include/crypto/if_alg.h               |  3 +-
 include/uapi/linux/if_alg.h           |  1 +
 5 files changed, 115 insertions(+), 10 deletions(-)

--
2.27.0.383.g050319c2ae-goog

