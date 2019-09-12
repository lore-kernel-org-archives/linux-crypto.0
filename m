Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70342C49ED9
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE50206A5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uDsfZ/5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbfILKAi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:00:38 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:43827 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbfILKAi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 06:00:38 -0400
Received: by mail-ed1-f49.google.com with SMTP id c19so23351668edy.10
        for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2019 03:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sGOSBdG/umJfUVJK4C6FF5ybRHZFGEqAA+AcHk2F6ss=;
        b=uDsfZ/5TF4rehFjT8uuDFKsoUTeRt/ssZH9Oirjd8YBiIBYrq7wo1VFGncSMHtRZHI
         TuHGqJzNA+ZCQSxBpKWL0mWF3WVrd3ub/TRWYPWRmlUypPY4zmE0Nvp0R7RHa3uyWW+6
         iC9FIZHJ8afGJ8IZvCnHS60uuNlILXBUT0mJYVC5dCqDf7bWibVYv00HPPd/abBziO8a
         2PaaAAniL9lJ8eF6wBv0krubBzTr8jjJp42vvJ075pCv0p4XkvbCTfhDkRhch0p4UaRR
         AtZUBqQZV3sQhKXz7iOIFp5yia01VHOCHA3GZsevcTncsyUnyI1iWzzBCIo67ep2X54/
         3A7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sGOSBdG/umJfUVJK4C6FF5ybRHZFGEqAA+AcHk2F6ss=;
        b=KWccEZgAU1fLyNGIVJHptbhBvEaiNm5tUgnZijpxFXQa3S3MAX6Qv7wkvxWr+g7fj5
         O2Vh62br2Ej7MW6YFdB8Pw3VPvwPvKUPUuhAmJrnKytVPbaN0grZpmCr/HFVgx5JoMVW
         HTao3zE5mBfOz6nMzEpEDU9ZfMIqQfOFmokqkoKR0gcFmfmzUcfwhohpohNuYRcmuwDV
         PV5lJcRkNZm3EIW2kPMo259P/IPJzb1UOb63XTkgyuz8qFxLEUwkGgCOuSGXebLXT+19
         3PpzeYLBUiJiHTmFnRZzwhGD+L6bnfqMGFpGm9fE67UtyJBuc8gfGh4mz7AUC3m6aE8K
         v0Rw==
X-Gm-Message-State: APjAAAUA1RB/LMdte6cs81s1oOY58CoD3Ln+feRrs8mSBQV38/8R02Tq
        x9sPeCLQLBuVIUeA9LjCS0xEAtaa
X-Google-Smtp-Source: APXvYqwLq/ru7v9QuuWsw1xrH9hy54Tf8YUkUX7YOn5GDVF298wpcG2unCu/oGBjKQFm0Ecgm9UnHQ==
X-Received: by 2002:a05:6402:3ca:: with SMTP id t10mr41342804edw.271.1568282436253;
        Thu, 12 Sep 2019 03:00:36 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r18sm4734705edl.6.2019.09.12.03.00.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:00:35 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 0/2] rypto: inside-secure: Add support for the Chacha20 skcipher and the Chacha20-Poly1305 AEAD suites
Date:   Thu, 12 Sep 2019 10:57:46 +0200
Message-Id: <1568278668-15571-1-git-send-email-pvanleeuwen@verimatrix.com>
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
- incorporated feedback by Antoine Tenart, see individual patches for
  details

Pascal van Leeuwen (2):
  crypto: inside-secure - Added support for the CHACHA20 skcipher
  crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD

 drivers/crypto/inside-secure/safexcel.c        |   3 +
 drivers/crypto/inside-secure/safexcel.h        |  11 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 337 ++++++++++++++++++++++++-
 3 files changed, 339 insertions(+), 12 deletions(-)

-- 
1.8.3.1

