Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850B5C433E2
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 18:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 655D121744
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 18:08:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qRJjKVSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgGSSIB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 14:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSSIB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 14:08:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3FFC0619D2;
        Sun, 19 Jul 2020 11:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=D+bIWePhzHxSHXZqtVGQdIeUuY0Gtn/vgiCXs1nMm0U=; b=qRJjKVSg3rFTpnQjTdm+K/NV9M
        pJxC/+Nv+asalBUxA1v/4XU9hXw/GM788pLjmHY1sCqnuBlUKRZQ8fxaHhrYOibnGUrjt2dadEABA
        ByFAkeNo6cF3bqo2vHFBc4jhhvVUFwiHKt7p4vBqyV4BEfDTLyRmhalUspcdgLiS6VIwWX1hsXc9E
        LKxlcFczoFA9u8ngoGMm5otEaF5fK4iitC++O+u7Gki0FryUvs4Bp7m21m90TI5OmsigwJDXiERLI
        XzYi66T+i3PgoqD4lK9wXyQ8sWikRjjQ0T6fKcdevXY/WsoGS0VDsohV7A+6SI83IfGy+xMhVwjxr
        pPlCAk5Q==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxDj7-00069C-QF; Sun, 19 Jul 2020 18:07:55 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: testmgr.h: delete duplicated words
Date:   Sun, 19 Jul 2020 11:07:50 -0700
Message-Id: <20200719180750.11862-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete the doubled word "from" in multiple places.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 crypto/testmgr.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20200717.orig/crypto/testmgr.h
+++ linux-next-20200717/crypto/testmgr.h
@@ -3916,7 +3916,7 @@ static const struct hash_testvec hmac_sm
 };
 
 /*
- * SHA1 test vectors  from from FIPS PUB 180-1
+ * SHA1 test vectors from FIPS PUB 180-1
  * Long vector from CAVS 5.0
  */
 static const struct hash_testvec sha1_tv_template[] = {
@@ -4103,7 +4103,7 @@ static const struct hash_testvec sha1_tv
 
 
 /*
- * SHA224 test vectors from from FIPS PUB 180-2
+ * SHA224 test vectors from FIPS PUB 180-2
  */
 static const struct hash_testvec sha224_tv_template[] = {
 	{
@@ -4273,7 +4273,7 @@ static const struct hash_testvec sha224_
 };
 
 /*
- * SHA256 test vectors from from NIST
+ * SHA256 test vectors from NIST
  */
 static const struct hash_testvec sha256_tv_template[] = {
 	{
@@ -4442,7 +4442,7 @@ static const struct hash_testvec sha256_
 };
 
 /*
- * SHA384 test vectors from from NIST and kerneli
+ * SHA384 test vectors from NIST and kerneli
  */
 static const struct hash_testvec sha384_tv_template[] = {
 	{
@@ -4632,7 +4632,7 @@ static const struct hash_testvec sha384_
 };
 
 /*
- * SHA512 test vectors from from NIST and kerneli
+ * SHA512 test vectors from NIST and kerneli
  */
 static const struct hash_testvec sha512_tv_template[] = {
 	{
