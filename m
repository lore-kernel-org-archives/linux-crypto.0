Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C52C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738E820640
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gIAFHTAv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfIRHpb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 03:45:31 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41276 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfIRHpb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 03:45:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so3266070edv.8
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 00:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uBhDxMTSQK8UnHlvPSJo3an4tMDit6CyIfh/LILy62I=;
        b=gIAFHTAvjDpTCyW/0FMsaECQMCRTOMuQK8wBRFeUZfxXI03W6dqcH8Y2A8N0EalYuR
         wVWvkzXkxxWOlUH+O1tqhLxNek3Q95jnGXGTO31RcGoi+sBT1j63kyQBi/GQQYUeUyfN
         XO8eneFu4KEMlEBTGpPp2hSQ2ZkeSRCLdJG+sfhu2dj8sEKDFw3Ei0RfYRukLiZsjH9Q
         KR6woSuQGYYnX+SEjjdE15Cu0iOtRBHYx1QH2r67o7t8LrpxENwEyC6bF/QNEGq3sE7Z
         nUqhdDCNe0AI0+aSoYSo9+V9YVfWkr2CgNZfsvc/AkWVEHNLk7j1FhkphWxNzHKaWOk/
         HZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uBhDxMTSQK8UnHlvPSJo3an4tMDit6CyIfh/LILy62I=;
        b=GrBFMH1xaeXgvjxPJEXn2V+4DgGldROJ/39uYMAEqSXIzWsIrXmDBttnHWPZKOdctv
         sBL0xrp9VK5/sXrEE9Es4elIfHCuPKejUPXJNCDqCc17wrWqYpQmfs8wGhJWLg4Wuxqr
         4S5p/FhbWooFgw0tjxTfL/sb2theAzZJEuqG+oBjc4oDWEF4r5xZAY42fPFCRD78yk26
         rt8zMmRB6oGQ0xRoCEG9nFuT0JUmN7JfoRdFAcZrsgaUiY/cXbeZOkA08O8GM51HpDH+
         vo37yZx/3wRsJSrlhvxpqZ6B8J2JrWa92pWT2pXFOvQ2feXG+VeJkg+C67f6feCCtUy4
         GlrA==
X-Gm-Message-State: APjAAAXHK/HSsnRLkfOySOLnQFzuYuvGB41JLfaTp/bOnY4+l+CtPFjR
        KFxnstJofMrsWVEInxOW4yTEkPjm
X-Google-Smtp-Source: APXvYqxd/v7qPrgbYlsJK3ypEv44rSshFEaY/jrhWt05K/m7w2c1MQKbiE4Z74btg+pFCKY/ATFYgw==
X-Received: by 2002:a50:e79b:: with SMTP id b27mr8850653edn.186.1568792729748;
        Wed, 18 Sep 2019 00:45:29 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id hh11sm18332ejb.33.2019.09.18.00.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 00:45:29 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] crypto: inside-secure - Add support for eip197f_iewc 
Date:   Wed, 18 Sep 2019 08:42:38 +0200
Message-Id: <1568788960-7829-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset adds support for the eip197f_iewc configuration that is
currently being taped-out by a customer. It adds support for the 256 bit
internal buswidth used by larger EIP197's as well as support for having
less ring interrupt controllers than rings.

The patchset has been tested with the eip197f_iewc_w8 and eip197c_iewxkbc
configurations on the Xilinx VCU118 development board as well as on the
Macchiatobin board (Marvell A8K/eip197b_ieswx), including the crypto extra
tests.

Pascal van Leeuwen (2):
  crypto: inside-secure - Add support for 256 bit wide internal bus
  crypto: inside-secure - Add support for HW with less ring AIC's than
    rings

 drivers/crypto/inside-secure/safexcel.c      | 119 ++++++++++++++++-----------
 drivers/crypto/inside-secure/safexcel.h      |  22 +++--
 drivers/crypto/inside-secure/safexcel_ring.c |   4 +-
 3 files changed, 91 insertions(+), 54 deletions(-)

-- 
1.8.3.1

