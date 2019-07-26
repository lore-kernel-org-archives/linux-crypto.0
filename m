Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618C6C76190
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322B821852
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 16:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7GQlmA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGZQDE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 12:03:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33170 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGZQDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 12:03:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so53731344edq.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 09:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9+ftz9aJyIYXKgul41EPGH/pyW//1wrf6eFgc1hpm5o=;
        b=b7GQlmA4i5yGs+kPgrlWQzILyuanII9zrtilgb/dmWH1FhEuJktJ3iAw/4CV7w2Aa1
         gjeaa20BeFwudyOaX0c7R0YXzx3QknmcADWrSbdG2p3S6dXnyCzGg/9/depk6va6QzGE
         TmAHwSb7aaGe6FyrjMVwmn3u4wKJ6Ou8w9az9AHwkLiIOldQloT1wHZeZDp04nSWyYXO
         9gUWHujmtAF7KW3CfLSTFF69o5jYK3D/vu1XtRpqbqOnCpiiqxAF4H8EKkJggqH27Whk
         6NOdNg0trBT54HXbhRaZcxtIdPS1BYi7cFeWllJp5ukFeODHuATqcTSNVLk6cB39W80x
         5TLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9+ftz9aJyIYXKgul41EPGH/pyW//1wrf6eFgc1hpm5o=;
        b=S0RjzENJE1gGg5cDyOoa/IhmbiNPxB0UCfb2QRgeLWOK/foRPB5yolyUJTbiXq02i2
         nUMnPptcyTyKh2K+QGPQArUfxpWH7CuWktOaL+MQ+20OdvS5Z2ZoHrIondABdJ6ZOWnf
         VzBw2C5fQ0g56jo4ttWTfyXbfoQPa0Usx6KQgiWb4JHzaMvmVbmcon46XJPh0bbTnEd6
         QnXsIHABg4DVV6E88LwEri5K5SC7xK2k6Gkj9AK+BgIHHF1Kn/Tc9bTcOxcpp+KUHZ2o
         6icDAg/i0KOefYxRoOPS0208s0JSSjIMtGl7doLURWuWbxyX+0oVWIz74/JoJwPRGUk6
         D6YQ==
X-Gm-Message-State: APjAAAUkA9GF5fUsJueAguOKmI8jukTPXiDAenUZAxgIP77rStbuniJV
        +xiYLRkPcJipHZFHnJpe+wlDVHK8
X-Google-Smtp-Source: APXvYqwrOV7E8zbcClaI9ENHOMuUjiEPVzVhiI51OujL53jQLuR0dKPR76drML1R/pILmVLxtS7awA==
X-Received: by 2002:aa7:c0cf:: with SMTP id j15mr83222715edp.138.1564156981963;
        Fri, 26 Jul 2019 09:03:01 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id y9sm13780258eds.15.2019.07.26.09.03.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 09:03:01 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] Add support for the AES-XTS algorithm
Date:   Fri, 26 Jul 2019 17:00:31 +0200
Message-Id: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds support for the AES-XTS skcipher algorithm.

Pascal van Leeuwen (3):
  crypto: inside-secure - Move static cipher alg & mode settings to init
  crypto: inside-secure - Add support for the AES-XTS algorithm

 drivers/crypto/inside-secure/safexcel.c        |   1 +
 drivers/crypto/inside-secure/safexcel.h        |   2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 360 ++++++++++++++----------
 3 files changed, 212 insertions(+), 151 deletions(-)

--
1.8.3.1
