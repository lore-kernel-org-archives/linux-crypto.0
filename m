Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF72FC2BB1D
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 06:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F03C206EC
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 06:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YyhSSbWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgCQGPh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 02:15:37 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:52215 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgCQGPh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 02:15:37 -0400
Received: by mail-wm1-f50.google.com with SMTP id a132so20092925wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2020 23:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vOZIH8F64Sc67v6hbXriJW6HY6fOk7Q348T3idirB4M=;
        b=YyhSSbWQBWDhXSE1PRpQe0l/+QCff5YLfGrRYiwyHSWTP9uzdyypVAuIaL3qq+d/8g
         EwGiMWAQY8JCvMsT2WRTUojwHYvcRIJ/24WnscisMMIg1RJyqq9TbNjZ4I04D/fyuDv9
         hIm9SQ/K9BxOvGftfllOejo78+TeiFAXl5vyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vOZIH8F64Sc67v6hbXriJW6HY6fOk7Q348T3idirB4M=;
        b=HXBP125+T75zDdSwwbVN9cXu6GyJnfUnTA5hz2FNBHEBx3U88CCYF63WFS0FU62ppH
         5u6DneQjtaAJwU7DoyGpd/jLfzeIVFNQ6PssWkwoQxzBuf8Qnmk2hIQ6KIeujwD6j82I
         Dgjqfof4SCK97P+HxKGKiirEOGGkASYaBVl6zFHW+nzCvp6p7ZgQsjFUsxRa+2CQvtUG
         8D5NTeSkntLOW/r8gZku71vUy2d9cAvx4LWbu9ZsOPaIOBCjeOgxukKPsiY0K6wVA+ZB
         u6KhUnwXcOxUPyk0r2sQwhBzCHl0lZr8H87ZJ+N1My537H5f3fVxhmQitwd0k6Hdte/Q
         6OoA==
X-Gm-Message-State: ANhLgQ3dBtW1hcE8Cxdox8GSi/F6ie3dh0japufpw0ayxWDLiNI64cmb
        lUMz4Qo+8IBs5ZEy4ik+/02mhQ==
X-Google-Smtp-Source: ADFU+vvucMygb6X8ybeNHfpyaKgLW4A2wZEKLDOJaOFxYC/dcJt5rDLyWtRw4B1KkrV4YWIN9JdRHA==
X-Received: by 2002:a1c:ba85:: with SMTP id k127mr3091197wmf.63.1584425734805;
        Mon, 16 Mar 2020 23:15:34 -0700 (PDT)
Received: from rayagonda.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o5sm2658096wmb.8.2020.03.16.23.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 23:15:34 -0700 (PDT)
From:   Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Subject: [PATCH v1 0/2] Remove BUG_ON() and fix -ve array indexing 
Date:   Tue, 17 Mar 2020 11:45:20 +0530
Message-Id: <20200317061522.12685-1-rayagonda.kokatanur@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series contains following changes,

1. Avoid use of BUG_ON to prevent kernel crash and return error instead.
2. Fix possible negative array indexing

Rayagonda Kokatanur (2):
  async_tx: return error instead of BUG_ON
  async_tx: fix possible negative array indexing

 crypto/async_tx/async_raid6_recov.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.17.1

