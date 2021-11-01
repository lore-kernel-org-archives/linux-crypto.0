Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF54C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF58604D2
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhKARYJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhKARYG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:24:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E19DC061767
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:21:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso6242870plp.12
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u6e4WOpk0Gy7k+VMHluWLZb26ejBKbKlf2/TYAs8po4=;
        b=BKgqPaMHRJGeKmUWiAD/GTjyUCq6ZoB6wM35BJjt1Y1W9YMbdRpdHKbyT+4/7LmLln
         3Wc8eZV2yFc8bJ5jzFrDaU5oFyVW8djSSPys2zr9o6NGtntRnLp8HWXBf5M3QqwT/6/+
         CHGJ5mTOcQiCIhyqOnRPZ9UzAPzKYyW610MC/5FzuloqOLsUzGjqHfysYE4CyXI54r+F
         rsetY1DT6Ioafw8nRII6DnT5ISBkuoYCrxscvyM7BbCW6XNO7WP04FzKadJAlxsVF8g9
         pEKFKoTTse8KhgwVx4rgasQ7gdDTny4FAoA/wglYW3GY+CPFAVAnf4eBdSeKmF3WPkwy
         fQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u6e4WOpk0Gy7k+VMHluWLZb26ejBKbKlf2/TYAs8po4=;
        b=XRlI0KU7qH0wzckLoCXYHipumhNQd74ADcLwL++lz9xKKyJStjCP5HVGaXWNGaBVmB
         L+nYn7TzkSBhO98HXl6feOly6hpV+TERO2GCSsfv20umrZMvFyO6TIzZAewHimjoXk2Z
         9pE/VuiWAzIEwkXPdfLie1C4oM+ZiNZWHXH/bdyGcOYerLjOGUqG8OJsLAXhWOszHEa5
         SQ2Ebl87hPEXFIPzkQniQZemv2XpXOKjLrBpy3Hvv9tkNWKNY9MPuDJ3uU9oEigAQiZ0
         Z2ElvETcuQwhfj3eKuH7KAPPtkng3mSZIKfvHY4cTTG8laNrhU7/1aA7C4IaVC4hZQIV
         XK1A==
X-Gm-Message-State: AOAM533T/WMIRWKycdsVmy0XiVt3BW0+STrB/fPElkjSBNIYb5+IbDRg
        ZCPyW+tNXMi27qVQxDADmr65q37niLs=
X-Google-Smtp-Source: ABdhPJxUaXcJxvWJuYDC9RhLFaHpob09RuTcSuLtjlBEzj5FCXN63XaAX+9YIQHHd59L+vZBLva8Ox74WUA=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:98c4:afe5:ed9f:d0db])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1311:b0:455:c1f8:4637 with SMTP id
 j17-20020a056a00131100b00455c1f84637mr29809939pfu.83.1635787292659; Mon, 01
 Nov 2021 10:21:32 -0700 (PDT)
Date:   Mon,  1 Nov 2021 10:21:24 -0700
In-Reply-To: <20211101172127.3060453-1-pgonda@google.com>
Message-Id: <20211101172127.3060453-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211101172127.3060453-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V2 1/4] crypto: ccp - Fix SEV_INIT error logging on init
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

