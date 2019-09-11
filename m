Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E589C49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 429CA21479
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhnuxKLx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfIKLq4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:46:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37549 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKLq4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:46:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id r195so3164894wme.2;
        Wed, 11 Sep 2019 04:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhNVqd7lKYTm2RjaGn886HTdC3x02uNTfuifCk7g2lg=;
        b=FhnuxKLxRpgRFJ+2mA6bg+MunVeIvSpIS27r/gVmAIEs2YIck3qeV3LdJymVgReAoW
         3qQmUg9gZ3ELvUrtW/vF7VVxnLEMXEhMAkNTiVuPKMGIEpSgTl7+LhFIKF+h5nv/NsVA
         OBHOl9Zz5vniIrS44Chb76Au9/FynnfzK/8vHRPUw7rYf8jJT/md8yM9P1rRcIfxq7wK
         K7rrqTJ/N1+iLuMf367E90Q8UmfrgjFTZvQ1Px7hkPU4i4O55M6s0P+fK+Kg5oMao1Jf
         XObZ/oe5dTduchmpxopCmlh8+QmHdWkP18Ipcmw/gkon/RD1oR0E5LMJ04+KgSF1i9RT
         wpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhNVqd7lKYTm2RjaGn886HTdC3x02uNTfuifCk7g2lg=;
        b=arIQhqIEhYCnynRNHmjUY6SbQL7WQbvDJ2urd8+JLXTO6ElIgKZsfsqkM1iqdrpTbD
         PuwYlIhN10dP+RpmgyC9dbra4R7k3EPXQfq92Ts/QWzMw4lc4I5z4+Mw9SAP3EjSstmF
         Yw/YnRL/75xvxLC+VADD4XPGEopMmAdXcwQIQbZxDnAc4akbNIned4Ghe207tF2L0mu4
         IWjn/SHKzonMbAwLuqixWeLdI19pCcVfsAwW95SFnkHXuLXZtgNtgI5WD9q13MrTficI
         rY+WWelQ1EE9JI1rtJIaV6rbTcSfUzG6jOLcu5F5Co329U3KuE/8Q8i1fVdZBtzrVZ96
         Knyw==
X-Gm-Message-State: APjAAAVGomoLd5q8PKxzvxJa432xwS3B5Q5rnsmxf8Fu+t7qxpyCNBoM
        Ko5a1wTIeVwnqe7rcmxT/z0=
X-Google-Smtp-Source: APXvYqxCcM+NFG1ZIPUS5eQvXWa05L2llrF+e94UySmKsX6lXGf/8t2UCuJrSW5dkKJ13v5FrT2NmQ==
X-Received: by 2002:a7b:c752:: with SMTP id w18mr3543962wmk.63.1568202414069;
        Wed, 11 Sep 2019 04:46:54 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm4864705wme.6.2019.09.11.04.46.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:46:53 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/2] crypto: sun4i-ss: Enable power management
Date:   Wed, 11 Sep 2019 13:46:48 +0200
Message-Id: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello

This serie enables power management in the sun4i-ss driver.

Regards

Corentin Labbe (2):
  crypto: sun4i-ss: simplify enable/disable of the device
  crypto: sun4i-ss: enable pm_runtime

 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |   5 +
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 115 ++++++++++++++++------
 2 files changed, 88 insertions(+), 32 deletions(-)

-- 
2.21.0

