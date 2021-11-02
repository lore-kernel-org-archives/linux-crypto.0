Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9387FC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F933610A3
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 14:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhKBO0T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhKBO0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 10:26:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC7C061767
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 07:23:35 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u15-20020a62790f000000b004802fdd141dso6489581pfc.17
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u6e4WOpk0Gy7k+VMHluWLZb26ejBKbKlf2/TYAs8po4=;
        b=XTjOStoKg0N6wfHaH3SzwOZID8vIMWONfnqf8lYJCeqJ2EiS/S6Hjq9ofmqln9P1EW
         MK6wB0SISa52PPpwF3WyGEILcviw4Z0TwMyEQrlVTMOaVOjyuefpxn/Vxl2xiQeeqdMM
         pH2QT1EO5clygoA7+wugYZ3pXkf/+US8wCMqYVEUr0K6OYhxXCUJFROEifzwNUn5dER3
         5tJFFhG6Zm6vw97ArYpj+vh0MiEv4qpk/T4sZcpYpITGMDjIaHL9lFveEqUM5b4vk1d2
         qmX1RaK3+SrFEsb0SqRiIMtBcoqLQsqhm5Mn69bzHtfNtn7gOSHj8C55GJ0+W6ZeMu1+
         zfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u6e4WOpk0Gy7k+VMHluWLZb26ejBKbKlf2/TYAs8po4=;
        b=auFFxaSnY5OuvTTIjdjG+dxpzJLWwDtN1wnhol1LiK/qIJxMbRz/1CpYSxCqh/UlkJ
         JwdUMeznIPbqHUGOKFCEaTKTrWvaVU2uvDfHzlc2ytXwa6bZRUhS8Av8QAB4MN/cjPTm
         gdGlobr3PCPd49cuSM6KekPZU1AMFDhvrWnd3CCUj++52yEPgXbTcCcywCFAfWExWihT
         TobKZ3DoytNjpso9PhYVPRbV207wy69qS7ktUiXO1pG0E/AU8DSXJ2y3M8QCAoMFk3Vw
         mDwpvJV76B6Qcm30Xk0//Qm6ix7UGg1NsAPk0/x8JKwMzJ9uov8KCk91D7RzDFiwMf0m
         lm5g==
X-Gm-Message-State: AOAM5324ACRhXvndHyf+dHoi038X7H0WJ27s8yTK+HKSbuiDIZ2mhZ36
        EnFSXTZlbCeqIvOsSEukiXrgRBQ0tUU=
X-Google-Smtp-Source: ABdhPJy/fKRYQWUyxSBEeGg1RfqjWhYkU35eXTT+y4WzPcVm2Gqegz6Udg89ZNRpZWG5jJBtW1NkltZ3KFQ=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:3109:8497:f59d:9150])
 (user=pgonda job=sendgmr) by 2002:a17:902:9694:b0:141:ea16:aecb with SMTP id
 n20-20020a170902969400b00141ea16aecbmr12630734plp.62.1635863014799; Tue, 02
 Nov 2021 07:23:34 -0700 (PDT)
Date:   Tue,  2 Nov 2021 07:23:28 -0700
In-Reply-To: <20211102142331.3753798-1-pgonda@google.com>
Message-Id: <20211102142331.3753798-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V3 1/4] crypto: ccp - Fix SEV_INIT error logging on init
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently only the firmware error code is printed. This is incomplete
and also incorrect as error cases exists where the firmware is never
called and therefore does not set an error code. This change zeros the
firmware error code in case the call does not get that far and prints
the return code for non firmware errors.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8..ec89a82ba267 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1065,7 +1065,7 @@ void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct page *tmr_page;
-	int error, rc;
+	int error = 0, rc;
 
 	if (!sev)
 		return;
@@ -1104,7 +1104,8 @@ void sev_pci_init(void)
 	}
 
 	if (rc) {
-		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
+		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+			error, rc);
 		return;
 	}
 
-- 
2.33.1.1089.g2158813163f-goog

