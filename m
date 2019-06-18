Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76942C31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D6D20665
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uPgsvFUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFRG65 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 02:58:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37531 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRG65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 02:58:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so20062755eds.4
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 23:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zh3E3xubLGkRUdITjMlRBtzIYRIkjaVkE4fmvVKnArI=;
        b=uPgsvFUHvmq0dNROJLkoSBFKf+qXgEhF2k0Rc5cvO3edv1c7yeaKG+pzmAgcswtvnT
         hlQTcd0eUNA9NwXxtcWQ1sWl4G6jwLODtGoXp7kDCFbsmEUpr1e3odeuc7sVwqJJedbQ
         e1O4qcCKYE1vn/CuWAES77tkFoEzK7EMoSS0hs2LGCTxWaNM0weuM3ykgv5DmZAY1iei
         u1pmJFz3pVZbv9teo7G7zrv9vpA4Zpme/sDAXNdpFCgQ+XUqRSPfWbTMysNvDoF+xtzE
         RbvXn5iOV1oQpBVanTAyFjIuyoqfTl+k+/zfYqU2PJeyIAlIkWUNMvhupAgJFz8WSAmX
         k82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zh3E3xubLGkRUdITjMlRBtzIYRIkjaVkE4fmvVKnArI=;
        b=JF4uN1JiScqtPKty67wioBskyCcuFlJWPfY3GawL7B45mzTvbgvGdomv0PACm42jqp
         jinHdBlul+Dg3Id8mHbWIEeWnhK/swBCrwp5Ernf521Lyp4Y2z48iHmnWgZTzPHa+/+e
         LyKh8px6fTtNaQoaVqpp76Ni+wpszrI7k1du0WclMoWCfAf8cYRwK/GqucTFDlIx6qJt
         WHZ6XPOnLt7wg5iXF/bPfIdG2fZJrPWmme6OeBqAt6g2sOFdP61j4qPeQe0P5VpwHqnt
         WKRkp4LxHE7utfoMBFYeBom0o+qYK58U7iRX6piWHi3m7TifE6/s3wfFWB298tzwLA0M
         2UKQ==
X-Gm-Message-State: APjAAAXuzcZKC6kFSd+kpWwlTcxudOyL8Fq1cyDqWge7r2BoGDzRrMAv
        iQ7DeMo0LvRW9Uv7aCQuqjtFUxCb
X-Google-Smtp-Source: APXvYqxgpTfJk9GXQAfK1E68WE6Z8MLAth91JU5MuieKuzjiAs4kSomn74H/q33x/DLY/Z1o+gaqvA==
X-Received: by 2002:a17:906:61c3:: with SMTP id t3mr101166819ejl.273.1560841135415;
        Mon, 17 Jun 2019 23:58:55 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id q2sm2602291ejk.46.2019.06.17.23.58.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 23:58:54 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: [PATCH 0/3] crypto: inside-secure - broaden driver scope
Date:   Tue, 18 Jun 2019 07:56:21 +0200
Message-Id: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a first baby step towards making the inside-secure crypto driver
more broadly useful. The current driver only works for Marvell Armada HW
and requires proprietary firmware, only available under NDA from Marvell,
to be installed. This patch set allows the driver to be used with other
hardware and removes the dependence on that proprietary firmware.

Pascal van Leeuwen (3):
  crypto: inside-secure - make driver selectable for non-Marvell
    hardware
  crypto: inside-secure - add support for PCI based FPGA development
    board
  crypto: inside-secure - add support for using the EIP197 without
    firmware images

 drivers/crypto/Kconfig                  |  12 +-
 drivers/crypto/inside-secure/safexcel.c | 710 ++++++++++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |  23 ++
 3 files changed, 562 insertions(+), 183 deletions(-)

-- 
1.8.3.1

