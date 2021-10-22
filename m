Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7D6C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A446120D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhJVMrX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Oct 2021 08:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhJVMrW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Oct 2021 08:47:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEA9C061764
        for <linux-crypto@vger.kernel.org>; Fri, 22 Oct 2021 05:45:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q187so3232086pgq.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 Oct 2021 05:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZSXmIrLAl3afDK6PDwyIug/C44A4sTZ8Dy+DY6Ye0ow=;
        b=j/eeSmTftC+fX6ii84ej2gB8cRlWJXJkFFRQkTdkZnibrqmxuskKe7zLJvuS1XxUog
         nrZxWKYuJgWBCViue7eD28TlwwRdvrNhxR4oE/q0BuIH+YcJa6S6O9jT1YhWr8JcSKsk
         FauFQs6iai/1WwRXQNxEs/2A80gwa25+HK23OFK39QvKgL2d4Kdw0KahlCkWFFrVZ0Qr
         x7pku5D8qYXg7MTIfoTxBtW96StjCmohNsUbLT6XArmqNpmtelspxs/rCwChba8Fb2ug
         pXOuQtAeuf4/7NQno20CXBw4/wRYeKNWhrD8oCaKhTCpkv7WRDh2XHt0JlsMHzJ/Vywy
         Y0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZSXmIrLAl3afDK6PDwyIug/C44A4sTZ8Dy+DY6Ye0ow=;
        b=rJutOwYtwuS9zUXs/Y9bcRuY9vo/3gjfEMvIU4rzfyAQ8dYBvIE3WLcOQ7WZntr1vI
         9zrLU9WMFwbLiR6vP+uTLnPtyoRwkQ7nY+aQnfCawv8eJRgr5B5hmDJcQknh6xW5CI1/
         iEEPtQMEDBcVqBsGuJHfdBo6VKMv/f9kiGyZpzG/nqyB+Lfn5HLObVTFg7k5Vhd3Rdo3
         e3iVEi08lQQHFBPWUjdXvfHTO8OJB48t5p9RN9qyImLNRriibngPOOER+LqBJBojGSHB
         RvHvDQgCbWX/KBBNYrV7B5ucASNbaX1ceI+VpeNZ2rmZ4CxpCSpLFxv940TOjzi73YWi
         jwWw==
X-Gm-Message-State: AOAM533Hwhq72hrkoZoggcFdk21Jq2YnYvPR8vrH9Uk65Q9gHp8hkDVG
        pLrsxOO3pLN3foms9TCUBHG7cg==
X-Google-Smtp-Source: ABdhPJyu+jyaytCJXIE2r1mV+7xe0zsPOL+R6IxiX0E1NaOcTm8JqqVJ7HSp6m8ahkaVBN/CfKkUfw==
X-Received: by 2002:a63:8c54:: with SMTP id q20mr7339066pgn.420.1634906705002;
        Fri, 22 Oct 2021 05:45:05 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id rj6sm13906646pjb.30.2021.10.22.05.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Oct 2021 05:45:04 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        helei.sig11@bytedance.com, zhenweipi@bytedance.com
Subject: [PATCH] crypto testmgr: fix wrong key length
Date:   Fri, 22 Oct 2021 20:44:43 +0800
Message-Id: <20211022124443.61507-1-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix wrong test data at testmgr.h, it seems to be caused
by ignoring the last '\0' when calling sizeof.

Signed-off-by: Lei He <helei.sig11@bytedance.com>
---
 crypto/testmgr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e6fca34b5b25..779720bf9364 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1201,7 +1201,7 @@ static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
 	"\xd1\x86\x48\x55\xce\x83\xee\x8e\x51\xc7\xde\x32\x12\x47\x7d\x46"
 	"\xb8\x35\xdf\x41\x02\x01\x00\x02\x01\x00\x02\x01\x00\x02\x01\x00"
 	"\x02\x01\x00",
-	.key_len = 804,
+	.key_len = 803,
 	/*
 	 * m is SHA256 hash of following message:
 	 * "\x49\x41\xbe\x0a\x0c\xc9\xf6\x35\x51\xe4\x27\x56\x13\x71\x4b\xd0"
-- 
2.11.0

