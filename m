Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6120EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37AC860462
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKARYI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKARYF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:24:05 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90DC061764
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:21:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id jx2-20020a17090b46c200b001a62e9db321so326295pjb.7
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CoWFdMtEKYfjPZOD0vCpNP+OWRXL2lmJCe48NdmadTg=;
        b=gxe3023L4vM/f0BrrI+g4eczlr8eUSoK7OVP52Fd83Zx+/1xgnT7Xp760uYfL35mwZ
         eq1NLI0+GFpypCgLVs/5MwsEf3ic6o8mPUtoIdAmU9XkEtEF0FxGwo7bMi6ObOJSJ2pK
         9OHqcsWxwig7sc5WSRIjhTiEocMjG3MFxA31Mrpg47eiMWCB2/obzVQ7X5YbvqpX+zWD
         QMB8wqsR4PfopDPbFzdXKxnE+kV6EKNIyu7vw/aUgMPE477bdrT3sO6jJ1F8N2pzXtSA
         uuk8vvyvyBg9fIlp+VnqRk3aeSfGUSrXrq95lIkbVlX6aRWm8diqdRaApcsyEI+YEXBH
         6MhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CoWFdMtEKYfjPZOD0vCpNP+OWRXL2lmJCe48NdmadTg=;
        b=sMrJzeVewTnrOKKA6I98+M9pNOr1cGCYBxI4FJtSUvSUUk/2bEWA64KbRQf/O3Y8D8
         FRbrryy60hfA9GdHgw29QBySVWtjn4fyYRRLrUGyek4k9SymoD9Hx3p8dWXpYGngRiuU
         8+iQ154gcP/z+mlrH/u4+2kMsCYGG55Xk5Zb70QXG7aOrdUeZUV4+Drq4A4QB0KCby6V
         khTmPobrzJWp5ygPJF2PdvyWm115+KeYWWVv6gfZ2zybn3MJ40o+1u/1XMZOk1DUIsgD
         4zv4Z7tPGY3cObK3rU5xIKkd3u2pEpeErrFwugOhjGvKESA2ZXqCJDkdGYzV+Bp59QTJ
         Tw5Q==
X-Gm-Message-State: AOAM530GDFcGFIQPk7ZHhiqWxAM7KE+RQxuYPzk/3gA8igeZtFXnQapb
        QZ9DsuK4NCDtj/UEvVjWq491Xy7kJbw=
X-Google-Smtp-Source: ABdhPJwiBZENM6vFRwunYr1hYmFWQMBC3FQyA36QdhSOCzEEo6BoTKMuuHCS5+xD5yA5aJNdefZJfisA9Yg=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:98c4:afe5:ed9f:d0db])
 (user=pgonda job=sendgmr) by 2002:a62:8484:0:b0:481:5ff:48d6 with SMTP id
 k126-20020a628484000000b0048105ff48d6mr9475591pfd.78.1635787290687; Mon, 01
 Nov 2021 10:21:30 -0700 (PDT)
Date:   Mon,  1 Nov 2021 10:21:23 -0700
Message-Id: <20211101172127.3060453-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V2 0/4] Add SEV_INIT_EX support
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

 .../virt/kvm/amd-memory-encryption.rst        |   4 +
 drivers/crypto/ccp/sev-dev.c                  | 230 +++++++++++++++---
 include/linux/psp-sev.h                       |  21 ++
 3 files changed, 222 insertions(+), 33 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

