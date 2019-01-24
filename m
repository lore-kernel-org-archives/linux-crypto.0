Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CA4C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E34C218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="deKJyZ/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAXS1U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:27:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42595 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAXS1U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 13:27:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id q18so7558880wrx.9
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 10:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7tEGsrVH4vTEegx+XVy42sLNU/2cmGY+71y3NY7A0uE=;
        b=deKJyZ/PaQWeaYi3RvRGdsFL7ARk2z4a/vRsoNRiIsYOWSdnNCM/DBfdAOznhtFOrn
         M8VKD5uklytChfX2Hcb4si2RlbTo3e8w5ml1sQ0qeR0L6AT8xblzlJrYakBclEcmNr09
         Y6SdVkPcSLtwPJaTUa09vPaDO0l/zXjWb34G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7tEGsrVH4vTEegx+XVy42sLNU/2cmGY+71y3NY7A0uE=;
        b=LafZCx7Kt4YRCaPSIwkownLEqogCSFXtpLj9T2cGj9jX9kZbFT7ngBFy0E+QnTHV1O
         xw7GykOT4nFbh1GaSqcCTu6ka+exKZY82W5uWCX+OiAgsYim11IwD/V93iyqnmnGmM0J
         yF1cqDm4SDmzDNmOE8UxEl40b+uPnF1qjI9GPe/Yu3/yTAehSwMkdS7UjQH03xekF+TF
         6olF1/LwCD2hywOCxPIP4PLHbb8g7qdfyWL6BZZxD3rSO6yEYCw0U8chcFy+Oa34HDT9
         KTLnW84OdjyfxshlD4NyzjJpYEes8AIrHQtLJDQSJDh5xXS9X1IiMwQ5C6SUQSyuKCXG
         JKFQ==
X-Gm-Message-State: AJcUukcXs6vu+9rcjYI5ByH8VceY5xyL7EM7y96iuUZXLZDGBQEqLGL3
        a1JxpHLUX/XWlrgRLFHhXfwEq8Qg1KIEmw==
X-Google-Smtp-Source: ALg8bN5vq3ftgSt0a6cgCodNgznETVhQQBwHKAaQZ0kaHcfamIGgBVpnJAfGOFSgFgpvjRrbvjvTEQ==
X-Received: by 2002:adf:8323:: with SMTP id 32mr7986927wrd.176.1548354438289;
        Thu, 24 Jan 2019 10:27:18 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 202sm73247138wmt.8.2019.01.24.10.27.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:27:17 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: fix crct10dif for ARM and arm64
Date:   Thu, 24 Jan 2019 19:27:10 +0100
Message-Id: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the issues in both NEON implementations of the CRC-T10DIF routines,
that were reported by Eric's new testing code.

Ard Biesheuvel (2):
  crypto: arm/crct10dif - revert to C code for short inputs
  crypto: arm64/crct10dif - revert to C code for short inputs

 arch/arm/crypto/crct10dif-ce-core.S   | 20 ++++++++--------
 arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++-------------
 arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++---------------
 3 files changed, 22 insertions(+), 46 deletions(-)

-- 
2.17.1

