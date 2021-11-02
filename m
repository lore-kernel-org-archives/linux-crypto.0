Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3137CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FD0610A3
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhKBO0S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBO0J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 10:26:09 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD560C0613B9
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 07:23:33 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j3-20020a628003000000b004811bc66186so3116188pfd.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 07:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=63IOB9jRdXUGAooHjzUqMr+AM+45Pd5GmDjRByI/XbI=;
        b=qi4MgoYmDEaLYqbeJbKBcxSIcp/8i0isps5OLMCXixb4n3H16s6alormsch+ATl6Kn
         Z2pkLw95tCm6HK96SFLKo6IDh6coBNXhl8VIXccM2QK8YNpIEOuTbNAB4aHtklBylK3d
         gn1U3F0peJ3bvludQKGt5QJLvD3m/LZJ0ZFEb9MjS0c2YZONBgXLORkNxZYWZBIBJZfB
         dqPL+JovaI2bQMp9ya9sldwT3NZgFnXGiaZzZOiJB/aNLCoBbNWHLdfo0XIomiebZOet
         aP7TIGzfmU43Ozh/kfwl9b0hkofWDt3F+qowWRMQ4J5ecqDVkfCxKb9J2pfMJJQR/wFB
         OnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=63IOB9jRdXUGAooHjzUqMr+AM+45Pd5GmDjRByI/XbI=;
        b=yphm+BoE8vGqd+tdQk5TUisO9Ai+s8xMIkEpNNqVeWtn0RK2o8oXcaKwhs+K6rWMCo
         8gMm83/WhFzz0/LUF2hJ9+Mg8vcL9AUv5dLCdyLQL0mF4RgElU4kShE556FHzmcmZVHs
         kpg1W1RRXwNfVkSx1JVgn1GhAHt2y7osito3TRmuIfsMbtMt4hnAPDvo42rh5aqJc3pz
         AUx4I8eXsUE7fe3mlPxFTjQZsWEXiuzMEWJc5koirDhOD54tzzP/YxwrLtsLEpjv60o4
         txKEZyPFQSkZ5dtHcDuSAy2TqP2md6yS4j8fJpdTMbA41UFCpAyt0HAXL9yUC0xoT8yf
         j6vQ==
X-Gm-Message-State: AOAM531dxgE9vWnq9Y9A8jT7aZw6rhPxxoJWfjlmweWIMSG0uoN9Ugzo
        h+XwiWQiiOnxDpBinh3hAYclm+KEGqk=
X-Google-Smtp-Source: ABdhPJxe+qQNjAW37tdJRSoe4g4rocE0eurn9JS1ToQLbTqzN1qZBg1QLEj/XudtcfFmmoI5SRruPmxqbt0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:3109:8497:f59d:9150])
 (user=pgonda job=sendgmr) by 2002:a63:83c6:: with SMTP id h189mr13190826pge.126.1635863013160;
 Tue, 02 Nov 2021 07:23:33 -0700 (PDT)
Date:   Tue,  2 Nov 2021 07:23:27 -0700
Message-Id: <20211102142331.3753798-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V3 0/4] Add SEV_INIT_EX support
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
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
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

David Rientjes (1):
  crypto: ccp - Add SEV_INIT_EX support

Peter Gonda (3):
  crypto: ccp - Fix SEV_INIT error logging on init
  crypto: ccp - Move SEV_INIT retry for corrupted data
  crypto: ccp - Refactor out sev_fw_alloc()

 .../virt/kvm/amd-memory-encryption.rst        |   6 +
 drivers/crypto/ccp/sev-dev.c                  | 226 +++++++++++++++---
 include/linux/psp-sev.h                       |  21 ++
 3 files changed, 221 insertions(+), 32 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

