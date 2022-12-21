Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6ADC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 22:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiLUWnm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiLUWnL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 17:43:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACC920F72
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 14:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671662537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9hhi/SANunKmoKwXebRhuBJH3zZsPz8xdoxFhR57EY=;
        b=O1fjfbZONIwrQ/ynVVlv7UQckfsBS0mOIj7qJKRjeziGE73fG99xF2cv4Mg4U86CwsAWuN
        BpDRf2QslxoOtLk/KiVev6DPdaba86Mo/5jN9ZAgfMtroQ84I7++CbBI3Hd9Cquf1UUXvs
        vNXXLlHf7ab0L5pdddM/+9qCFKb+++E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-nYX_X2v-NmSrQ-6l_vld1g-1; Wed, 21 Dec 2022 17:42:14 -0500
X-MC-Unique: nYX_X2v-NmSrQ-6l_vld1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79D2329AA385;
        Wed, 21 Dec 2022 22:42:13 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-11.brq.redhat.com [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7BCB40C2064;
        Wed, 21 Dec 2022 22:42:11 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     nstange@suse.de, elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de,
        vdronov@redhat.com
Subject: [PATCH 5/6] crypto: testmgr - disallow plain ghash in FIPS mode
Date:   Wed, 21 Dec 2022 23:41:10 +0100
Message-Id: <20221221224111.19254-6-vdronov@redhat.com>
In-Reply-To: <20221221224111.19254-1-vdronov@redhat.com>
References: <20221221224111.19254-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

ghash may be used only as part of the gcm(aes) construction in FIPS
mode. Since commit d6097b8d5d55 ("crypto: api - allow algs only in specific
constructions in FIPS mode") there's support for using spawns which by
itself are marked as non-approved from approved template instantiations.
So simply mark plain ghash as non-approved in testmgr to block any attempts
of direct instantiations in FIPS mode.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 crypto/testmgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 562463a77a76..a223cf5f3626 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5125,7 +5125,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ghash",
 		.test = alg_test_hash,
-		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(ghash_tv_template)
 		}
-- 
2.38.1

