Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3374C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Mar 2021 10:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18F261936
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Mar 2021 10:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhC2Kpy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Mar 2021 06:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhC2Kpa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Mar 2021 06:45:30 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19E8C061574;
        Mon, 29 Mar 2021 03:45:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bt4so5788815pjb.5;
        Mon, 29 Mar 2021 03:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g2efpXc6CiG6QCMpvbYQLueL6cg1gKbJK+Z6dWI/3SA=;
        b=lwrDNhydGj21KJbXpi1nfvXIHfwqMDKggqjgFJYmJiFhS1w2zAilBYILA2Pf+jhLBG
         LXTuSExnbOeyAt1TLjatsaF78h+UIn//EmEKd32UB2TkEZhxCI9cul7wvRSgJB9n7WKm
         Aj0/x94Ok2ChTDRpA0+S5TVIqRDTE62HZZaHxiwMsRCiwGTxvmCNDnJsmRHPLIWGJ+1P
         7Zcqu7Re8dbRg7GRLyUXr8tsvODQTGElId3XjqrWCfW068mkTC2k8i22UiVONQHg5mk2
         wb7T7DfcU6OnPUmGUUZRDApveoszKOJ46JaIRA82UPEVSZj4CU/h26KAuvbA7D2BsYlz
         alrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g2efpXc6CiG6QCMpvbYQLueL6cg1gKbJK+Z6dWI/3SA=;
        b=Tlj6x8EamuOfKSAfRRdMjvE4bS7Xh0apAPCB8+X9EWbA9Am6CjchCoNIpIkSp7f1rb
         MkM4lQbfIJqutogs8jG4fRt3CdtXjs5Ilp4NFizoxV7n4DMYh7i0fkibJRNZKEgxw40C
         M+WS7v/mnvuIrfJC5HYjoxpU8IX9lHY2CsgEMW6laSat1KGVV8Ay6VBX7HssI+8y1OWU
         B9EqGnv8Sbu1GnPc8uUhkitOeUWh5uI4JiUbLc+h/RON8OBSQXmA4ab5otBkKdhrtc0l
         P4+syfB1L+Bcal+3nzYaxNA9NxZyWYILRHUQnN+PuudYMoLKY36VJdmpTvsPDcbUDCgV
         t6Rw==
X-Gm-Message-State: AOAM530NIz9nuhOGCdLU9rSl3JGLlGLQdlIgwrrCOJwqzmBST+Y7Axo1
        FQ2b1LPEUyyIUT/0Md49QeY=
X-Google-Smtp-Source: ABdhPJxZSy88aUJ6nv1FSCn7vFcyjln/WZWwIqUth7Zbwp+cTyNUvACjs0umhKfvpfaQ+TFdNkjGHg==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id v10-20020a1709029a0ab02900e6bf008a36mr28128496plp.51.1617014729311;
        Mon, 29 Mar 2021 03:45:29 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:4ed:8f53:adc7:b574])
        by smtp.googlemail.com with ESMTPSA id bb24sm14881555pjb.5.2021.03.29.03.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 03:45:29 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, rdunlap@infradead.org,
        ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: chelsio: fix incorrect kernel-doc comment syntax in file
Date:   Mon, 29 Mar 2021 16:15:14 +0530
Message-Id: <20210329104514.16950-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
The header for drivers/crypto/chelsio/chcr_core.c follows this syntax, but
the content inside does not comply with kernel-doc.

This line was probably not meant for kernel-doc parsing, but is parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * This file is part of the Chelsio T4/T5/T6 Ethernet driver for Linux."

Provide a simple fix by replacing this occurrence with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/crypto/chelsio/chcr_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index f91f9d762a45..f03ef4a23f96 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -1,4 +1,4 @@
-/**
+/*
  * This file is part of the Chelsio T4/T5/T6 Ethernet driver for Linux.
  *
  * Copyright (C) 2011-2016 Chelsio Communications.  All rights reserved.
-- 
2.17.1

