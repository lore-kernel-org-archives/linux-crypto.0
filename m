Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADE5C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Apr 2022 13:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358875AbiDCNdM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Apr 2022 09:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356909AbiDCNdL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Apr 2022 09:33:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6251333E30
        for <linux-crypto@vger.kernel.org>; Sun,  3 Apr 2022 06:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648992676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VDYAftsuMOi1oo0i/R8Jb9mhdL4m91TdJTqR4mm4wiA=;
        b=UIJ2s8Myl4RMfYrHLLmHHGqWhu3qy3Mxpper1jTsT6I+EJUsQwGxtrIrHlF2rPXey7U6RE
        BP/jOK51B6UFJPvf7R94yxcvkDR929EvOm+5ZcRYnyk8S9Im7oqPv+HdRJhZf7wCYqOkiv
        LafWNiFJhIE9lpVrJUT24ZtNfEs6h1c=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-lxVsaMXAO8ucaHhDpTS4pA-1; Sun, 03 Apr 2022 09:31:12 -0400
X-MC-Unique: lxVsaMXAO8ucaHhDpTS4pA-1
Received: by mail-qt1-f197.google.com with SMTP id m12-20020ac807cc000000b002e05dbf21acso4787987qth.22
        for <linux-crypto@vger.kernel.org>; Sun, 03 Apr 2022 06:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDYAftsuMOi1oo0i/R8Jb9mhdL4m91TdJTqR4mm4wiA=;
        b=bJ5kSh+VoENlGbgAj60a6f/C9Fxo+uZ6raU632uwEbfyRkpgjKNn60YRQR4T8sChPt
         HXoXoacP19yPYxDbxtW5YnEpAOAY1/n1THZSVctSLC+2q5I95FYgQQ9lMVEMM3xSaAll
         haGyR/+KRFrh/6LwDdS4G6cvHtpjc34MevzsqStVcpOswypwKdoi8Rr1ZfUsE10IoF3E
         ChXBbg2k2fMSgRVOQM6334PBDlNHh+vlaIzeTCmUV+WlSaDim25XrvnbFVx5YP+hDJ9g
         V2+mqBida34T1xTAV0RQxR48o3iUOphl7tU3BhQNezdmDOYIedSPtDwXw2YcKvghY1/K
         Xn4A==
X-Gm-Message-State: AOAM533gN/FgBekE0CURS1zbSr0N6SfkjamD9UWALXq4x3mhE/f34OGX
        CKKhuwAW3NaweqJkbuIt+5M19KFnKpC+LD+TKJ9L8bQd4SVR1sQlBSs6e0VSkR6vlxTxwZz32Xy
        6otCDE4KQS0Vo0b+K/4fw2RVE
X-Received: by 2002:ac8:57ca:0:b0:2e2:131b:6f0e with SMTP id w10-20020ac857ca000000b002e2131b6f0emr14428090qta.664.1648992672236;
        Sun, 03 Apr 2022 06:31:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6Iqoonrf1l2NpFOddPCh9YWDHIgeM0/FaT+c8ZCrvRKqTogSOEz6yRGSG2RNsYUniKGNOTw==
X-Received: by 2002:ac8:57ca:0:b0:2e2:131b:6f0e with SMTP id w10-20020ac857ca000000b002e2131b6f0emr14428070qta.664.1648992671981;
        Sun, 03 Apr 2022 06:31:11 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id az17-20020a05620a171100b00680af0db559sm4810834qkb.127.2022.04.03.06.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:31:11 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     dan.j.williams@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, jarkko@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] raid6test: change dataoffs from global to static
Date:   Sun,  3 Apr 2022 09:30:51 -0400
Message-Id: <20220403133051.3751572-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Smatch reports this issue
raid6test.c:21:14: warning: symbol 'dataoffs'
  was not declared. Should it be static?

dataoffs is only used in raid6test.c.  File
scope variables used only in one file should
be static. Change dataoffs' storage-class-specifier
from global to static.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 crypto/async_tx/raid6test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index c9d218e53bcb..d2d5fb154cda 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -18,7 +18,7 @@
 #define NDISKS 64 /* Including P and Q */
 
 static struct page *dataptrs[NDISKS];
-unsigned int dataoffs[NDISKS];
+static unsigned int dataoffs[NDISKS];
 static addr_conv_t addr_conv[NDISKS];
 static struct page *data[NDISKS+3];
 static struct page *spare;
-- 
2.27.0

