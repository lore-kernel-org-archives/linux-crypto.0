Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB5FC2D0B1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 305C521741
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rzgjPjC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBFLlX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:41:23 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34208 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFLlX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 06:41:23 -0500
Received: by mail-qk1-f196.google.com with SMTP id n184so386163qkn.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 03:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9GkHQZfqyTErb2VS3xb93RgPpd/fWvPnaBmLlNEF/U=;
        b=rzgjPjC57YS5zrpCwJf4ihcRexiIWc+/90mj6iJTjF60CN6ycIbozvjFONfkteuW2j
         uJQ/APdbj8Xio4lrUXW6fiJ1apgN86K2hPnVCxV3ct+lxWpilwO1EVeR43y40llbiXf/
         L1hjMf975KzVk+BwNswtob4ihhyQzyqfKF5PHX7vIHdBolGoIbE6K3zIOBK3oMqodCRg
         XGo2J0w/flDNJ8BBFCesEE7gzv1MFpKe4cvkoSy4TneBhhxF24YToJ8r47m/bOrL/F1x
         weVqgSc13+gkZV4jLphEhOd7LtiCgJ30Uro4q2J3vHzc7I3jPRey6mtUlzgAPljIVBwo
         qVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9GkHQZfqyTErb2VS3xb93RgPpd/fWvPnaBmLlNEF/U=;
        b=k8DeFYH82JTc3OSDypnYAdP4Uq8W8P9U3jj0NOv9t4M8m/nAbjWR3VkVAxHLgdfwK0
         ptUIXXC04V9Jk8UQCvZX/cM6NlVBfqrlz4L2SFBOdyJmV7dC1UMBFdN5c5T+74hMARJm
         272cHf6yvJEoORAcssedTI62BtAP1qTOlAzB2O+rx5Pxd/jQP1tOqR4xLkWq+/luSRj2
         SFi8iDy4osEDGs+gEYEcLMDBQl6ibJdwqdSZ93ag8z0AGadBabYqmuTrAmQpdzg9PkkU
         gtOMY41BeEpxrqryVUV0Tjumf5Fy8F+2b6xVwzSJrK5wHtm5P0AV1IABsc5r/cMC42ih
         0onQ==
X-Gm-Message-State: APjAAAXdrd8D42p39XGOdnxz8HVr4tnwxSgBrbcL0JyTEdllah/1IsoR
        jHlvrpaEY9iPit6DQz2EpgJeRILr
X-Google-Smtp-Source: APXvYqxMeFn4LDPi2kD0TZ3K5bVNTN+oufT8S8dzZyxOibqZdfunTuWUJy2x33vPYAelaLCq9qH7sg==
X-Received: by 2002:ae9:c10b:: with SMTP id z11mr2054639qki.157.1580989282110;
        Thu, 06 Feb 2020 03:41:22 -0800 (PST)
Received: from gateway.troianet.com.br ([2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id g37sm1507283qte.60.2020.02.06.03.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:41:21 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v3 0/3] crypto: qce driver fixes for gcm
Date:   Thu,  6 Feb 2020 08:39:44 -0300
Message-Id: <20200206113947.31396-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I've sent the v2 patches I had generated before I had run checkpatch.pl.
Sorry about the noise.

One comment about the splitting string across lines:  It's the parameter
description string, and the split is between the description and the
explanation about the values.  I hope this is OK, if not I'll send a v4.

v2->v3
Corrected style issues pointed out by checkpatch.pl

v1->v2
Add a parameter to set the fallback threshold.
Fix for xts-aes-qce hanging when (len % 512 != 0)

Eneas U de Queiroz (3):
  crypto: qce - use cryptlen when adding extra sgl
  crypto: qce - use AES fallback for small requests
  crypto: qce - handle AES-XTS cases that qce fails

 drivers/crypto/Kconfig        | 23 +++++++++++++++++++++++
 drivers/crypto/qce/common.c   |  2 --
 drivers/crypto/qce/common.h   |  3 +++
 drivers/crypto/qce/dma.c      | 11 ++++++-----
 drivers/crypto/qce/dma.h      |  2 +-
 drivers/crypto/qce/skcipher.c | 30 ++++++++++++++++++++----------
 6 files changed, 53 insertions(+), 18 deletions(-)

