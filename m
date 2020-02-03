Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E760AC3524D
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 23:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEAD320674
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 23:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RT41u+dm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBCXjl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 18:39:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726331AbgBCXjl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 18:39:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580773180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5I1HAxr39AdpMHsVkl2MOFdKX0uTzBJ2hmslg/vYG7U=;
        b=RT41u+dmbxUqDN5EP7WGjLP860DDM9b7ky31nCksMJOtn9vfsQy5CxUIcAnUr81+e28ytX
        XUv/2920eJwJOuqzksB2UbtvoaSYXG9ZxWNhLrdmAfjyxJIIXFjYQ+TelzEKCpt4tixDuL
        xqkTn8YeNW+jsXA52L12Pa4sxujY97g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218--na7NXARP7GlWBouftFeDQ-1; Mon, 03 Feb 2020 18:39:38 -0500
X-MC-Unique: -na7NXARP7GlWBouftFeDQ-1
Received: by mail-wr1-f71.google.com with SMTP id t3so9029967wrm.23
        for <linux-crypto@vger.kernel.org>; Mon, 03 Feb 2020 15:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5I1HAxr39AdpMHsVkl2MOFdKX0uTzBJ2hmslg/vYG7U=;
        b=e47bBQmcSieOJlO5ZToa2sjQTH+aFUx2rsxgpax/cPVzah5LOPI89dS6PG59lIi4UG
         sbG4NACAggJeIg6TBCVnWJE6jCrR9E5txrlrXoO7AM6jdUSJ8nnFso/YmosbTSMGS7LM
         aiweT6nd6I0/CXqmQEzfGXzd1xqNmJZSP/gjiPFZJH2s6Pc10d+OLE9JfC25FDVpN6vi
         N2mGjigxFUFm+oEpRDyJvhVV0vzodYhllFWjkxKirnUhiVYv3mq2z/PmXLuIfDoKrh5o
         V3jz19sg4emrxK6eYGmjMnNF4fTBHn6Dsf/Z7od5VLoPS3dw/HiOxrxBQlhqtyOBg50o
         i9sQ==
X-Gm-Message-State: APjAAAWDxZCiS5CWrsOCj3E278jqKu+TK/aOUOiRaZAwOHTsVwXkhycW
        mL3JWAlRXUEzWZSgbC/tR0Su0+GP2JpS56NRrS06BnmCKstT70HLwrVJdpdzodKdmwME5JxF+G8
        3KLWsPyys6qXokca8QgxjdK7U
X-Received: by 2002:a5d:6692:: with SMTP id l18mr17323059wru.382.1580773177188;
        Mon, 03 Feb 2020 15:39:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZsbPh5JGaqRxiFxIHmn8GVyOzze6usAiUfosb3U5cluC+GypdbmtQRvgfeOTfq2Jb0PdZjw==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr17323047wru.382.1580773177034;
        Mon, 03 Feb 2020 15:39:37 -0800 (PST)
Received: from raver.teknoraver.net (net-2-36-173-8.cust.vodafonedsl.it. [2.36.173.8])
        by smtp.gmail.com with ESMTPSA id h17sm28264258wrs.18.2020.02.03.15.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 15:39:36 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH] crypto: arm64/poly1305: ignore build files
Date:   Tue,  4 Feb 2020 00:39:33 +0100
Message-Id: <20200203233933.19577-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add arch/arm64/crypto/poly1305-core.S to .gitignore
as it's built from poly1305-core.S_shipped

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 arch/arm64/crypto/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/.gitignore b/arch/arm64/crypto/.gitignore
index 879df8781ed5..e403b1343328 100644
--- a/arch/arm64/crypto/.gitignore
+++ b/arch/arm64/crypto/.gitignore
@@ -1,2 +1,3 @@
 sha256-core.S
 sha512-core.S
+poly1305-core.S
-- 
2.24.1

