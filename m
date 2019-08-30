Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB8AC3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1032F23697
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhjNfZ4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfH3IzQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:55:16 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:37924 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfH3IzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:55:16 -0400
Received: by mail-ed1-f49.google.com with SMTP id r12so7174396edo.5
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=q70kb/FQc40VKkQXTcHwccMBpuh/vePFpMrVfCxVO2A=;
        b=fhjNfZ4pel/rCAjMK8mK0gSjwytKT+YoW1PtKcgEUQo9jYSopBuxG8uBtaRLKP56pc
         WYDjSRn73t7Bkh4aK0P2+My0C4j6qfuM8Ns6Aj2CRRc94AJoZYBF+2TETjueAsvKlPCR
         GpWMuCu+14jr2HMjYajA33a0VVRU7HOc7iH/L6wFcE8JgXVVr7wDNq8u8xLPWlgVTl1z
         tHZb/wV35KvV0LR2qo3vOmI1sOSFAv+gQFEG6HOV04lw3WZbKWnfNvu7FPCFhqgRR2N0
         lQKx5DUFUlK42jvwyKUQclBzCMjP5m8E0XSN26GifJw0yUm8kmkUIO1iYy6cGI8BJ8Vr
         /mNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q70kb/FQc40VKkQXTcHwccMBpuh/vePFpMrVfCxVO2A=;
        b=AbM4zBz7M4liQosUz3BdI4RyiUhhp+IECzRst8bBamzEQPbCq3EZVaPFWsTvpFapzx
         lMZFJlKgWHVbas2VrE4AP/rIWxQo98I8Vtq73VoJ6pYazrmUucL+Tnh1jTIDnJQE3kPd
         FGuTTCvdG+c9i8RQCfwmQ/35YUMolkTgrI5caFBkpIxjE9JDqVTzA8PUcTP0fkwv5FSj
         3cOxNO1V3ipa5MTA4cMcsRblnoUMNHYMEcjlRusZKx1i9DVN9SsHfksGcUqqWOSpaQP+
         yJ5fEbX1tBifRwi4UT+uc6XuBW/r34bZGYAX4q/N2mKgfSujk83sQJ3xh5Me8N4U4xkH
         UaCg==
X-Gm-Message-State: APjAAAX6FBWat0dl4LKOVUjGZ4HC4vm6msLrRVInKUWmMqZlc4a6b7TW
        NILR5w4TotROJUh5V5YfXe5aWNDr
X-Google-Smtp-Source: APXvYqwdyiiLclKxfz5VsDGi39e1DeGc9REZbic4tFgwOiINff3ia0bXmW5OU+YK70LJC43pXkpoQw==
X-Received: by 2002:aa7:d40d:: with SMTP id z13mr881104edq.229.1567155314130;
        Fri, 30 Aug 2019 01:55:14 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id l9sm335610eda.51.2019.08.30.01.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:55:13 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/4] Add support for AES-GCM, AES-CFB, AES-OFB and AES-CCM
Date:   Fri, 30 Aug 2019 09:52:29 +0200
Message-Id: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for the AES-GCM and AES-CCM AEAD ciphersuites
and the AES-CFB and AES-OFB feedback modes for AES.

Pascal van Leeuwen (4):
  crypto: inside-secure - Added support for basic AES-GCM
  crypto: inside-secure - Added AES-CFB support
  crypto: inside-secure - Added AES-OFB support
  crypto: inside-secure - Added support for basic AES-CCM

 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |  19 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 508 ++++++++++++++++++++++---
 drivers/crypto/inside-secure/safexcel_ring.c   |   8 +-
 4 files changed, 488 insertions(+), 51 deletions(-)

-- 
1.8.3.1

