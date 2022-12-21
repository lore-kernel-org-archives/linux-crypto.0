Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7E8C10F1B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 22:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiLUWng (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiLUWnI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 17:43:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEEE24097
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 14:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671662542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mv0JdiEUm8fY4r7rY54vtlemTUttCXqsgsmptQYzLmc=;
        b=XMvPRkschODKbo9XNSiYPwAWu24KeDatRB/jKOS2IfW6l7GXtpjrRKafzGFEP18S3qWJmP
        O8ZbzD9v17kw5ZllBDMqwZ25+Y+hX6PT+Gnn750eibPfk+SVOSvWM7Qa67d+qfLXIp4+/j
        ZhD+G/MR4hTG9WpKbHswbOsPl2wh1Zo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-fKIoZ0QBPd-fRFtYSUZekg-1; Wed, 21 Dec 2022 17:42:17 -0500
X-MC-Unique: fKIoZ0QBPd-fRFtYSUZekg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4522A858F0E;
        Wed, 21 Dec 2022 22:42:17 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-11.brq.redhat.com [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 409A040C2004;
        Wed, 21 Dec 2022 22:42:14 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     nstange@suse.de, elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de,
        vdronov@redhat.com
Subject: [PATCH 6/6] crypto: testmgr - allow ecdsa-nist-p256 and -p384 in FIPS mode
Date:   Wed, 21 Dec 2022 23:41:11 +0100
Message-Id: <20221221224111.19254-7-vdronov@redhat.com>
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

The kernel provides implementations of the NIST ECDSA signature
verification primitives. For key sizes of 256 and 384 bits respectively
they are approved and can be enabled in FIPS mode. Do so.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a223cf5f3626..795c4858c741 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5034,12 +5034,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecdsa-nist-p256",
 		.test = alg_test_akcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.akcipher = __VECS(ecdsa_nist_p256_tv_template)
 		}
 	}, {
 		.alg = "ecdsa-nist-p384",
 		.test = alg_test_akcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.akcipher = __VECS(ecdsa_nist_p384_tv_template)
 		}
-- 
2.38.1

