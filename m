Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C79CC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704262086D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n47NlMdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbfHFIs6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:48:58 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33593 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbfHFIs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 04:48:58 -0400
Received: by mail-ed1-f53.google.com with SMTP id i11so18087192edq.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 01:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XVCUkJ1Z0CTBeEk4/z5EzWcCX52bucZ5Fq5MKXTsrPI=;
        b=n47NlMdN/sWpqGYZrBjh5jO4pwfbFpxPcAxvgykx0BvoUJYtjsQ4tlW+xor3X6x2/4
         TpuXCQLkSvlFE5ZTQ57WcycNmqvQERUO92jVQ2AY2wqSwgFd7Ftypxsk2J9sHmPFWsdv
         bdEtnWzc/BmAp7al2xrFTzO9OPtkEvuDoHFS0tqtoWZ2DH/ln1R5WnM2NvBjLbry6LZG
         deN48mASRjS/R0yXKXcV6wFMkvdn+RNtBOvH13gYZRzx8Lk0KY+WP/3n4xjw38rtSxXa
         Xe2nh1IhdBYVRK6aD4v+1WSjnRPlFgOVIlr3CwIH+VrWbfLwcMpS5cVuDyjFIzNlWLgQ
         P6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XVCUkJ1Z0CTBeEk4/z5EzWcCX52bucZ5Fq5MKXTsrPI=;
        b=atQuGHL+pYyDh3aMkmCNzRDZRyAm9gfnC70BexBkdVOMkP1Sfcazm2CEwxx815/2rl
         dccgi5SvDfQ5E+x10w4gFC1wpWZNcOWiSYeRQSTwfqpwCsg+WZXgpRY/Qw4yGdCUfm7W
         ZBmK58r3LfDRyE1TZYPcQjKatfnlAsGeI6aBS7CsWn2ur8vCLQDOL+Wu371duypf0JR/
         vtSQ0MFLvJ4ajrq0bdQphFS8cTDNtjdFobKLjqmIEj6MmZW74hBq2e1CamOqVruHjIET
         mRNQP5sNXkIMGNvlYCvgc8IjDgd4bTJ1wN+6zwG+xdae7KumwZA8o4zb7NDLyM6Uu3xD
         AaoA==
X-Gm-Message-State: APjAAAW2nVpwxVW3tFj2QziehgvubULGCwArhO3WPGqD43l9nVwOPppS
        XhjOjAYtcTNUTL4SXx1q1I8yR3f3
X-Google-Smtp-Source: APXvYqxqCbKLR9NfemE9Ho7ghdQK/TuAkU21Phka9khWML1e2LJjhNPMwxXfcRWKE6mcsQCaeoSAjg==
X-Received: by 2002:a50:9177:: with SMTP id f52mr2616841eda.294.1565081335991;
        Tue, 06 Aug 2019 01:48:55 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id f21sm19980304edj.36.2019.08.06.01.48.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 01:48:54 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 0/4] crypto: inside-secure - broaden driver scope
Date:   Tue,  6 Aug 2019 09:46:22 +0200
Message-Id: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Pascal van Leeuwen (4):
  crypto: inside-secure - make driver selectable for non-Marvell
    hardware
  crypto: inside-secure - Remove redundant algo to engine mapping code
  crypto: inside-secure - add support for PCI based FPGA development
    board
  crypto: inside-secure - add support for using the EIP197 without
    vendor firmware

 drivers/crypto/Kconfig                         |  12 +-
 drivers/crypto/inside-secure/safexcel.c        | 744 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h        |  43 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
 drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
 drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
 6 files changed, 573 insertions(+), 252 deletions(-)

--
1.8.3.1
