Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A13C4CECE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 620DC21897
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZafFi4pD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfIQLKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 07:10:54 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:40328 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfIQLKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 07:10:54 -0400
Received: by mail-ed1-f50.google.com with SMTP id v38so2925246edm.7
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 04:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G02LwlPKPynNj/G3BL6DigwM7Y2+le3kWkvKJT0obCE=;
        b=ZafFi4pD+fWMxlkW61Y6fTknoN9qA4UH9k8IrajcsUeefuj1epgig82dXx/7b1OMQf
         FRWdMV+V9qyN5JLZYnHiKo6zB3TxLObCHVCqiPCm2ok3wtGrTiokpW9guI3KySklwfGO
         JZKKgqZg6JCxOluCchYFInPERtr1gdM4L7vEiDxXCuDTgTLv5x1g4WftKd2aelrUbMOn
         sbn9e3F4UBBk8izIhekd75mvNpb7G0bFNyHeFPGN6wicxiUcbbn8qQw8VLvRGS71n3FA
         1j1SKuvFFuWMaRA+91O7syfZFKMIRb9QR5tXEQ781MkFsYgQ2tTpV2dsEw2nbOnsYmqk
         WWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G02LwlPKPynNj/G3BL6DigwM7Y2+le3kWkvKJT0obCE=;
        b=efrLfyDK0JYHaUeT/zAWkVwCHP2iT7pprtUzsEBQ8YkyyWPBN4TUScC5IwivKman8w
         XEt8Tymu48eod0R4KmNEHtfRUAv8OOlUu9ULBRxGkD09NB2kYfKa2ngs9CX9UGDITKmM
         duqGCFIbGs9Gml4vPN4ePuUKcsdPu/0evsANMrNlzO2y3tRFkf/pU2el54m2ER5XLGtt
         3psEr8IdhE1zMHZ+80f87a/6jCAYqp0hthzZhGpP2KbGTT3NHEEqSZuCus24t3OStl0w
         OmpPlMoUYZ7tgtVuDLXOtm83HgWFapqtOosmn/pG+HD6CYb0Tew+xBfr+N9o6GYG1ISY
         oe3Q==
X-Gm-Message-State: APjAAAVYxLPyJf5l3Yiq+UhdiBEI02v0Yk0tT8VtAsyvj9dLowlGOLhc
        Am+tr/LIG5zLv6bXturuib+X/rkZ
X-Google-Smtp-Source: APXvYqz4WmqSm0Sc5XM599VlIFeiiWZBN1Zw6RQ5GgrDDw33My0XE57KKzcYpHK9Epm+bHjJSfHCKQ==
X-Received: by 2002:aa7:df14:: with SMTP id c20mr3993646edy.133.1568718651049;
        Tue, 17 Sep 2019 04:10:51 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a50sm376204eda.25.2019.09.17.04.10.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 04:10:50 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/3] crypto: inside-secure - Add ESP GCM/GMAC/CCM variants
Date:   Tue, 17 Sep 2019 12:07:58 +0200
Message-Id: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for the rfc4106(gcm(aes)), rfc4543(gcm(aes))
and rfc4309(ccm(aes)) ciphersuites intended for IPsec ESP acceleration.

The patchset has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development boardi as well as on the Macchiatobin board,
including the testmgr extra tests.

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for the rfc4106(gcm(aes)) AEAD
  crypto: inside-secure - Added support for the rfc4543(gcm(aes)) "AEAD"
  crypto: inside-secure - Added support for the rfc4309(ccm(aes)) AEAD

 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |   8 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 355 ++++++++++++++++++++-----
 3 files changed, 295 insertions(+), 71 deletions(-)

-- 
1.8.3.1

