Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28FAC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDFC22082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 10:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407987AbfFLKXF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407254AbfFLKXE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 06:23:04 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 21158C0587F5;
        Wed, 12 Jun 2019 10:23:04 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-159.ams2.redhat.com [10.36.116.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4D3560CCC;
        Wed, 12 Jun 2019 10:22:59 +0000 (UTC)
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
Subject: [PATCH v2 4/4] s390/crypto: sha: Use -ENODEV instead of -EOPNOTSUPP
Date:   Wed, 12 Jun 2019 12:22:48 +0200
Message-Id: <20190612102248.18903-5-david@redhat.com>
In-Reply-To: <20190612102248.18903-1-david@redhat.com>
References: <20190612102248.18903-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 12 Jun 2019 10:23:04 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Let's use the error value that is typically used if HW support is not
available when trying to load a module - this is also what systemd's
systemd-modules-load.service expects.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/crypto/sha1_s390.c   | 2 +-
 arch/s390/crypto/sha256_s390.c | 2 +-
 arch/s390/crypto/sha512_s390.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index 009572e8276d..7c15542d3685 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -86,7 +86,7 @@ static struct shash_alg alg = {
 static int __init sha1_s390_init(void)
 {
 	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_1))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 	return crypto_register_shash(&alg);
 }
 
diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
index 62833a1d8724..af7505148f80 100644
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -117,7 +117,7 @@ static int __init sha256_s390_init(void)
 	int ret;
 
 	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_256))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 	ret = crypto_register_shash(&sha256_alg);
 	if (ret < 0)
 		goto out;
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index be589c340d15..ad29db085a18 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -127,7 +127,7 @@ static int __init init(void)
 	int ret;
 
 	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA_512))
-		return -EOPNOTSUPP;
+		return -ENODEV;
 	if ((ret = crypto_register_shash(&sha512_alg)) < 0)
 		goto out;
 	if ((ret = crypto_register_shash(&sha384_alg)) < 0)
-- 
2.21.0

