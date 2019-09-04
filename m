Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE509C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B78D022DBF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWmNIHoj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfIDCfc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:32 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:41646 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfIDCfc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:32 -0400
Received: by mail-pf1-f170.google.com with SMTP id b13so5578993pfo.8;
        Tue, 03 Sep 2019 19:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSgxG3inIUDth+MW6z7dzN3SicTuf5PF5fcMI36bTe0=;
        b=fWmNIHojJ8bdZ+jOjMHSj14XPMrrH7xiny3mqeB9h5bv1HuWRT2RLIH0uK8wOgW2ga
         wvFg69dJhUGjkVc8kI23uojwBYYUJQQIKJPu7X5Iu+JMQGeupwBOOOC7k0CLs6MPFhM/
         mW29DuPUrCW1VhJK3Gp6h1zXHzS0DVKHJntSVhuq31KVNwa6BrwicYIIm4Z0TVOtkmej
         2PfkycOCqQd5xkPahzYzif3RK+MROozeENIDF/K4YOaIznsbYy3j4cDnfS6jhuz7G/FH
         ahC/PLpoPbPTMZKhCDfl7g5Ecj7Orheuw4JGMvu9gplTtkGA8+jDo//6vBtLn1emF0E8
         xvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSgxG3inIUDth+MW6z7dzN3SicTuf5PF5fcMI36bTe0=;
        b=reh+F2ty1lO0OQBkcmTY9Oi8ZNNdKpcfG1yQNyG+jFMlt24DBQLgz9vfw3zo6FUHB2
         KVoOxKpe4wZedrwxIX6OAkZRtTp+3xlrQoZSUY+Q+RvNSc2RJZMky4BY6YkGVo9dliK6
         qnGO7+4777CYvNoQwgwFP95LW5QNeMRo/Qcj/Ms8T3k2PPGBwn85I3b2UoMbXlaUHX7o
         BzVr1MCLAMMiL9TVJIZDBdDiY5nS1hn6yintknwre8n6QMgRcbZqUOsJH1QUO+MxiHMZ
         HnI8kgir1wkGsa4vVFbfMtq4h2FN/puZZTcKUBSVr3JIw6DPzlRrHjxiYOZSlnZlJ92a
         UTDA==
X-Gm-Message-State: APjAAAX56TVTa9cR3syOKJM8abv1RLAH6uAZW9lBGRuuTFE6MlFu3cjG
        wJYQ2iiWc7Ql28dv0Bb/QuioSwmVW8I=
X-Google-Smtp-Source: APXvYqxvJ2BVyRpv/VivRUas05d7eAKzgkM/N0ZVkbmVuwZbwAr3XSnciM2DF1PEnuSFyM90E10TTA==
X-Received: by 2002:a17:90a:e292:: with SMTP id d18mr1288259pjz.100.1567564531178;
        Tue, 03 Sep 2019 19:35:31 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:30 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] CAAM bugfixes, small improvements
Date:   Tue,  3 Sep 2019 19:35:03 -0700
Message-Id: <20190904023515.7107-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

This series bugfixes and small improvement I made while doing more
testing of CAAM code:

 - "crypto: caam - make sure clocks are enabled first"

   fixes a recent regression (and, conincidentally a leak cause by one
   of my i.MX8MQ patches)

 - "crypto: caam - use devres to unmap JR's registers"
   "crypto: caam - check irq_of_parse_and_map for errors"

   are small improvements

 - "crypto: caam - dispose of IRQ mapping only after IRQ is freed"

   fixes a bug introduced by my i.MX8MQ series

 - "crypto: caam - use devres to unmap memory"
   "crypto: caam - use devres to remove debugfs"
   "crypto: caam - use devres to de-initialize the RNG"
   "crypto: caam - use devres to de-initialize QI"
   "crypto: caam - user devres to populate platform devices"
   "crypto: caam - populate platform devices last"

   are devres conversions/small improvments

 - "crypto: caam - convert caamrng to platform device"
   "crypto: caam - change JR device ownership scheme"

   are more of an RFC than proper fixes. I don't have a very high
   confidence in those fixes, but I think they are a good conversation
   stater about the best approach to fix those issues

Thanks,
Andrey Smirnov

Andrey Smirnov (12):
  crypto: caam - make sure clocks are enabled first
  crypto: caam - use devres to unmap JR's registers
  crypto: caam - check irq_of_parse_and_map for errors
  crypto: caam - dispose of IRQ mapping only after IRQ is freed
  crypto: caam - use devres to unmap memory
  crypto: caam - use devres to remove debugfs
  crypto: caam - use devres to de-initialize the RNG
  crypto: caam - use devres to de-initialize QI
  crypto: caam - user devres to populate platform devices
  crypto: caam - populate platform devices last
  crypto: caam - convert caamrng to platform device
  crypto: caam - change JR device ownership scheme

 drivers/crypto/caam/caamrng.c | 102 +++++-------
 drivers/crypto/caam/ctrl.c    | 294 ++++++++++++++++++----------------
 drivers/crypto/caam/intern.h  |   4 -
 drivers/crypto/caam/jr.c      |  90 ++++++++---
 drivers/crypto/caam/qi.c      |   8 +-
 drivers/crypto/caam/qi.h      |   1 -
 6 files changed, 267 insertions(+), 232 deletions(-)

-- 
2.21.0

