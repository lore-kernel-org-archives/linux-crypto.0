Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23C3C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4C91206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7YhQNmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfGaQbr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:31:47 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:44345 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQbr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:31:47 -0400
Received: by mail-ed1-f41.google.com with SMTP id k8so66214764edr.11
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=R9blEA6ZnOMJWvTyIeSRLrLEZW39U0PIeriu862dkv8=;
        b=j7YhQNmIXZeRPeUk4G1mdgr21JHEpr+wqixxGxwxnapUb6yzlwZrQuC7ctCt5oNzJN
         /SrPvZYX4UUD7zIzVYNQjR8h4EnlECX8LOjBmnYKcbp1UfqhPbGzIXQk5YgNg8Gji+NC
         C3I8stR5vzhwIrhXQOlYznVUZTRwVm20gpcFG6UxvIzUBbRoZpyGKqsGX3zMlxhsttbM
         a7Q0+E+yAlByQNYHBY6xzYypCt7/gFa9Fe/tS/Q8M8OTKk40r0Ag0WYexxYtwGqgbvwn
         dPhGbcy/QMkLjc+g6sHsNLlxb933oQj53Ay863/S1++Nv7x6FdkQM+C4BcKk7pGF47QI
         wofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R9blEA6ZnOMJWvTyIeSRLrLEZW39U0PIeriu862dkv8=;
        b=C3KqFiCCPo2A9lwaao7NjAEXMA6mq7mldiA8NYZvPVf8zerIDNUBDOywyYfgAg2gmU
         Ib6+Xg21vT4jMb8mwIUVlAEqZTy8USs+z6MUJTcfduKDcpekHJhQW3pelqYdIfQP9di3
         nT/IBcAcV6jXIp7QDT2PnT+57qfVovMHX29z33opy4Yac6OY0F4HXzSpE5OavOkS3siY
         wWE+qBwX0w4+XDZMcSvOETU0HwwXh2O+nNjyis0HF9DaTTM3NQg+k1mv14bQAXmzsxRr
         AUWK8GeTciy55Kv9ae23mpVNZyNjKivtlUIUNY100ynaAZ328jmug4d9IPvrIIcjfCTK
         HokQ==
X-Gm-Message-State: APjAAAUvy75dANExfaRVI3WEnsmHmHncEIJsyR2qU1YI4UpT9w5bZERh
        B/GSB7QwZ89O6XLcpvWAvHPTjRIU
X-Google-Smtp-Source: APXvYqyeLFV+PXLcMetwUwjzrk2JES288y/lDlXV5aVw03J6UIAaU0/c2f7yrM6NveFhElmNcEy5EA==
X-Received: by 2002:a17:906:2555:: with SMTP id j21mr96829599ejb.231.1564590705458;
        Wed, 31 Jul 2019 09:31:45 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id u6sm6116892ejb.58.2019.07.31.09.31.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:31:44 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 0/4] crypto: inside-secure - broaden driver scope
Date:   Wed, 31 Jul 2019 17:29:15 +0200
Message-Id: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Pascal van Leeuwen (4):
  crypto: inside-secure - make driver selectable for non-Marvell
    hardware
  crypto: inside-secure - Remove redundant algo to engine mapping code
  crypto: inside-secure - add support for PCI based FPGA development
    board
  crypto: inside-secure - add support for using the EIP197 without
    vendor firmware

 drivers/crypto/Kconfig                         |  12 +-
 drivers/crypto/inside-secure/safexcel.c        | 761 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h        |  43 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
 drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
 drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
 6 files changed, 586 insertions(+), 256 deletions(-)

--
1.8.3.1
