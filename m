Return-Path: <SRS0=Ja5q=BL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE46C433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Aug 2020 12:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF1520888
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Aug 2020 12:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/vkOFTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgHAMYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Aug 2020 08:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbgHAMYb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Aug 2020 08:24:31 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAE2C06174A;
        Sat,  1 Aug 2020 05:24:30 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id df16so7781775edb.9;
        Sat, 01 Aug 2020 05:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ugiOTcKJH92D5ouhrmd6nUXyIp1jeLijZ9Lgi26pKL8=;
        b=W/vkOFTfxzqiiqs5PXjZUT+8QIuU0+pxzpIIqEsz/Iah7QiEJd93HPDsKT8TflOP/Z
         vkokqeDy6Dhfa07r+1amoq4UimqMupmi6vEC/Z2KKJKd/6H6AUQEmduiJ6Zw6DSLqyKa
         jDLhRax2V6eINcLZ1dLJJvXe2155H77nTZzGKcm96vWk2MiZMNOaCqLXan1u6UVF5zHA
         Xeo1r1viDJH1NZLzBOqCaLwtu+Q97vwTx3n+mdsV+zBt3JyuxPiiBVO+wC9XKKShnelj
         4W8tiRi0URtcz+pixxXLjAWPDnYF8u6tA4L7FyczjlelIPysvj9ACtw2Tuc/Fqe6C5+N
         akag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ugiOTcKJH92D5ouhrmd6nUXyIp1jeLijZ9Lgi26pKL8=;
        b=W6fZss5peTu5Ka7TB16RwJ1pastYNTaGVww9EagDu84NrrDBsjtLGAqnVTSl80JP1U
         P+jx14x7b6BtN1I5r8Y7S5aAAmeGDPF8+lmjwAkgqNJ6H55zZ97pmw3m53MrP94CP0XA
         qI8uJYai5C1dnYHzSMnbbQs4zgJUjGmrdizbNOeAQNbvtTlJyoUvX7w2KbO/j7Svg7DJ
         b7IkWQogI83kg+zPIBEL28dO4AQNxVGF3+QkGXcr0mPTDIyy9geDX49w9JfxQCKmoHHC
         l5ft8/FhqNTX1yJUQq9WhfbrbY7FKoko+2W0aknzIK8Fdwx7VThR9wPpqECMocgIU+DR
         S1yg==
X-Gm-Message-State: AOAM532VbtKejaswcCLG0+poQ2YvgFSDYZrBDwMy9u6VhbiZa79d24bS
        yzsPiXnbsYmbmf07SANWFtw=
X-Google-Smtp-Source: ABdhPJxHTS05lKwaHfmyLAfUgz62XiabbhKbOegL6lSQtaauPJSHYiZ4vVmubnufMFIzKuHLLLAvdg==
X-Received: by 2002:a50:cfc6:: with SMTP id i6mr8111480edk.88.1596284669219;
        Sat, 01 Aug 2020 05:24:29 -0700 (PDT)
Received: from net.saheed (95C84E0A.dsl.pool.telekom.hu. [149.200.78.10])
        by smtp.gmail.com with ESMTPSA id a101sm12083131edf.76.2020.08.01.05.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 05:24:28 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [RFC PATCH 04/17] hwrng: Drop uses of pci_read_config_*() return value
Date:   Sat,  1 Aug 2020 13:24:33 +0200
Message-Id: <20200801112446.149549-5-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200801112446.149549-1-refactormyself@gmail.com>
References: <20200801112446.149549-1-refactormyself@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The return value of pci_read_config_*() may not indicate a device error.
However, the value read by these functions is more likely to indicate
this kind of error. This presents two overlapping ways of reporting
errors and complicates error checking.

It is possible to move to one single way of checking for error if the
dependency on the return value of these functions is removed, then it
can later be made to return void.

Remove all uses of the return value of pci_read_config_*().
Check the actual value read for ~0. In this case, ~0 is an invalid
value thus it indicates some kind of error.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Saheed O. Bolarinwa <refactormyself@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 9959c762da2f..e7bf17eedaa0 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -141,9 +141,9 @@ static int __init mod_init(void)
 	return -ENODEV;
 
 found:
-	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
-		return err;
+	pci_read_config_dword(pdev, 0x58, &pmbase);
+	if (pmbase == (u32)~0)
+		return -ENODEV;
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0)
-- 
2.18.4

