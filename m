Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150FCC3DA7D
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Dec 2022 20:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiL2Uja (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Dec 2022 15:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiL2Uis (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2022 15:38:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEF8167ED
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 12:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672346275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HocLF/KBTVlQUJt7QQMW7FIy1E4x5xixVjqadrM9WOY=;
        b=iaO9kE1mf0wDTaOV7g59V6ev9vpMlXAHzgvtkDMC1/wvfIC/2O8JbtDETKW3z6XzTUFOKi
        1pQGdffP1W92bcCk1MuiCR25GLT/SH5jJS5JUlIiTD7IBaJj9x7BIcp4bdn18sg4jGAMNt
        hUJ5ViohABVPs6xCxz2P8lh+NBj/980=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-3X_ffHm3OjeLDsUUQMHdMQ-1; Thu, 29 Dec 2022 15:37:51 -0500
X-MC-Unique: 3X_ffHm3OjeLDsUUQMHdMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96D6229ABA00;
        Thu, 29 Dec 2022 20:37:50 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-2.brq.redhat.com [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61AE1112132C;
        Thu, 29 Dec 2022 20:37:48 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolai Stange <nstange@suse.de>, Elliott Robert <elliott@hpe.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH v2 4/6] crypto: testmgr - disallow plain cbcmac(aes) in FIPS mode
Date:   Thu, 29 Dec 2022 21:37:06 +0100
Message-Id: <20221229203708.13628-5-vdronov@redhat.com>
In-Reply-To: <20221229203708.13628-1-vdronov@redhat.com>
References: <20221229203708.13628-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

cbcmac(aes) may be used only as part of the ccm(aes) construction in FIPS
mode. Since commit d6097b8d5d55 ("crypto: api - allow algs only in specific
constructions in FIPS mode") there's support for using spawns which by
itself are marked as non-approved from approved template instantiations.
So simply mark plain cbcmac(aes) as non-approved in testmgr to block any
attempts of direct instantiations in FIPS mode.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4476ac97baa5..562463a77a76 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4501,7 +4501,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 #endif
 		.alg = "cbcmac(aes)",
-		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(aes_cbcmac_tv_template)
-- 
2.38.1

