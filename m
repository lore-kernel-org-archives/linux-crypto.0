Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE16C282C5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1470A218A2
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 16:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="kY2soCLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfAXQdx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:33:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37248 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfAXQdx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 11:33:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so7187908wrt.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 08:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x5BNuF/8zRq0d8UI2WInTAD27ZctbQWpU8s33LOAnUk=;
        b=kY2soCLt1iCO/T3lj6QGsy3ZIZur7KCF+0YfRV3cayZTJY/ooIMBttoQHrbCE9MsbA
         5siHHvF3IDHwcPOIlnbgVCmyVRzXdob1b5SChMixleDwR4/LbGa2nR3m1CdlyMuafXEj
         KElqxbQRLDn8tXFh/SzEuK0G6jcK8xYk76Hz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x5BNuF/8zRq0d8UI2WInTAD27ZctbQWpU8s33LOAnUk=;
        b=W+JYnn7WBP15uIDealQe0TG8eBnRFentFioHEHFm/OR4bn1BfGm+34tTfUxHFvGNP1
         UYh/ph/jC6QgorCLpK/Z6Lt/l5m2l8UlZ37sJYE2K6usu1YSDZiDWwIUGfhzoBAZ9shF
         AvfjKA2rge8WifLozcFPiVWiwyVKt5btsGHzSMqlLdh5nh/TtPVKlLydyPLsJ6dPjYdJ
         Mu9wtwOp5EF0DTvBpzBxzhE5y87pONydcmLgsWQw2EIuSlmkjGhKetxarpar4m2yas3D
         KldY4MIQY5eqinBEKFfjZy1QqYDfywjRJ2GnGqvNlLvXB3VMoKhnT9UH3QCiISrs16Zr
         lrWA==
X-Gm-Message-State: AJcUukeN3RpSPYtQNOh6dg6pUmYoife92LQ4iR4iow90iJ+cS/xrUT+8
        4+dFIxW+ZXhgBiM0oEhbAFE+83hSLRdA/A==
X-Google-Smtp-Source: ALg8bN6pbizauB58CgEepGtL2mFqnlGHoJj5IG62QiGAnMh6QQn8zQP0QGbwK9yJ6VEljt67hz9wzw==
X-Received: by 2002:adf:82a4:: with SMTP id 33mr7433179wrc.252.1548347631045;
        Thu, 24 Jan 2019 08:33:51 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id t12sm99629069wrr.65.2019.01.24.08.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:33:50 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/3] crypto: arm64/aes-ccm - various bug fixes
Date:   Thu, 24 Jan 2019 17:33:44 +0100
Message-Id: <20190124163347.12653-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a couple of bugs found by Eric's new testing code, and another
issue found by inspection.

Ard Biesheuvel (3):
  crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
  crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
  crypto: arm64/aes-ccm - don't use an atomic walk needlessly

 arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
 arch/arm64/crypto/aes-ce-ccm-glue.c | 8 +++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.20.1

