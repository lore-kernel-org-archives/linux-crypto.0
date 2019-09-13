Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0881C4CEC7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9DAD20693
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBZW3ywG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfIMLcd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:32:33 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:35768 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfIMLcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 07:32:32 -0400
Received: by mail-ed1-f47.google.com with SMTP id f24so9128210edv.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 04:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4jXuoqHLLAj+F8xudQYYQmdG+c71D5tdod3rPuaN1UQ=;
        b=FBZW3ywGVptOx4QH2a3DVAlgGYAC2Yw4qJsQTjTQGqaD85XNYVzfyfQIIj7M18zy7m
         Y0p4KGOiilbvHURCkDe8hTwb9L5eW8d2K47zX3R9UG3MJsvtIAKowsB73j25TmZxcSxt
         77uN52Ot7iFFjiwMYdfeWV7LuavUwr2LzpNM1oPwGCms/jF6ijr0GO/mzTGP0+ryc8Az
         YSTYP0bLQQWPNlfW+sZ/i2HELxm+OTvCeZFkOGSsvZShpN+Ngogr/ecWtIQBqRZyeHNz
         ANUybREHSk1ADjQeAE28CDvsRotexR+PnGb6KYW0p6ON8kB/Nb2hcGslgMj9tRAwZVti
         vqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4jXuoqHLLAj+F8xudQYYQmdG+c71D5tdod3rPuaN1UQ=;
        b=bdM+tCF7h3ECPu1qEvWbNxHIKKAjinL4Smz+dbcWeE7Ib3tpRjclMmu1iPKLaUN/0u
         jD4VFIWNkRYYciY/1sy5UIZEsiYwNzUuKO+EW+5b5hYCmJvM0E6loNzm0kpDy8m16hb4
         JaAabzKLwwo86Fndce1o8XnDPOaEJWHNIa6p3LvZ63EiHNYTgXjfPyx4uekitZ/p6Z7B
         L3UC74esw9+TEFKgPH/etQtRXA9lDS21ZTJp//YcEY/1hC5yxw9ylc8a0dkp1zt4QgtB
         6nZyZ4pNZ9mLJJF7oCBOFKj4f2EzTelWGWdT0yOZ+3xcpFixj3napLb5GT5+6tnB7xzc
         GoDw==
X-Gm-Message-State: APjAAAX4pgUdZ14FodmFPy0VtxG3YxUuXgsbEHN8OTGFzWJ3tuS/jeWk
        kcLmYL2eXljxGn2kbyYW9lcfUNc+
X-Google-Smtp-Source: APXvYqzHFbvQvTAi3luTA3Kna/tVRrHMG+lEm6LHBy+CL40u7bEm6HuLwvJlCpUHQCAbLNFEWpmy3g==
X-Received: by 2002:a17:906:cf85:: with SMTP id um5mr38177982ejb.186.1568374349284;
        Fri, 13 Sep 2019 04:32:29 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id y25sm173197eju.39.2019.09.13.04.32.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 04:32:28 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] crypto: inside-secure - Add (HMAC) SHA3 support
Date:   Fri, 13 Sep 2019 12:29:31 +0200
Message-Id: <1568370573-3712-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for all flavours of sha3-xxx and hmac(sha3-xxx)
ahash algorithms.

The patchset has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development board, including the testmgr extra tests.

Pascal van Leeuwen (2):
  crypto: inside-secure - Add SHA3 family of basic hash algorithms
  crypto: inside-secure - Add HMAC-SHA3 family of authentication
    algorithms

 drivers/crypto/inside-secure/safexcel.c      |   8 +
 drivers/crypto/inside-secure/safexcel.h      |  13 +
 drivers/crypto/inside-secure/safexcel_hash.c | 790 ++++++++++++++++++++++++++-
 3 files changed, 799 insertions(+), 12 deletions(-)

-- 
1.8.3.1

