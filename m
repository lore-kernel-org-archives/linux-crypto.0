Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C29FC3DA79
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Dec 2022 21:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiL2VSc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiL2VSW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2022 16:18:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9D1DF76
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 13:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672348655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9hhi/SANunKmoKwXebRhuBJH3zZsPz8xdoxFhR57EY=;
        b=YtvZtUP2tF1m1E5eIvz8Nh+RPowIoheZFHavyo1ASndgS4QGPDdnznbPH+KW7Kb9vhBbzJ
        Eewea11eT+ueP48tEDHuZdeqBqJPU1jImeXIHW3lt98rFyNxVWMWjsDj4bQjqGI435XLOu
        3LMWpG9TLh0qQyJWPRCvelZ0rw9IGwc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-6Ovcs_-INPSoQJHseSVycg-1; Thu, 29 Dec 2022 16:17:33 -0500
X-MC-Unique: 6Ovcs_-INPSoQJHseSVycg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13A62101B429;
        Thu, 29 Dec 2022 21:17:33 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-2.brq.redhat.com [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2568492B00;
        Thu, 29 Dec 2022 21:17:30 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Nicolai Stange <nstange@suse.de>, Elliott Robert <elliott@hpe.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH v3 5/6] crypto: testmgr - disallow plain ghash in FIPS mode
Date:   Thu, 29 Dec 2022 22:17:09 +0100
Message-Id: <20221229211710.14912-6-vdronov@redhat.com>
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

