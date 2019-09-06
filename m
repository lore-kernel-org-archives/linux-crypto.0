Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D451C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09C920842
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUgKYHUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394869AbfIFPek (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:40 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39246 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394867AbfIFPek (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:40 -0400
Received: by mail-ed1-f67.google.com with SMTP id u6so6675609edq.6
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xmXgq4sTfpXoiBb6saXtkSOp4XFa2LPidX0QNz07xD8=;
        b=iUgKYHUN7mISPWWHLFNkyLSFVqr4MGUofIPb0eHptlnWpBneUD4s5t9Ri9mWKyhqFC
         +tsW7DXR5HCx4mtcC8fhEZgkhJPTVub4KiPII8IDG5MXivgS7jUz34qXcDkdmt8pUarO
         QBmFEkT+g4CpUJ8KGVRMs2yJLvr0Klo7JUBXdvIIfBZyUC5Nauv9mT9Di5G1c6vHkaVP
         kVnTk8ghTyemJEYcOcA6ZF3Za7M3CVAUncBKRu1EfCkeoLbUHW7QXWIz/4AmNtFFvf0t
         //KH73CwMLVqlY5aR2vLVWkXCdJ1D0QwRAi31zN52EA7xH3pKXkYz6drMG4LkAl8Q1yH
         R/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xmXgq4sTfpXoiBb6saXtkSOp4XFa2LPidX0QNz07xD8=;
        b=GwvJA6Ni/np4qB0WLSXyJ1kljXentY/b/sNWm/l8K7cV6szZbzb5qIvIicZ0cYdnLf
         392CAgH7PbQcqfi82eJSwtnQxB+lc2YwpwmRyWBCk532eMLcUWOx8hhOLicnRC7vquM/
         S+M8RtxOHmZTaFKC3Ga/l/XH5P1EjEv/gkVuOHQqIx82lQUAjOkwxgwHOjVslYosVQzA
         9vcfU4kjBK9Mqy6JoEGPS3lBeyl7jwfRP6/AFrLWRZoTHC5ZR2kL4dF76kp7S6Ug5oT7
         BsnT9zBn3NF1I1RTc2dIgsvnJuBDy4rcFtXLFCFlyUuGA3XsuQAsIfNMYMoSq+4EjIlN
         p9mA==
X-Gm-Message-State: APjAAAUnVNeOJuMri93MuNHZhszWu+XMR6+ojQTmkzkNdEMesJmm8HBJ
        Cj52SZOwTMMmFAyocGM5C1lKb5fF
X-Google-Smtp-Source: APXvYqzra5/wH5xVifr7zbtxenuYis8H66z3x2OPddQxspA5grDsh4ZykulCzWHmLpt9x57oChKe6A==
X-Received: by 2002:a50:9e65:: with SMTP id z92mr10227990ede.49.1567784078751;
        Fri, 06 Sep 2019 08:34:38 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:38 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/6] crypto: inside-secure - Add supp. for non-Marvell HW
Date:   Fri,  6 Sep 2019 16:31:47 +0200
Message-Id: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for non-Marvell hardware, probing the HW
configuration directly from the HW itself instead of making assumptions
based on specific Marvell instances and applying appropriate settings.
This should get most EIP97/EIP197 instances out there up and running,
albeit not always with optimal settings yet.

Still to be done:
- support for EIP197 HW with 256 bit internal bus width
- optimize settings for newer versions of the HW

This was tested with both the Macchiatobin board, "similar to Marvell"
HW on the Xilinx VCU118 devboard and a eip197c-iesb HW3.1 on the Xilinx 
VCU118 devboard.

Pascal van Leeuwen (6):
  crypto: inside-secure - Add EIP97/EIP197 and endianness detection
  crypto: inside-secure: Corrected configuration of EIP96_TOKEN_CTRL
  crypto: inside-secure - Enable extended algorithms on newer HW
  crypto: inside-secure - Base CD fetchcount on actual CD FIFO size
  crypto: inside-secure - Base RD fetchcount on actual RD FIFO size
  crypto: inside-secure - Probe transform record cache RAM sizes

 drivers/crypto/inside-secure/safexcel.c | 459 ++++++++++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |  78 ++++--
 2 files changed, 418 insertions(+), 119 deletions(-)

-- 
1.8.3.1

