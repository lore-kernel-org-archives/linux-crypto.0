Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D71DC4CEC8
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED3B206BB
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 19:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npT4aJVl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfIMT7m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:59:42 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:37201 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfIMT7l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 15:59:41 -0400
Received: by mail-ed1-f49.google.com with SMTP id i1so28092145edv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 12:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XGTR5Ec53DCcPDh5TVDKp357ZpeJLkBmqKxsAlB1WQY=;
        b=npT4aJVlDoy2XvzF4/wIzfmMitPHbiSsInhB7eg/yfhkX8cBp9PWTYXor1LomY5Bpv
         SKXsx/sh/M3Urdoazfa8Vow+Dr03gaaaVwyaBhM8gH8ExZtfW3cQ0NY7Mw7EjsPTzMR7
         QhuvFhLBHZxiEWK+pHgihpY1Djv3WZtxWh9MxBj+MK7nd6FN8Itb2KAy93kafjFKIEEY
         XCwaYVHwHg0S0bmtNRMXHDRal2L9ay81FWq6On+0PwCMWHsC3c4T3J8qt14zn/7qUfrC
         QbcECsXh8M6+25pIF5Zj/110OQ3hs5HSFh379JQw4BScC+z4J6Uu79P/QGDY30v3bAEg
         Fkjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XGTR5Ec53DCcPDh5TVDKp357ZpeJLkBmqKxsAlB1WQY=;
        b=pBc519h7xYBcZx5baGk780taN1ktss2yEmtYEZpjPAA/Lf9TimKIr2s4Sj36vB/QFS
         56faX7disua/Feu2bInZ/uf1fipm0qh5TUgpTh4r/6U07T/mRcHGXANQvnWgi+u/1IrX
         OajYVVbn1Up9m9YezXti+8nChFE4QO35cHr5y2FV7JdYhhzzXoyk3QwbEtJLWZjKkSgO
         6DXhmc8M108I1aDZiMNBZNH1Oo7SRJfrojsoN7040sMnGkjOHHU9gMf+GyS7eealgc/e
         mHB6FKAckBx8TsxlxuYicxo5d8b7oCg/tozxB4glRyBIKmC9I7Nl0d+0Cj/EQuJJVJvj
         Exww==
X-Gm-Message-State: APjAAAX9mcVNA8G05emkSp1ul5sOARxN7mayTYzqhoIISRdT13gnAc70
        6VjQTP5ExIyH5sagS45Q7E9Iyaa3
X-Google-Smtp-Source: APXvYqw/zcnVq3OViZfdedgUo40XiJQinCvbGZbcj3nmK5Zp2ESELcLzUxjVbusCQttBwk6d2E/mXw==
X-Received: by 2002:a17:906:c7d0:: with SMTP id dc16mr40695361ejb.30.1568404779833;
        Fri, 13 Sep 2019 12:59:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a50sm4592579eda.25.2019.09.13.12.59.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:59:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/3] crypto: Kconfig - Add CRYPTO_SHA3 to CRYPTO_DEV_SAFEXCEL
Date:   Fri, 13 Sep 2019 20:56:49 +0200
Message-Id: <1568401009-29762-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568401009-29762-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568401009-29762-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the addition of SHA3 and HMAC-SHA3 support to the inside-secure
driver, it now depends on CRYPTO_SHA3. Added reference.

changes since v1:
- added missing dependency to crypto/Kconfig

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2ed1a2b..1e61239 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -729,6 +729,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_CHACHA20POLY1305
+	select CRYPTO_SHA3
 	help
 	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
 	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
-- 
1.8.3.1

