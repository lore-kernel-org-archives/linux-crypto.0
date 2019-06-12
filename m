Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C94DC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013CB20866
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 13:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405847AbfFLNdY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbfFLNdX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 09:33:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0CA2A3B64;
        Wed, 12 Jun 2019 13:33:20 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-159.ams2.redhat.com [10.36.116.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF3C078DF0;
        Wed, 12 Jun 2019 13:33:18 +0000 (UTC)
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
Subject: [PATCH v3 3/4] s390/crypto: prng: Use -ENODEV instead of -EOPNOTSUPP
Date:   Wed, 12 Jun 2019 15:33:05 +0200
Message-Id: <20190612133306.10231-4-david@redhat.com>
In-Reply-To: <20190612133306.10231-1-david@redhat.com>
References: <20190612133306.10231-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 12 Jun 2019 13:33:23 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Let's use the error value that is typically used if HW support is not
available when trying to load a module - this is also what systemd's
systemd-modules-load.service expects.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/crypto/prng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 12cca467af7d..d977643fa627 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -824,7 +824,7 @@ static int __init prng_init(void)
 
 	/* check if the CPU has a PRNG */
 	if (!cpacf_query_func(CPACF_KMC, CPACF_KMC_PRNG))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 
 	/* check if TRNG subfunction is available */
 	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
@@ -837,7 +837,7 @@ static int __init prng_init(void)
 			if (prng_mode == PRNG_MODE_SHA512) {
 				pr_err("The prng module cannot "
 				       "start in SHA-512 mode\n");
-				return -EOPNOTSUPP;
+				return -ENODEV;
 			}
 			prng_mode = PRNG_MODE_TDES;
 		} else
-- 
2.21.0

