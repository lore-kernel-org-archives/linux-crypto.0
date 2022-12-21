Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A57C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 22:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiLUWm1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbiLUWmZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 17:42:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC21425C6
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 14:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671662499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HInbXzTW3Cb08AWmdq+dd1m19tc/OaqTF+DjibQiGV4=;
        b=V+37GQdGcNHX80ghWSmP1ow1Rrfy9Nnq0QKelH2wAQ/Nn3nEVIonLvumMuIE3+u+oyd4XU
        +EQUrICDPdeUPKWulIwGWMag5PqpA4YXuc0bNRkjRqO2VqiOCUvpqgSmKSfAHpNSo+rzFG
        b4Jnr1eJfdKMzZD8RlguSQR+frPHV+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-8dHjQDtpMTyIwbTTfApP6A-1; Wed, 21 Dec 2022 17:41:36 -0500
X-MC-Unique: 8dHjQDtpMTyIwbTTfApP6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C521196EF88;
        Wed, 21 Dec 2022 22:41:36 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-11.brq.redhat.com [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 108F840C2064;
        Wed, 21 Dec 2022 22:41:33 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     nstange@suse.de, elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de,
        vdronov@redhat.com
Subject: [PATCH 1/6] crypto: xts - restrict key lengths to approved values in FIPS mode
Date:   Wed, 21 Dec 2022 23:41:06 +0100
Message-Id: <20221221224111.19254-2-vdronov@redhat.com>
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

According to FIPS 140-3 IG C.I., only (total) key lengths of either
256 bits or 512 bits are allowed with xts(aes). Make xts_verify_key() to
reject anything else in FIPS mode.

As xts(aes) is the only approved xts() template instantiation in FIPS mode,
the new restriction implemented in xts_verify_key() effectively only
applies to this particular construction.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 include/crypto/xts.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 0f8dba69feb4..a233c1054df2 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -35,6 +35,13 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	if (keylen % 2)
 		return -EINVAL;
 
+	/*
+	 * In FIPS mode only a combined key length of either 256 or
+	 * 512 bits is allowed, c.f. FIPS 140-3 IG C.I.
+	 */
+	if (fips_enabled && keylen != 32 && keylen != 64)
+		return -EINVAL;
+
 	/* ensure that the AES and tweak key are not identical */
 	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
 			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
-- 
2.38.1

