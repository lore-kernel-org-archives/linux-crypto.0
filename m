Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA34C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C376420665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QfsDv58L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfFXRjU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:39:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40632 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfFXRjU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 13:39:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so177748wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vkM3pzv0qaT9ifNnV69G72X1aA/dSIdngKbA6f9L9fY=;
        b=QfsDv58LbAH8cF3V4G/2L5+c7LJ29FHs0XfEC6n7avNrzdSgDotlJCn10i3fqI/jZc
         ih7K94fQSLld6liaWtuqOw3YwyzQWybXLW3wI6HMqUkS067Kjrk+f4ZyGIFgB5bL6KLc
         B/49i7nsBjlsflmhFrNJxOrEJM3F0tjU6dr/mJP9KtI76og2oSrBG8u4d3In0NdNzTNp
         Hd6ha2Pml7eEDgaVle/FiF5ehhaNUcmOXAiLXyP1yqTk/35kuktOaDLyNppfm9DPHpuq
         Fc/w5Uo8yIlaNU3JGOY4Rr3KRZwYILJ9X1eNmRol62GrYP7jcQS7LCCHBvFYv90+gVJV
         JZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vkM3pzv0qaT9ifNnV69G72X1aA/dSIdngKbA6f9L9fY=;
        b=bhHLYUvXBsyvRJzM02fX+VDKLkJN8tLXF32ibEt9Bkst6IgteZH57v/zWkQ7HgqyfQ
         0Fgjiz400wFvM8Mq5ea32errj4jTxRPTuyiADOqhDj30BU5Wo0Q1AJf/Wq1aZe8sGjTS
         JfjNYS/03ddZ+VpHhxAooQ7TWvF6Z4xdkU6PQErpf/ZdD/5/IlqV5dda7sZlob25yqPI
         rXEc7cVLvfcHNB+y7B7jR5o68vQRdRAfVyukVohX+mF161gzKlWPpe1X/tvzhl0R816d
         r7f2jteG072kqvMsMHrOiNQndYX7JO+SRCaJm4/8+snoZKozHWXsYHgirCjbaAZEOWi9
         AHbg==
X-Gm-Message-State: APjAAAW/YFBzk3NUmYeEsnfJTH4VbfBPe0CQH8ndXGovWjaiJzQ86Cl0
        Y/7rVcFea9pSeJ4Xz9BrScSaAz5uskA=
X-Google-Smtp-Source: APXvYqyElJATRw5v1T9X92K67zCfWlZvGK19xCOXxmhbrcR4RF7NZ+NAjMhs99H6KrkCX+ocbfzPDg==
X-Received: by 2002:a7b:c7c2:: with SMTP id z2mr15780801wmk.147.1561397957796;
        Mon, 24 Jun 2019 10:39:17 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-10-211.w90-88.abo.wanadoo.fr. [90.88.131.211])
        by smtp.gmail.com with ESMTPSA id s10sm260787wmf.8.2019.06.24.10.39.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 10:39:17 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linux-arm-kernel@lists.infradead.org, steve.capper@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: arm64/aes-ce - implement 5-way interleave for some modes
Date:   Mon, 24 Jun 2019 19:38:29 +0200
Message-Id: <20190624173831.8375-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it turns out, even a 4-way interleave is not sufficient to saturate
the ThunderX2 pipeline with AES instructions, so this series implements
5-way interleave for modes that can be modified without running out of
registers to maintain chaining mode state across the encryption operation,
i.e., ECB, CBC-decryption and CTR.

Ard Biesheuvel (2):
  crypto: arm64/aes-ce - add 5 way interleave routines
  crypto: arm64/aes-ce - implement 5 way interleave for ECB, CBC and CTR

 arch/arm64/crypto/aes-ce.S    |  60 ++++++----
 arch/arm64/crypto/aes-modes.S | 118 +++++++++++++++-----
 arch/arm64/crypto/aes-neon.S  |  48 +-------
 3 files changed, 127 insertions(+), 99 deletions(-)

-- 
2.20.1

