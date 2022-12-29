Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9318EC46467
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Dec 2022 21:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiL2VS1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiL2VSR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A63A9FF0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 13:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672348648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HInbXzTW3Cb08AWmdq+dd1m19tc/OaqTF+DjibQiGV4=;
        b=c2sw2V+yh25IOTyTIW9MGybcOjZ6vI6xo9Ixrv5XOc59ECfWIIr3ls8NnPTpEW4ZJ/iaNH
        fmlyUc2WakfVSyYciI5ziHbL9HWVhdipYcRW7S84jpDp602SO8YTx5386XLVjtXTc3FvHr
        aGasklOaVw850HonWrPyxAX7oMeFPaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-b4_ZkEDMNJOK7ZlJvgxDyw-1; Thu, 29 Dec 2022 16:17:23 -0500
X-MC-Unique: b4_ZkEDMNJOK7ZlJvgxDyw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 825CC8533DA;
        Thu, 29 Dec 2022 21:17:22 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-2.brq.redhat.com [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E53C492B00;
        Thu, 29 Dec 2022 21:17:20 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolai Stange <nstange@suse.de>, Elliott Robert <elliott@hpe.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH v3 1/6] crypto: xts - restrict key lengths to approved values in FIPS mode
Date:   Thu, 29 Dec 2022 22:17:05 +0100
Message-Id: <20221229211710.14912-2-vdronov@redhat.com>
In-Reply-To: <20221229211710.14912-1-vdronov@redhat.com>
References: <20221229211710.14912-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

