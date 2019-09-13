Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F354C4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B89920830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5iC8uEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfIMSnx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 14:43:53 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:34295 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfIMSnx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 14:43:53 -0400
Received: by mail-ed1-f48.google.com with SMTP id c20so18880202eds.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 11:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4wVQB7CGzAsUOQ2n0r/M7x6akAc2Sm7bZ12ZX0CRORw=;
        b=i5iC8uEWdS17FeGD7D1mAo3KGLAG7a6dTT95GdedqUvaSf6BtLQc5WYHHhAdoaFBEc
         IOsSYtC7apJLwNATxt7VgtsUG9oxZc5yT5MN7DGy49XuEHoQj8KG2U0EOQjDDDPDDYD7
         dWRWkCgt8AfiJCgFWURYM6aQml+onSeSxplHxeM7kjzkxApcW+HlqCWuuQxcPhN/Dl6h
         tg8QmBBV5OoGrjB73dNWipNAnvVT6YzIluuBc4nUn70Eo+j5fpT6J++vDJWpYnvFm3R3
         kGwL5JGmnTERtvWq5t5sGsVO93mfsTh5PK7W49xm6B0cBvQKVOqNUSc7fvs1zJTB5i/d
         QY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4wVQB7CGzAsUOQ2n0r/M7x6akAc2Sm7bZ12ZX0CRORw=;
        b=r5syQzHexJFnaX/3+wECA//WzvWXDFyRiba70AUNqz+3cd1DebObNqkV8cI3PAgrcm
         Sp6teEpIRv3M1iyac0ZTDwgGt5icWNFBRaa933kj3lmfW3vsOnj+wA1DeQSYaAXXgwS7
         vqxdc5+6zDKXLw6PR5OEXAOSuwZZE0/W/dM4H3SEubAx/iPQjmcos6A3zW0UfRu9spxZ
         tRjeoshYKTjZNKBigS3KW24UmDpyQwDWswEJGrUXYejfktp0nmqygZzO3Qk+lyI2WjM1
         hnUuks/ZFgq5/41poCtpPe4or7oN5CAxhgH1kDD76RLcBAsOZGQsSzmBU9UXX4lOmutP
         ysaA==
X-Gm-Message-State: APjAAAVcYU94MsT/4X+6JpAAbZgS2WYGvoMpTC5BJESrXwD849xLTjSj
        T2qDCH5q0ci8iSEa/3YN+zwrZYCQ
X-Google-Smtp-Source: APXvYqxChckr0vlVWmg/W9saMHvLogW+GWoo+seyqaZNPjZ1SQo66zo6IFypwO2IfoeLt3Q6TiEIiA==
X-Received: by 2002:a17:906:139b:: with SMTP id f27mr41216522ejc.273.1568400231314;
        Fri, 13 Sep 2019 11:43:51 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id 16sm2416225ejz.52.2019.09.13.11.43.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 11:43:50 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 0/3] crypto: inside-secure: Add support for the Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Date:   Fri, 13 Sep 2019 19:40:59 +0200
Message-Id: <1568396462-20245-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend driver support with chacha20, rfc7539(chacha20,poly1305) and
rfc7539esp(chacha20,poly1305) ciphers.
The patchset has been tested with the eip197c_iesb and eip197c_iewxkbc
configurations on the Xilinx VCU118 development board, including the
crypto extra tests.

Note that this patchset applies on top of the earlier submitted
"Add support for the CBCMAC" series.

changes since v1:
- rebased on top of DES library changes done on cryptodev/master
- fixed crypto/Kconfig so that generic fallback is compiled as well

Pascal van Leeuwen (3):
  crypto: inside-secure - Added support for the CHACHA20 skcipher
  crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
  crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL

 drivers/crypto/Kconfig                         |   3 +-
 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |  11 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 335 +++++++++++++++++++++++--
 4 files changed, 337 insertions(+), 15 deletions(-)

-- 
1.8.3.1

