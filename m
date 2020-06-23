Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD4EC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 17:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C5C206D4
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592934149;
	bh=yWjydtHHG+r6V6UOLuq9t6zwh/FKdtVOlOZZv90+lzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TIVmpTD0+vpfvGkZrcgOE5ogK6ABPGELY2Kpv2GXcgxz1EERIURXe2s7JwWd9F1CF
	 N9j+w2lGM/OxX/9dLDpSXrX7JZ4oHgHUOg1woC9oxZwSBycttJj7ACf4PA4OwMBxhb
	 Nm4tXonasgb4LbLP11A+CrC4eoE1h3VPdr1nWtlk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733149AbgFWRkt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387472AbgFWRgG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A9920809;
        Tue, 23 Jun 2020 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933766;
        bh=yWjydtHHG+r6V6UOLuq9t6zwh/FKdtVOlOZZv90+lzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usYzGPt5UZV2qU4SFWScSu6glp39GzWU7A4wA+0uKTO5Vw5fCb7VG0Q3tmt+Q107q
         mJKBAYhqy/gZ6CVjdU773FjDgNS5cJyLfDE6KvpTyndknqZRD567Jao6mLD8bXW3sa
         XBugWPOGPDNPnh0M5cDdpJbT5EVUXaE8eCqF1EUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/24] hwrng: ks-sa - Fix runtime PM imbalance on error
Date:   Tue, 23 Jun 2020 13:35:40 -0400
Message-Id: <20200623173559.1355728-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 95459261c99f1621d90bc628c2a48e60b7cf9a88 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a pairing decrement is needed
on the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ks-sa-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index a67430010aa68..5c7d3dfcfdd04 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -208,6 +208,7 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to enable SA power-domain\n");
+		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(dev);
 		return ret;
 	}
-- 
2.25.1

