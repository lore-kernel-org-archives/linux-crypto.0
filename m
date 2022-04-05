Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BB3C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Apr 2022 08:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiDEJAJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 05:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244215AbiDEIvu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 04:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AB1D3AF4;
        Tue,  5 Apr 2022 01:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF2361516;
        Tue,  5 Apr 2022 08:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C87C385A5;
        Tue,  5 Apr 2022 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148013;
        bh=4MlSW4cAS64L9zVTicoHovuyU0G38E9keWqJ6LuGm+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2CjkHF5M9rcop+YVZtlWDkO07Ay4nvcdzIR0WrmGHTrqyyM9Q4MpjQMrnRWDRCYf
         H8TVZ2vfBkKLrH+rYgXmeB4wiO9VmDmmDgZCWxd6pxsLmlS1B4q3VcnUmXCMq7JCKr
         ihovbgn4rHMatPNP/aWa8bJnKfejdCkQ+LZKdevk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0203/1017] crypto: ccp - Ensure psp_ret is always initd in __sev_platform_init_locked()
Date:   Tue,  5 Apr 2022 09:18:36 +0200
Message-Id: <20220405070400.276279078@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit 1e1ec11d3ec3134e05d4710f4dee5f9bd05e828d ]

Initialize psp_ret inside of __sev_platform_init_locked() because there
are many failure paths with PSP initialization that do not set
__sev_do_cmd_locked().

Fixes: e423b9d75e77: ("crypto: ccp - Move SEV_INIT retry for corrupted data")

Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 581a1b13d5c3..de015995189f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -241,7 +241,7 @@ static int __sev_platform_init_locked(int *error)
 	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
 	struct sev_device *sev;
-	int psp_ret, rc = 0;
+	int psp_ret = -1, rc = 0;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
-- 
2.34.1



