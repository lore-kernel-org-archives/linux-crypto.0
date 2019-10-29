Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9404CA9EAE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 16:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C60620717
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 16:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzNlAfDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390273AbfJ2Q3l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 12:29:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33196 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbfJ2Q3l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 12:29:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id c184so9966592pfb.0;
        Tue, 29 Oct 2019 09:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xcQIFhsCdgVLUN4chM/avgVmRT0noW2+1LKiFI0840Y=;
        b=HzNlAfDOJEMBmRd2dz4GOmKkwC1qWRfUq1GuD0BTJDUBhVbE2nqwT5qzmAQbVhXWrS
         QhjJx/py+dd0bKbwmJ7O6/1Ws9Ph8mSHScMI/QnzGCs/OEeoE8dIB4t0b9wDaxCaZ9Sf
         DZ4Z0GtIeCLvcF9uaIc0CY5KaJHfz9iNUuuYThhAuV/2ftXl+nPvJFETNqWYS5awMFCx
         9MCr3do6Mo/AEJ5GS0waECIdWb+aPC7ufepbBY98r6BgSLJCDGstsllVuwn8d2bQXDot
         inFXBFvv82gKhYLJQDOOH0z4o6mEgAi6yiC1EVVq2IaFWFs03QqD3KoWvRCeHjQPZafi
         llnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xcQIFhsCdgVLUN4chM/avgVmRT0noW2+1LKiFI0840Y=;
        b=tBnAlmLw8AcnVWCJziTGNpfS+FMoI6irq7/Uct1TWQ3Ah7bnhEE1HrQFEh8Q6tgRgm
         Ztvit62XUL5UxP/4HFG0Kxv1b9+B+IvicYY/wVJDUCc/pzoIKIcrcehwAfCfDFCilsJ8
         WU0nUWS7kZcOh2TNRbPJL9XoJO2opsnSVdXgIFXzrD7H4VtPj43TcITmbozqoaCYXzOS
         BgBoGQ1tljYr2knH3Z/cviyB+GSW6mkRKrmHZ3LpMnbMjXkvketxEzSYlsbJmRHTsJVV
         3lV0X+xj8P2g3GCYbyGlBG9zxG+DtVJzNj0aEERslSk9z3kZR9C+X4wepnjJZ4FuYtyr
         ag7g==
X-Gm-Message-State: APjAAAVMaH8RCkrrHZVc3X25ylkNCEKytsakEE/W2eq6h1UqSg2McZ7t
        xP/zKLZVh6pLRbLwmHlM0XI9Dlso
X-Google-Smtp-Source: APXvYqwryc+DhxwJ4psvAfXQBjxFEOLzf0g2xVaXGAc5ou+6tejNAl4eCJs8tbQcWgqgxhiOT/dyug==
X-Received: by 2002:a62:d44b:: with SMTP id u11mr20637837pfl.259.1572366578670;
        Tue, 29 Oct 2019 09:29:38 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id q184sm15438830pfc.111.2019.10.29.09.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:29:37 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] enable CAAM's HWRNG as default
Date:   Tue, 29 Oct 2019 09:29:13 -0700
Message-Id: <20191029162916.26579-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

This series is a continuation of original [discussion]. I don't know
if what's in the series is enough to use CAAMs HWRNG system wide, but
I am hoping that with enough iterations and feedback it will be.

Feedback is welcome!

Thanks,
Andrey Smirnov

[discussion] https://patchwork.kernel.org/patch/9850669/

Andrey Smirnov (3):
  crypto: caam - RNG4 TRNG errata
  crypto: caam - enable prediction resistance in HRWNG
  crypto: caam - set hwrng quality level

 drivers/crypto/caam/caamrng.c |  4 +++-
 drivers/crypto/caam/ctrl.c    | 19 +++++++++++++------
 drivers/crypto/caam/desc.h    |  2 ++
 drivers/crypto/caam/regs.h    |  7 +++++--
 4 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.21.0

