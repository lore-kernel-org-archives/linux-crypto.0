Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D61C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5422421855
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sf/yNlYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfAYJb5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:31:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53658 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfAYJb5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 04:31:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so6055112wmb.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 01:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1D3vIUMKU4kBDwV23M97IGNJ2DSMM/kCwxgNrzbXI5A=;
        b=Sf/yNlYa4o499i3hneEq5vTJQ0Tz1lG8uaP+tdiVZgxgfhkMa2jtySY1ioKIWomHJR
         o4VMy/7JV1zcSiJhRMrGbIaPaTfPeL7IDb5YErMUvtzKjwEFTrJebplKBTtsbPaGsnJ6
         x8CNN2u1b74NAAAvJLezGWIQ+MVre/aFSJIYIvUR4PDI/O+ui8+7ZKQP9hW7ntw/Zxl3
         qLzQXTmSKrGxRqOM7utCtODg3UyLXLpX9LpBuhADmxDZG1g1B0lryoS/itmhn0iYPzhE
         b/qUm2wsdjn2dVGA7otUD0VR8jXGF4PUzmIf59hZprNYYX4yrx3m1kOc0WtsoPOWDS8d
         G9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1D3vIUMKU4kBDwV23M97IGNJ2DSMM/kCwxgNrzbXI5A=;
        b=Rv4DSkTB7pT/rqzPhkPQvUpYsOrsu6BLFZyZtG6cBDhvCf8NBHo2u0KUhXe1LljEuN
         JMsF4dAt28huIBiwPbyabSGSzYSATXoNCYQ8DhB3+FUfXq8/nbQofB5GJKnPg93r2y6t
         dQlPXxFaqp8shPnRMb1UjtYBdR63zEZLQAeIzAelmRTPYJw3YuYq8RAlugZ5P9ArIQL2
         u+sioaVyqpFSFvEkwNg6jOKsBO7QNh5rfyGE9Pvh4cvc7E6BozSrnApjohzsTWvwnbiq
         cp7zI+FRWyx/bXRH0t/LOcPISCeOpOMmwxvs1cM3RiPkrNxcyPjbeqL0aLbqhWNuYsA1
         UmSQ==
X-Gm-Message-State: AJcUukcjXJFmpIlcJFS6S/Mu0evgK5CDqwGK+//FXLnCaPOW1xJJSCQH
        DHyDFhZ1QoYrc8kjBc4yDo4AVFBK
X-Google-Smtp-Source: ALg8bN6PaNGTCbvE495NgIfQR2JFZdwSZ7HoJlqizksEJ5yB7apxLvcIWVjphi5m32v4R3csxEFcjw==
X-Received: by 2002:a1c:f207:: with SMTP id s7mr5935487wmc.87.1548408715413;
        Fri, 25 Jan 2019 01:31:55 -0800 (PST)
Received: from merlot.mazyland.net (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.googlemail.com with ESMTPSA id x15sm141591928wrs.27.2019.01.25.01.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 01:31:54 -0800 (PST)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto: mark crc32 checksum as FIPS allowed
Date:   Fri, 25 Jan 2019 10:31:47 +0100
Message-Id: <20190125093147.10266-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CRC32 is not a cryptographic hash algorithm,
so the FIPS restrictions should not apply to it.
(The CRC32C variant is already allowed.)

This CRC32 variant is used for in dm-crypt legacy TrueCrypt
IV implementation (tcw); detected by cryptsetup test suite
failure in FIPS mode.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f684a414acb..82bc0398bbbf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2735,6 +2735,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "crc32",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(crc32_tv_template)
 		}
-- 
2.20.1

