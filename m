Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15738C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 19:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE452603E5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 19:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhIJTCh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 15:02:37 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33522
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232196AbhIJTCh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 15:02:37 -0400
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DFD114025A
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631300484;
        bh=MBtluqNukPdcEGpdwgvbXPFv3pY+sw4KVloaomnNcZg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Ndlus/ACQ9A4PJmfwqz0t9gNSpEjWNMjUkkJUjh/qKJ02PHBhbq6vxzbonF7YOPLI
         64T3jkk2jeyv00Nk2yWjS8DQpsIWXNB2YxaTt5qCTeZTTwmFkxpRgH5med7+2sOIji
         KbGvzDxG/t9Nn2ksrJxINJvzf6aJSZduUR1yb+qSZLxdaTNK6RcXLKpI3m5QhtixjJ
         sP4vBV9/A7A0lqzDCgiPxXv2L7Z988ia3n2f71pYIsp1Jsv0TxYKH2DjtqPtUsBL+Y
         D0rDUnJ6SrK8yBgOvYyS0HX+lT8XOR8KJMx+k70Bwz4FX6JF39G085Q1OGJmUsru4i
         OcQK+wr3n99Zw==
Received: by mail-pj1-f69.google.com with SMTP id oo3-20020a17090b1c8300b00197449f1879so2348068pjb.9
        for <linux-crypto@vger.kernel.org>; Fri, 10 Sep 2021 12:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBtluqNukPdcEGpdwgvbXPFv3pY+sw4KVloaomnNcZg=;
        b=4qsas7wvGWfvNW4LtlMOhbZfoAwG0XPfc2gxiZfat2aNVmzmIVKQKaqhiyikulBVyJ
         rIjZi8QD4UuOWbhWWuZD9pYUrjzEppWfeGKcZ49/YPUBlGsUHeURoFs1JwgHmqf93OWX
         k6U+bqhz6kLoa8sdkvvhbcZIJQ37z5kx8Ym12RpX0ZlN0CqWnPzPX2A7rtyiwol1Ut4Q
         ffkVdHTB01NbFwsJP7zxcmp6hkH+8IyzrwFMpGavBle7cMkUUSuXSXI9c6+GLOxQLpF8
         qOYP7SLAc4jSxzRflh2VBP6edJrDDQ1xhdAGsb/zGz0Bn7qcnGqpxpJ5wYhtMcre7KZB
         HScg==
X-Gm-Message-State: AOAM5335bNUMOVsRoQHiYaAaYMjluk5BiZithqtYEAuXUofzsk4FlllZ
        TyLEwFbngcgsjt5V0w61kB4aWdrCp4muxTmLOy/dQmo8DTQBGc6QNlBOSyPbXbNNYIKsWBCrK3B
        PrG2pp/1N8nUbkR7+l4XuBbXg179Kqn+QmHR0L0UPVw==
X-Received: by 2002:a63:68a:: with SMTP id 132mr8612400pgg.154.1631300482703;
        Fri, 10 Sep 2021 12:01:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgNV/BhWRskvi5hTjkSPzv93WPvsAkhP+1MjE4wfxOgQjdY3eWlCNEVCpeLprlPYvbtvEEMQ==
X-Received: by 2002:a63:68a:: with SMTP id 132mr8612363pgg.154.1631300482138;
        Fri, 10 Sep 2021 12:01:22 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id t23sm5377869pjs.16.2021.09.10.12.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:01:21 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     linux-crypto@vger.kernel.org
Cc:     tim.gardner@canonical.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: drbg - Fix unused value warning in drbg_healthcheck_sanity()
Date:   Fri, 10 Sep 2021 13:01:17 -0600
Message-Id: <20210910190117.24882-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Coverity warns uf an unused value:

CID 44865 (#2 of 2): Unused value (UNUSED_VALUE)
assigned_value: Assigning value -14 to ret here, but that stored value is
overwritten before it can be used.
2006        int ret = -EFAULT;
...
value_overwrite: Overwriting previous write to ret with value from drbg_seed(drbg, &addtl, false).
2052        ret = drbg_seed(drbg, &addtl, false);

Fix this by removing the variable initializer.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ea85d4a0fe9e..f72f340a1321 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2003,7 +2003,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
-	int ret = -EFAULT;
+	int ret;
 	int rc = -EFAULT;
 	bool pr = false;
 	int coreref = 0;
-- 
2.33.0

