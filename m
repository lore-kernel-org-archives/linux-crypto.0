Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC8AC35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1BB2082E
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBG1nDoY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBFBVM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 20:21:12 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46068 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBFBVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 20:21:11 -0500
Received: by mail-qt1-f193.google.com with SMTP id d9so3211320qte.12
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2020 17:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/s0bCmmZgUsm9EJ/sZcigLWt6ZHZlrYi7+Qcr7pJles=;
        b=ZBG1nDoYzyacrmOGnheWDjw2dqeD2Qx+BnF9YxWyS0OyqgHqrmjysKbUGxexRIz5tM
         NQaQQJb7gl/A8R8kxYSSUJC0l3SW1cGkdx2nwyqPoEcOw+3z1lJjYbTv2hSqZHaSkz4X
         iJrdVhHn54eW3PUnhG9IaOFHY23YHnTt+OMbuGiNBgvQpcM8tLUge3boM+zs0aq4q7ye
         g87lSbVJazLb9v8DqrhUgSp9lr74huz1JItUkStKA+ZylEGX+oIF8OpyMwTll5JwZV4l
         DGq8Qqhf7KlvtO94ioXf2j5TBTdrFL+PMKTcdA1P77DfHe3xpgIIj6pC/iiGyfES1dxf
         ekIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/s0bCmmZgUsm9EJ/sZcigLWt6ZHZlrYi7+Qcr7pJles=;
        b=qx53SL/fqtoYryhWfNfNAn4OB49fH0+Cxy0syDlwarWCRomuQy9NhWFDxvZry0reae
         7Kvo7jYy1fDqtk1hseUyUHPMIFQa6TS5z69Je0yn5ziTYXfilEWNXcrGNi4VCvE4H3cK
         AOa7bnbH6WE1BfucpvtREJSqcEGaR0FsqDcS1HZmNn0PpQ9FLEZ9N6TWmYA2rHGuEjIZ
         aTA+QY6J7HNfG5Xy+B2ml4ab+NBZIDKcNLihTUkQgzFaX9w986NMb2MMKThZtvrTB1BN
         liq2KdTCE1rhwoBryDSypsU/MWKhowIFu+kDA0CxuiejEUehCZRDoWBrtRrBSHZnAADo
         ZxkQ==
X-Gm-Message-State: APjAAAXEw8NqA/La401+xFrSu5SDMV4a6cPDdUVxHatKngD53jGWHBTE
        xtfifMr1pibvurwqCqGk8utzkj4J
X-Google-Smtp-Source: APXvYqxrGY7pSZ+SBJizK3YKIGuldrSjj44s/pQJxKrBjwd6/qFMI+2Wm8WDrh01p9p+q8K+JIlqQw==
X-Received: by 2002:aed:2e03:: with SMTP id j3mr515609qtd.365.1580952070462;
        Wed, 05 Feb 2020 17:21:10 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c18sm719729qkk.5.2020.02.05.17.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 17:21:09 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v2 0/3] crypto: qce driver fixes for gcm
Date:   Wed,  5 Feb 2020 22:20:33 -0300
Message-Id: <20200206012036.25614-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203165334.6185-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I finally managed to get the tcrypt module working to make some
measurements straight from the kernel.  The reason the module was not
loading was that AES-XTS was hanging, so the tests never finished, and I
couldn't get any messages on /proc/kmsg.

By trial and error, I concluded that xts-aes-qce does not take requests
that are greater than 512-bytes, and not a multiple of 512.  So, when I
tried to run the tests with 768 bytes, it would just hang.

As a workaround we can use the fallback to fullfill those requests.

As part of the v2, I'm using a module paramenter to set the software
threshold, instead of fixing it at 512.

The results of the tcrypt tests confirmed my previous estimates, so I'm
leaving the default at 512 bytes.

Here's a sample run of my tests.  Just like with openssl, numbers vary
from run to run, more than I would expect.

testing speed of async cbc(aes) (cbc-aes-qce) encryption
aes_sw_max_len              32.768          512             0
------------------      ----------   ----------    ----------
128 bit   16 bytes       8.081.136    5.614.448       430.416
128 bit   64 bytes      13.152.768   13.205.952     1.745.088
128 bit  256 bytes      16.094.464   16.101.120     6.969.600
128 bit  512 bytes      16.701.440   16.705.024    12.866.048
128 bit  768 bytes      16.883.712   13.192.704    15.186.432
128 bit 1024 bytes      17.036.288   17.149.952    19.716.096
128 bit 2048 bytes      17.108.992   30.842.880    32.868.352
128 bit 4096 bytes      17.203.200   44.929.024    49.655.808
128 bit 8192 bytes      17.219.584   58.966.016    74.186.752
256 bit   16 bytes       6.962.432    1.943.616       419.088
256 bit   64 bytes      10.485.568   10.421.952     1.681.536
256 bit  256 bytes      12.211.712   12.160.000     6.701.312
256 bit  512 bytes      12.499.456   12.584.448     9.882.112
256 bit  768 bytes      12.622.080   12.550.656    14.701.824
256 bit 1024 bytes      12.750.848   16.079.872    19.585.024
256 bit 2048 bytes      12.812.288   28.293.120    27.693.056
256 bit 4096 bytes      12.939.264   34.234.368    44.142.592
256 bit 8192 bytes      12.845.056   50.274.304    63.520.768

Eneas U de Queiroz (3):
  crypto: qce - use cryptlen when adding extra sgl
  crypto: qce - use AES fallback for small requests
  crypto: qce - handle AES-XTS cases that qce fails

 drivers/crypto/Kconfig        | 23 +++++++++++++++++++++++
 drivers/crypto/qce/common.c   |  2 --
 drivers/crypto/qce/common.h   |  3 +++
 drivers/crypto/qce/dma.c      | 11 ++++++-----
 drivers/crypto/qce/dma.h      |  2 +-
 drivers/crypto/qce/skcipher.c | 28 ++++++++++++++++++----------
 6 files changed, 51 insertions(+), 18 deletions(-)

