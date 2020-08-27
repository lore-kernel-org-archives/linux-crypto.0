Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBB0C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F2A22B47
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0Goa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:44:30 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:35778 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0Go3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 02:44:29 -0400
Received: by mail-lf1-f52.google.com with SMTP id y26so2338023lfe.2;
        Wed, 26 Aug 2020 23:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hw2dSqOLu8TQUANLy3gyHtGtPAE8XLEwqainP8LxieE=;
        b=sXRagVWLRNZFMx1gNOAD2zg4SEMSKPTKT7lCWxc+oaWIuC64F84MAel9lb2E19vLzv
         ZvnJ9mCqMfWbNhBoh8CaGMt+6w6Q88dtqr7rHYaxXEO3CdJ4Eq+m8cjIaCKGPo33c62l
         5sP6GkzIVmd6MLOuugx9j9fsEKxR5Fnhu+R1r4LaOR9MHw+leluZpSRBjI7L8QCPaQmE
         imimngvK3jpNn0h5Kpb4idL8ly2j0tmUqOPnY0jYqfdRnOqkUeb3QC/+rBkBhLpjH6QX
         GA3RD4f3tWxmSuPBdk4sSJqwPGfqzesrXlBMdY3w0UIEVoiyt/09DF5OyFMvjL8eKcHu
         To1Q==
X-Gm-Message-State: AOAM532OOZq67cFT8/lGOANKF1rqT8mM/3RcV1PNR0rr846Q6Rva17pY
        b9PilydhUZglOHSHmB7aZSUHo+iH590=
X-Google-Smtp-Source: ABdhPJwW0q+iTGAGnMZzhEbm1+lIcsuPPzizgnLmKt6FwmXUlGS+aCDB17AaI9QzU6Ct3Gn27tWvxQ==
X-Received: by 2002:a19:58c:: with SMTP id 134mr9063271lff.215.1598510667284;
        Wed, 26 Aug 2020 23:44:27 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id j17sm282159lfr.32.2020.08.26.23.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:44:26 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] crypto: use kfree_sensitive()
Date:   Thu, 27 Aug 2020 09:43:58 +0300
Message-Id: <20200827064402.7130-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kfree_sensitive() is introduced in commit 453431a54934
("mm, treewide: rename kzfree() to kfree_sensitive()") and uses
memzero_explicit() internally. Thus, we can switch to this API
instead of open-coding memzero_explicit() && kfree().

Changes in v2:
 - if (op->len) check removed

Denis Efremov (4):
  crypto: inside-secure - use kfree_sensitive()
  crypto: amlogic - use kfree_sensitive()
  crypto: sun8i-ce - use kfree_sensitive()
  crypto: sun8i-ss - use kfree_sensitive()

 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c   | 15 +++------------
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c   | 15 +++------------
 drivers/crypto/amlogic/amlogic-gxl-cipher.c       | 10 ++--------
 drivers/crypto/inside-secure/safexcel_hash.c      |  3 +--
 4 files changed, 9 insertions(+), 34 deletions(-)

-- 
2.26.2

