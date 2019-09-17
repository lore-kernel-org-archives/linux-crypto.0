Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8672C4CECD
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CBFD21881
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmAA+iKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfIQK6M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 06:58:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36482 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfIQK6L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 06:58:11 -0400
Received: by mail-ed1-f67.google.com with SMTP id f2so2917490edw.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 03:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cP2LPFmLh3GNI8yVGWwIXDObCOn2NdEu2bxRoo7ljoA=;
        b=LmAA+iKj0C0oeocUxTZ+0qqPHs74wA27ChkXDgIvPbE8/pvzfdjdOJ+ErcbniwFC5U
         AC2qyZ43Uh2Gs8O0EgV2t5L3Neko43H8/Z07Ng1MNyDkDAc+IxfEvW4sIG3uf7pbmnIp
         QpXHCTw1IXSkQavbvADZV67SrunMZyx/igPFLXUHnTs7iO729j/6h5izgdzmffnq7a2k
         lpabCp0eB4yt6+YibEqjyW85+kYFamllThUuLPwF+swDLwm/BD8KYM1680gdbULg0DdL
         1R1esYWud3qH+C5oY/Qvo86HU2aAX7pXKUAle0RhShlgMY0WImEFL6Wlhq4ifvQnKPep
         enLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cP2LPFmLh3GNI8yVGWwIXDObCOn2NdEu2bxRoo7ljoA=;
        b=kC3LLNCYCKxYDUztJJA6eEsrpJ0GXq5hb66Z5C1HiBAdnBiBpfxrnQcC1qk6emm1/u
         m0mavu0O7UXY0FPYv8jSDvU3p8S3m17kSA9O4krC7IbhWwhFowBAL4RRzBZTM1iJS253
         FPfuaGY7vKyzKB+9797m3MIfmB5INXE5D27SdPonQbJmNprm3KcJxSxO5XIIRpch5MOY
         UQr33M3N1l+zJzsnNQc09i+VSx/HVWCzPlpHMoE4ZBNAXwrBvGaE2h4ERd3n6AoMGUl7
         to0DljcUnZLCM5X0UKSZcitjprmaREJhAUeEIT5CkYoJe3XB8OsVt6HZtRp69kR2tojY
         OYwQ==
X-Gm-Message-State: APjAAAUufcWAIEYE18FOvx6DJ5u7X1LMu3e2BG0JwngjfvkrSa96drMH
        3LImAYHLE87KgIu68aDWZocn02fs
X-Google-Smtp-Source: APXvYqwKVPJ2MlataSAMbwm+MJxGvff9PGWEDzutm3xi/rKnTbreIsLRA3Ptq1rFlJ9aaa3TVBILbQ==
X-Received: by 2002:aa7:d789:: with SMTP id s9mr3981664edq.62.1568717890296;
        Tue, 17 Sep 2019 03:58:10 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id i53sm367253eda.33.2019.09.17.03.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 03:58:09 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 0/2] crypto: inside-secure: [URGENT] Fix stability issue
Date:   Tue, 17 Sep 2019 11:55:17 +0200
Message-Id: <1568714119-29945-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes some issues with the TRC RAM probing that caused
instability (random failures) on the Macchiatobin board and incorrect
configuration of the TRC for some other corner case RAM configuration.

The patchset has been tested with the eip197c_iewxkbc configuration with
163840 bytes of TRC data RAM and 4096 words of TRC admin RAM on the
Xilinx VCU118 development board as well as on the Macchiatobin board
(Marvell A8K: EIP197b-ieswx w/ 15350 bytes data RAM & 80 words admin RAM),
including the testmgr extra tests.

Pascal van Leeuwen (2):
  crypto: inside-secure: [URGENT] Fix stability issue with Macchiatobin
  crypto: inside-secure - Fixed corner case TRC admin RAM probing issue

 drivers/crypto/inside-secure/safexcel.c | 52 +++++++++++++++++++++------------
 drivers/crypto/inside-secure/safexcel.h |  2 ++
 2 files changed, 36 insertions(+), 18 deletions(-)

-- 
1.8.3.1

