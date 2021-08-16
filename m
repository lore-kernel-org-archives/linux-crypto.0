Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD050C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 19:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B620160F55
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 19:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhHPTYE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 15:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhHPTYD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 15:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629141811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tWj4QoGgsZXwBjPcpg0s+AqXSiipgAeGsG36glfrsNA=;
        b=N3BiG631OtQqn6ToBC8RF/TRSvuWf6wzzqUUFIFXZTAAx27oJiGwJRti6gDNi1lJuNyOJJ
        7mo3DD8YkCOTlQgbv5O58RNdawvZIJ85LZfEaj7Yx2YtiO9dmaEPJHAh9gEuLUZ4z5Lesz
        bUgAkIVfTiXzeYFAA6d+kAGHaLnAUfU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-vTHCaV5UN8Kub17Rnp2Ljg-1; Mon, 16 Aug 2021 15:23:30 -0400
X-MC-Unique: vTHCaV5UN8Kub17Rnp2Ljg-1
Received: by mail-qk1-f197.google.com with SMTP id h186-20020a37b7c30000b02903b914d9e335so13827731qkf.17
        for <linux-crypto@vger.kernel.org>; Mon, 16 Aug 2021 12:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWj4QoGgsZXwBjPcpg0s+AqXSiipgAeGsG36glfrsNA=;
        b=GHUt/gIN1Z5oJYcAn5TLTkjS2Si5WCUV+voklB5mZk0JugomtoDA9hnJ/qcoU+Dv1d
         quMN7QiA0x6aMbZyrNFaaBYMwahWx3tlmn+bLPmO8tOUeQ4o5kME3v7V7WSylrS9wj4l
         Oiyozh10b/U1tZ2Bh3CG/gIUdjngmsEPQyaLWS0hL/DV/fg+Yy+j8wf7qtwEeYEUNnfY
         u0iwzWqEmJ/ttfBR/X5fEe3BSddvpYypXENFe1pwFKpacthAqskLyjoLqrG3L+2GSzVR
         ObM4bYmDTetE5pic8C0EqjUSVOrlrxWy95fGMOifA3sfTKyI7TlZyThDtfpHswADqgW0
         A83A==
X-Gm-Message-State: AOAM530Bb4YWR5WG1Y60J/qu43m+4RjsrlfO5T354w6tx4osZY0TIZYY
        NtMJBtHaiGSMkRrIoZNewlmY/qVLjnRIZ1Eae8zbyeV5jjCxAm36aSPACAkacSgZgXYOKxEyh5Y
        fDW1i6XG0Dj3XCAGoxlGS69xV
X-Received: by 2002:a05:6214:aa8:: with SMTP id ew8mr312662qvb.43.1629141810009;
        Mon, 16 Aug 2021 12:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEa+K77EwKUJ0Um/4h+WQIF7my+th7mGi8g1MwVio9mvnR546sa0MV+RmKb42YeLka1sw4lg==
X-Received: by 2002:a05:6214:aa8:: with SMTP id ew8mr312643qvb.43.1629141809795;
        Mon, 16 Aug 2021 12:23:29 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y124sm55002qke.70.2021.08.16.12.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 12:23:29 -0700 (PDT)
From:   trix@redhat.com
To:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        ashish.kalra@amd.com, rientjes@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: initialize error variable
Date:   Mon, 16 Aug 2021 12:23:12 -0700
Message-Id: <20210816192312.1291783-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this problem
sev-dev.c:1094:19: warning: The left operand of '==' is a garbage value
        if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
                   ~~~~~ ^

The error variable may not be set by the call to
sev_platform_init().  So initialize error to SEV_RET_SUCCESS.

Fixes: 1d55fdc85799 ("crypto: ccp - Retry SEV INIT command in case of integrity check failure.")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8d..b2b9f0f4daf2d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1065,7 +1065,7 @@ void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct page *tmr_page;
-	int error, rc;
+	int error = SEV_RET_SUCCESS, rc;
 
 	if (!sev)
 		return;
-- 
2.26.3

