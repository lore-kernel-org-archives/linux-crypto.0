Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8E7C49ED8
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D87522089F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2voJBHY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbfIJPlC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 11:41:02 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:43897 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730875AbfIJPlC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 11:41:02 -0400
Received: by mail-ed1-f46.google.com with SMTP id c19so17512303edy.10
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vqS43DKam5F5nysDjQHcFFlboqfRk3XZATz9UEtOVlU=;
        b=P2voJBHYXAibTlLSLefOUl8RgmlPOQ/L4vQ0diSM19dr80/ejvRTdksmlnJOP/1N0k
         uhZcF4ojppokTxeywvTmlta4/SujPbdNTa8IhT1vEYtGWnMLcT/JucuE4c/YvhUR8Dz4
         25qyraIMzM44J/Wbw2/zEp17QtE/aDmSQqaPXrKg9rPZDiiEg4venrCBPupS5LA40Jrn
         YLb5eBxJlsD0ZdKi00mD/DyL76pLzp1ahsBgnPsJQqJrcYADIzeTAMMqDiBqxwEsIGl1
         Su1YreJJBAWlnLpKhmrpT+DJf2BmAsQbxXOqcEWHe3BDLjmvuId2pp4o9UTlgZlBrm+8
         K5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vqS43DKam5F5nysDjQHcFFlboqfRk3XZATz9UEtOVlU=;
        b=GkNXW9LZic76Bqck855RCwftu/OWrQ4bwS0B1ktk8pCMka+OF92mMWMen/zEfkYwjx
         9HoCykJu98xaDtaOM7DFETrtMpgy9hAznQ17DA8xPtaFIALcXfYcFbZFcP+DwBMjimmL
         YuyaYWfWoRKuJF4QHCuB0K2PHU3qpeLK0KCepKDRwNZSerGmGCAN3r+jZ/6PS4G/76Gm
         XMtZR1t3cLJ/DYNNn6Rba9T4dqftMfo30xHn7JPZ56CHjIpw1ylEooCji9Fo8lshvSti
         4L3K37TeBB236dDgHc3vTfUkyeG13GKAf2uZD12zk5ZqE/wpJMwRAPUKO/NfkHlOrZ2S
         DJkQ==
X-Gm-Message-State: APjAAAUrdOzXKtoYYE1hcCq6fj+nIglfrbUn4hoGyW9bHlqVXOtVwfI3
        TSop+5BgG8hDzA0RfjtQ3CHMvYZl
X-Google-Smtp-Source: APXvYqysLt98i34jiCE35YYDO+EMJTA8zpNN1+2s26rxuFNmSwVy7gRY2jNswRuirtrDmdI13e7XlA==
X-Received: by 2002:aa7:ccc3:: with SMTP id y3mr29984843edt.1.1568130060544;
        Tue, 10 Sep 2019 08:41:00 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w14sm3676014eda.69.2019.09.10.08.40.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 08:40:59 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] crypto: inside-secure: Add support for the Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Date:   Tue, 10 Sep 2019 16:38:11 +0200
Message-Id: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Pascal van Leeuwen (2):
  crypto: inside-secure - Added support for the CHACHA20 skcipher
  crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD

 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |  11 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 335 +++++++++++++++++++++++--
 3 files changed, 335 insertions(+), 14 deletions(-)

-- 
1.8.3.1

