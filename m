Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD97C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4264C208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbfFLKW4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfFLKWy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 06:22:54 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C81280F79;
        Wed, 12 Jun 2019 10:22:54 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-159.ams2.redhat.com [10.36.116.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A4456A492;
        Wed, 12 Jun 2019 10:22:52 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/4] s390/pkey: Use -ENODEV instead of -EOPNOTSUPP
Date:   Wed, 12 Jun 2019 12:22:45 +0200
Message-Id: <20190612102248.18903-2-david@redhat.com>
In-Reply-To: <20190612102248.18903-1-david@redhat.com>
References: <20190612102248.18903-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 12 Jun 2019 10:22:54 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

systemd-modules-load.service automatically tries to load the pkey module
on systems that have MSA.

Pkey also requires the MSA3 facility and a bunch of subfunctions.
Failing with -EOPNOTSUPP makes "systemd-modules-load.service" fail on
any system that does not have all needed subfunctions. For example,
when running under QEMU TCG (but also on systems where protected keys
are disabled via the HMC).

Let's use -ENODEV, so systemd-modules-load.service properly ignores
failing to load the pkey module because of missing HW functionality.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/s390/crypto/pkey_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 45eb0c14b880..ddfcefb47284 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1695,15 +1695,15 @@ static int __init pkey_init(void)
 	 * are able to work with protected keys.
 	 */
 	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 
 	/* check for kmc instructions available */
 	if (!cpacf_query(CPACF_KMC, &kmc_functions))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
 	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
 	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 
 	pkey_debug_init();
 
-- 
2.21.0

