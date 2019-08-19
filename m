Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBEC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6D0206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rimp5jtB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfHSPnH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:43:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45253 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfHSPnH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 11:43:07 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so2071633eda.12
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 08:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/YxVQpt66oI46bK31mzAudDto4eLI1VWxYNyrUQPcgI=;
        b=Rimp5jtBEGZzo8WKJXRk6xbwK5y061uTMYELFIt7b2pPRuX3YXLKGJbG0QQPW+jfFP
         CzOkOlVufS0rTL0EfpcSFIuYQuUfhsaYk6geuGMiRW7OT6UyXM5/izFDSe9QBRqz5AXB
         Sbm4LjGMtAlqUwDtIb19HMPr7NXo1QzChS6+X654Zyk2CfPD1no5URvgsmNp+yzMdOmo
         ajs5NHM8Jaads14b5RFJyuMihDMWl+XgByEMvyeUbWgXO9LagN646kt9XDwVMgYJhsmb
         UWjcKHJXf2FisAT8+kBBLr+8sM4y04B2gV3Luc8E9GLp/eM1drC8RbCT6U/hTxeYv7qZ
         mMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/YxVQpt66oI46bK31mzAudDto4eLI1VWxYNyrUQPcgI=;
        b=PhxGrjxt7UyNc5KcIkyKOyRYbHi71y27Npo20cFbeVqr+beZzvWGLoJrygaUtSu/hn
         UEmxzFOlwBx0ztmpsTYyV45NhziGiZymOArhJ7AUP4TUwa1JRELJGlfwPadWOt+O5ns/
         El2BkmHGf5fMOfE2eCoMeWs7PRrZvKmu6tUUsBXQtiy9BID59Q+6k7dmZ8pYvi9jnDu6
         kMje8NHnTU7jhD1gtU9wogfxFrUmwfmoSlLVLW46Q85+ZeGqPIvCYO7KOukPm+iBJTFp
         vMc1paez+wqj0UMiSMJhtDpwakG8sWN6XViGjYgdm2TjEUdgDn2vFdXYwsGcad6wPlRx
         34wA==
X-Gm-Message-State: APjAAAWqvyobrWRrKAatmz0mnl2Rxvtwibkl4fWq5Fh8+b56pnIsCZL5
        XkNUY7att0xsHZYm/9352b1RH1vo
X-Google-Smtp-Source: APXvYqyfqGpMXWOpkJ59fcDwSIn3iQ8sCT7oWdoMjYgn0Y5M2FpkEENA8Jb314suxiHjb6SEvHHzAg==
X-Received: by 2002:a17:906:af4b:: with SMTP id ly11mr21562497ejb.309.1566229385328;
        Mon, 19 Aug 2019 08:43:05 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h10sm2891095edh.64.2019.08.19.08.43.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:43:04 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv5 0/4] crypto: inside-secure - broaden driver scope
Date:   Mon, 19 Aug 2019 16:40:22 +0200
Message-Id: <1566225626-10091-1-git-send-email-pvanleeuwen@verimatrix.com>
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

changes since v1:
- changed dev_info's into dev_dbg to reduce normal verbosity
- terminate all message strings with \n
- use priv->version field strictly to enumerate device context
- fixed some code & comment style issues
- removed EIP97/197 references from messages
- use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
- use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
- do not inline the minifw but read it from /lib/firmware instead

changes since v2:
- split off removal of alg to engine mapping code into separate patch
- replaced some constants with nice defines
- added missing \n to some error messages
- removed some redundant parenthesis
- aligned some #if's properly
- added some comments to clarify code
- report error on FW load for unknown HW instead of loading EIP197B FW
- use readl_relaxed() instead of readl() + cpu_relax() in polling loop
- merged patch "fix null ptr dereference on rmmod for macchiatobin" here
- merged patch "removed unused struct entry"

changes since v3:
- reverted comment style from generic back to network
- changed prefix "crypto_is_" to "safexcel_" for consistency

changes since v4:
- rebased so it applies on the latest state of cryptodev
- fixed typo in safexcel.c that caused FW download fail on Macchiatobin

Pascal van Leeuwen (4):
  crypto: inside-secure - make driver selectable for non-Marvell
    hardware
  crypto: inside-secure - Remove redundant algo to engine mapping code
  crypto: inside-secure - add support for PCI based FPGA development
    board
  crypto: inside-secure - add support for using the EIP197 without
    vendor firmware

 drivers/crypto/Kconfig                         |  12 +-
 drivers/crypto/inside-secure/safexcel.c        | 740 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h        |  43 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
 drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
 drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
 6 files changed, 571 insertions(+), 250 deletions(-)

--
1.8.3.1
