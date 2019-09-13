Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D7AC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25651206BB
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVD7vqPn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfIMVHh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 17:07:37 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:41564 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbfIMVHh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 17:07:37 -0400
Received: by mail-ed1-f41.google.com with SMTP id z9so28159976edq.8
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 14:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ld6Eni7isqXX4wWuHzX0y2+Dnh08rzwVUCsCl+PQYtE=;
        b=fVD7vqPndZqwmu75BpvFyj/V5hb3TKO36i2tiN4+BMz9mcLXluVg9WjXaaMX/WYywj
         RwKHpn+TBR5TOQZpaPvfZxPknfD/X+RI5176UI18RxFCneV43aGohIAB7eszA1kP4CyH
         FMLBSRi1GlbFRsLGOl4DM8RU5gH+9MBnkphl5S+tW762dq2ETAoN+yHuDBnnu43mdVEy
         ZrPaJodMnRoIyVj2aGbQi9mK00f2tqITmv4GmeHXpsT9U04p0IDjgXdyp9wNEFshBCrR
         NrLjUEnwuf5Rhm+eByeazus1WRIDJh1y5lLkwupzse3TR4BboXSjbiiOBL5Q1WDOKzRl
         1OKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ld6Eni7isqXX4wWuHzX0y2+Dnh08rzwVUCsCl+PQYtE=;
        b=XUPUQJitHFbNszCGYuALPiqZWzV5HyxHvzH0zczw/cb1EIyCf6RPJ94s0mK8Fih3eR
         1jZfosMM+7cJSs20SENx3QR2b50gNdevl6izkWkVhhl8kBsvnVHXTgLNV4a7M2qu98Qz
         9+2Myf/Dx8Ce72KrdMJUZLz3JrVxLc12LtaxDDQPbKnxJgJR/sIZstkzU7cfBblIIL6C
         wEWUjZaBrpiWp9OUu6U86XVxfycjVHzixNG8tttbqURSOlY8hM6zRWfxvugpB/AYHtPF
         YmYsKvIWyNa8HFdvUYsTmfImQOuSd/HrWE9e9ucHEmdw7q9pw4LW1uyhoJJACksGRpum
         NADA==
X-Gm-Message-State: APjAAAXAzoKLzivQ1EExBsZkVkcDL5TCcGzhd/dZcS8ve0vwVDKcFXBJ
        WoePE9oofvRyJkX8oxbLuQJWCTec
X-Google-Smtp-Source: APXvYqy5ORm+9ZWFiyh6TWv7hDL0ZglzxGWCLvY1M/VsX5X3xmbVBhFGI+1nvBIv9ZTzguL6iNDVhw==
X-Received: by 2002:a17:906:6c7:: with SMTP id v7mr28585384ejb.27.1568408855198;
        Fri, 13 Sep 2019 14:07:35 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e44sm1411296ede.34.2019.09.13.14.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 14:07:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 0/3] crypto: inside-secure - Added more authenc w/ (3)DES
Date:   Fri, 13 Sep 2019 22:04:43 +0200
Message-Id: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds the remaining authencs with DES or 3DES currently
supported with vectors by testmgr.

The patchset has been tested with the eip197c_iewxkbc configuration on the
Xilinx VCU118 development boardi as well as on the Macchiatobin board,
including the testmgr extra tests.

changes since v1:
- rebased on top of DES changes made to cryptodev/master

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
  crypto: inside-secure - Added support for authenc HMAC-SHA2/3DES-CBC
  crypto: inside-secure - Added support for authenc HMAC-SHA2/DES-CBC

 drivers/crypto/inside-secure/safexcel.c        |   9 +
 drivers/crypto/inside-secure/safexcel.h        |   9 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 311 +++++++++++++++++++++++++
 3 files changed, 329 insertions(+)

-- 
1.8.3.1

