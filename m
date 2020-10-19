Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FC0C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC8A22314
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJ1QkjrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgJSThB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:37:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730021AbgJSThB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 15:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603136220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=KU15bin5yh1/o+lq3KE7RT9x6CrBiQ+UqRtjQPmKPRU=;
        b=FJ1QkjrHbYOoI5pGwb+6AJa1TZaWOhBAMdaa5vnczNBprnDoQijwzS6tW2T/dw8JtYzntk
        gta2WT7pc4Ze/PRRIcQnAhfRYQabJMzzdzSyFFi4yQve3shdNw/8KBIOls+zVZDG6UNhAk
        Azj96n4GN1lvxEUcTb55fCGCA2HmPX4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-5d9HDO4wP66WVXHYveYmMQ-1; Mon, 19 Oct 2020 15:36:58 -0400
X-MC-Unique: 5d9HDO4wP66WVXHYveYmMQ-1
Received: by mail-qt1-f199.google.com with SMTP id x42so717716qta.13
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2020 12:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KU15bin5yh1/o+lq3KE7RT9x6CrBiQ+UqRtjQPmKPRU=;
        b=U4elr9PX0e00tA3ApbQmWsM7AH//gp25s3fcr2ozur0nEo3o36+rYwtU+m8v7jprpg
         t/WWBZ/F3UyzP22HRvehpzcu6SIsWBwX8qTjm6nK5ryImAUZtMp1Yxxxarzc7VIE/RiQ
         yE6oICe17ibT+ScOyIzv1B70tPK1CemZbwlxmMsAk/UclVZY0WzIPWHGXD3d50VCsFOB
         yXYbVEc23i1U7j6RIFEnzDIzJghj2fMCgUYmfpTbPj5rIxiNOQoSuMRs+u4LMrPi+uSf
         5PvBUk9fi8jV+uAcCLkZ2xl2rYIj0nlSViEADRrYPdw3IvZckCdRwWXEVQPqwKksVb/Q
         4q4Q==
X-Gm-Message-State: AOAM531mJKKioyhErc+0iDDJgdbjPsFFkFj7RUB8uBeUIiQvxhxHSZ1z
        g8NfWI84HG+XjKg1f6i8lLLsY/zsehkkfdYxM4F0MWWSn+HfVcn5Bs/b46mId2BbMr0y3BNj0hA
        /v863OwWj3BIoaRGzhhjDRVDw
X-Received: by 2002:ae9:e804:: with SMTP id a4mr1107012qkg.324.1603136218438;
        Mon, 19 Oct 2020 12:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvdQAIzHDvjts4PDAgJJfYwub44mHei8vjHCDSaOolSbAYtAnuSPossUBmcHdVD0H8TWveuQ==
X-Received: by 2002:ae9:e804:: with SMTP id a4mr1106991qkg.324.1603136218130;
        Mon, 19 Oct 2020 12:36:58 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id o1sm424115qkf.129.2020.10.19.12.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 12:36:57 -0700 (PDT)
From:   trix@redhat.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: atmel-sha: remove unneeded break
Date:   Mon, 19 Oct 2020 12:36:53 -0700
Message-Id: <20201019193653.13757-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/atmel-sha.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 75ccf41a7cb9..0eb6f54e3b66 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -459,7 +459,6 @@ static int atmel_sha_init(struct ahash_request *req)
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	ctx->bufcnt = 0;
-- 
2.18.1

