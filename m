Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19D6C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbhLGXgn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242573AbhLGXgn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:36:43 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47BAC061748
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 15:33:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x14-20020a627c0e000000b0049473df362dso506565pfc.12
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iIqu28BeAUoA+tn6qtuHLblGA5Z72SgaTk+HvlXOhpM=;
        b=olgFNAjwG1AeRcw2PppFf/EUtPbfGR933cWHJ3Omt83fxkDYo/HetlZYrVHNcapkz9
         PUHZNPhkIKEJacNJcOuI4nHrnGuLQ1rtCrjfKPxbZEBglaXaY0smso+1eAw/U9k41CNQ
         kkOcMQSKpDZMomeAD3cL/QpCyHoRBGldcppdtpsc6xbnAU3/cSYgA2LWkNSI9Ci7K4LD
         CcCPIdwjdesWpcVZ8crEFeGBMtLYBJLA6XyilOnNcDL+ksJaVyG9wBOCnG6w7YNfLNZd
         UDiljsUgKh5WNuqKzyKt6j41FapC/EI5GRKLyIEjucKrEYDavXz85ozuf4+ITr+XFHks
         u4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iIqu28BeAUoA+tn6qtuHLblGA5Z72SgaTk+HvlXOhpM=;
        b=etnEIEVS/hm0/k2gQM8M8bMPwyRg4DDyk4cpPiIHRzglpyDduV9oG8gyirnV9bOmBf
         aJGBeV99c9TLkrwSPGcwOUE8ILXIuF7cCkojlIUlZ7pkfP/Pp425WhPverjIIW5pCbMx
         Sr6o5wIZ75xAvsn9093HE1faKvrUItO6WEc9j/KajN2vpGZ2kSHuY8cCAyaQhxt9B6Ii
         U5xQMbY0x7FaANrXFmNMTaipC7wC0yztOTxGDin7PRODXN/kBoXmD5p2VKMn0Rkyqkle
         r1EYHYwyGNh1ol8OtHlpFBkeOoEOseqsHa82hKhhtcF8ftlXzmvgsj1hnQ0rgSA760vC
         NWbA==
X-Gm-Message-State: AOAM530iJ+ORpXNnQy1tcsU2CE9rCS7gWT4CYQxIWQ2la2QpgOFl9GV3
        1hOrAH2+9m4cXlwC6l5d2MvwyAZ6vLA=
X-Google-Smtp-Source: ABdhPJxvziXdsdc0pNZh+Am/zNB3QgSZSap+AN8IzbDa9hpqE9VRdVreOlojNbRundI42qp++YRE+JjUTbw=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:46ed:9c47:8229:475d])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:2283:b0:49f:dea0:b9ba with SMTP id
 f3-20020a056a00228300b0049fdea0b9bamr2197867pfe.56.1638919992248; Tue, 07 Dec
 2021 15:33:12 -0800 (PST)
Date:   Tue,  7 Dec 2021 15:33:01 -0800
Message-Id: <20211207233306.2200118-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH V6 0/5] Add SEV_INIT_EX support
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

V4-5
* Fix make C=1 W=1 warnings.

V3
* Add another module parameter 'psp_init_on_probe' to allow for skipping
  PSP init on module init.
* Fixes review comments from Sean.
* Fixes missing error checking with file reading.
* Removed setting 'error' to a set value in patch 1.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
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

Peter Gonda (4):
  crypto: ccp - Add SEV_INIT rc error logging on init
  crypto: ccp - Move SEV_INIT retry for corrupted data
  crypto: ccp - Refactor out sev_fw_alloc()
  crypto: ccp - Add psp_init_on_probe module parameter

 .../virt/kvm/amd-memory-encryption.rst        |   6 +
 drivers/crypto/ccp/sev-dev.c                  | 259 +++++++++++++++---
 include/linux/psp-sev.h                       |  21 ++
 3 files changed, 245 insertions(+), 41 deletions(-)

-- 
2.34.1.400.ga245620fadb-goog

