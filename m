Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B3DC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B52F20872
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ocOexYDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfIKLlO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40392 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfIKLlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so20325327edm.7
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Pkeop6dZhKzjk48YpKee1uS5qv5P5af6CGLxlzJU2SY=;
        b=ocOexYDHPSAp8M6zabEvpivezpc9pYJfZIVufGYfxC5sKDKTh7DsvMUjtTvCnBmqQO
         IgZ0JpaCFY+cyMlAyitCVc9TWEw5sUx4jmpffjIKQEj3I09RYcBKZoO11E0Jts18uD3/
         uVfnz/Ud24sB8YJ8fVV7pysgMqzL+Gwzgoo+0W/yLa2iHlgPQkK+KH6dBWTfB7Gs24Wz
         CcrS3zxlBp5NhKiu2KwjhYKSDuUEKED3O9hYllkqCer6vvNOYgLZNW3vbon1Q0xq3LVI
         UnSiaQCqvCMBhxQPU+mvCNDvVSwJ7FK62B1qvRBYXW67o7Ishy5vvZ6se3RJQIP8ogbi
         ft0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Pkeop6dZhKzjk48YpKee1uS5qv5P5af6CGLxlzJU2SY=;
        b=tk3L29WvBDJLz0vosqbPe7ejOUC2BuXzknKeouoW43/Iz9WZfsLhGjjlR1g9g3tT8M
         CakHdxqSfPk3xJQVC2ZA+7m3Oh4ARAfkLaraCQOqMF+dqhjP0YTN043ySWyUbjSEBt89
         JfZXG+pCJx9UYp4v0ckC4xQT0mAqj2mK1jK65kSR8y8qhKWFFSnrh6CtM86qV0XnsZPF
         PgGDIDEb7jnhZ9ka86ccAXOIFbUpjP6D7+fgURAjaTjqKHIjAi7k40vAaNfoc9DEyFHd
         C/8q6Wh8FXac+zTxotN568o+L0d70M+Bn7N2OKu0v3KT6UexHErlerTqvI0GGOytiv/3
         o41Q==
X-Gm-Message-State: APjAAAV9bapGIdfzQSI0nBr3C0QnreH0GQGLGIUeIWNEDIy7RUA1kxHq
        2dvBIWmFWDOGkyT1hmI36N9FrHms
X-Google-Smtp-Source: APXvYqzfn+7b39gyCYJotCEs8+KnIhvyP0VDAkCuyjyVLXbz0liCjASuDitW+Ts9LN7/EuFGcnon2Q==
X-Received: by 2002:a05:6402:17eb:: with SMTP id t11mr36205589edy.107.1568202071161;
        Wed, 11 Sep 2019 04:41:11 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:10 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/7] crypto: inside-secure - Add support for SM4 ciphers
Date:   Wed, 11 Sep 2019 12:38:17 +0200
Message-Id: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with ecb(sm4), cbc(sm4), ofb(sm4), cfb(sm4) and
rfc3686(ctr(sm4)) skcipher algorithms.
Also add ofb(sm4), cfb(sm4) and rfc3686(ctr(sm4)) testvectors to testmgr.
The patchset has been tested with the eip197c_iewxkbc configuration
on the Xilinx VCU118 development board, including the crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for (HMAC) SM3" series.
 
Pascal van Leeuwen (7):
  crypto: inside-secure - Add support for the ecb(sm4) skcipher
  crypto: inside-secure - Add support for the cbc(sm4) skcipher
  crypto: inside-secure - Add support for the ofb(sm4) skcipher
  crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4)
    skciphers
  crypto: inside-secure - Add support for the cfb(sm4) skcipher
  crypto: inside-secure - Add support for the rfc3685(ctr(sm4)) skcipher
  crypto: testmgr - Added testvectors for the rfc3686(ctr(sm4)) skcipher

 crypto/testmgr.c                               |  18 ++
 crypto/testmgr.h                               | 127 +++++++++++++
 drivers/crypto/inside-secure/safexcel.c        |   5 +
 drivers/crypto/inside-secure/safexcel.h        |   6 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 249 +++++++++++++++++++++++++
 5 files changed, 405 insertions(+)

-- 
1.8.3.1

