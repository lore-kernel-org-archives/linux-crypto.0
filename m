Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE3FC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0939205C9
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V7H+RYyN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfG3O3j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:29:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40707 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfG3O3j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:29:39 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so62740518eds.7
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 07:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4MaWkojMUXWW8dcYwarCOf3vqnqX3vki13az5Y1B+1A=;
        b=V7H+RYyNObj5sA53BTikvVD1gNh7F/iwtAr+nGovxTXBSaQrwWyxV+AlFMUwrZQCeE
         gb1tzHw7mHtinfz9Xmdg1HPPQq0wECrqFxMoCblJlt+XZptDq9mJv6XxXMBRUA1I3js3
         E+FyhLyPiOKhjEAXL9EE7D58LspeD6EThgIvtEJMKjyaamBFk6gqruAP4YiUn4fVUVIN
         uEPyitm5IFxnjso0QIfIBp9gsMUyhIfplHADoCFQfLOs+ixrFtFsz0CvgGe9lI990ymH
         q4MuNXAr8DMACfqesCpPy9WOf9RZhaVM+YM1yO2TtC21zPdjGhjyP1o29thFhFe3uzzQ
         AoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4MaWkojMUXWW8dcYwarCOf3vqnqX3vki13az5Y1B+1A=;
        b=tX7DRKiznXATjAxl8ySp/TidKN8qlWbnHeBrytMn6lRk3roIPWhIkCe9BWfckZ3g8y
         0qiR5Ebrk0dQD6EMbBOneiH8ZD3MwEDFN4pUAvAJE1FwrqOWYNJMHRS8q+zIwHO5q9NM
         nhFNGMru+GEGHwBbrxZMmXc/8yKJ11RoEzMq9NNaorMsGBeuO9VEWSKnBlEPGWY5riXF
         9XiJSTIz5HziTlnqFfWqE3FoVEk30KPCzYSMW7xVHr+PAsjphFcO8WJOd1gKUIXUlRDF
         z/h6twfe5Ob066Y1oCjJqIxttC5DR2/HwUhYxCUHKE4PiCEL+l/X1bgdi/ZJcKBOXfMF
         cmAA==
X-Gm-Message-State: APjAAAV8xRncSraq6kOeCnnTMvQkdWlnmKv3XBUyU8X7KeVdEnxSzrtR
        U0C6UIWsN/DxoSHmTN3LgzSx7Rbg
X-Google-Smtp-Source: APXvYqzpx2XArVrK7e4u+OxQ5wfLqLI2U+rjdY8rhsdtVhaNLjl4BeWCIHFDSLAPvxit0WDZDOIIFQ==
X-Received: by 2002:a50:9729:: with SMTP id c38mr104623071edb.283.1564496977746;
        Tue, 30 Jul 2019 07:29:37 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e29sm15240776eda.51.2019.07.30.07.29.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:29:37 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] crypto: inside-secure - Cosmetic fixes for readability 
Date:   Tue, 30 Jul 2019 15:27:10 +0200
Message-Id: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set replaces some hard constants with appropriate defines from
the crypto header files and fixes a comment mistake.

Pascal van Leeuwen (2):
  crypto: inside-secure - Use defines instead of some constants
    (cosmetic)
  crypto: inside-secure: This fixes a mistake in a comment for XTS

 drivers/crypto/inside-secure/safexcel_cipher.c | 37 ++++++++++++++------------
 1 file changed, 20 insertions(+), 17 deletions(-)

-- 
1.8.3.1

