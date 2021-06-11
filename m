Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B37DC48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 01:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D4F9610C7
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 01:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFKBav (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 21:30:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5495 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFKBav (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 21:30:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1NTP10SQzZdxc;
        Fri, 11 Jun 2021 09:26:01 +0800 (CST)
Received: from dggpemm500009.china.huawei.com (7.185.36.225) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 09:28:52 +0800
Received: from huawei.com (10.175.113.32) by dggpemm500009.china.huawei.com
 (7.185.36.225) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 09:28:51 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next v2] crypto: remove CRYPTOA_U32 and related functions
Date:   Fri, 11 Jun 2021 10:01:00 +0800
Message-ID: <20210611020100.2008894-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500009.china.huawei.com (7.185.36.225)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to the advice of Eric and Herbert, type CRYPTOA_U32
has been unused for over a decade, so remove the code related to
CRYPTOA_U32.

After removing CRYPTOA_U32, the type of the variable attrs can be
changed from union to struct.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
v1->v2: Fix format issue.

 crypto/algapi.c         | 18 ------------------
 crypto/algboss.c        | 31 ++++++-------------------------
 include/crypto/algapi.h |  1 -
 include/linux/crypto.h  |  5 -----
 4 files changed, 6 insertions(+), 49 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index fdabf2675b63..43f999dba4dc 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -868,24 +868,6 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
 
-int crypto_attr_u32(struct rtattr *rta, u32 *num)
-{
-	struct crypto_attr_u32 *nu32;
-
-	if (!rta)
-		return -ENOENT;
-	if (RTA_PAYLOAD(rta) < sizeof(*nu32))
-		return -EINVAL;
-	if (rta->rta_type != CRYPTOA_U32)
-		return -EINVAL;
-
-	nu32 = RTA_DATA(rta);
-	*num = nu32->num;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_attr_u32);
-
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 			struct crypto_alg *alg)
 {
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 5ebccbd6b74e..1814d2c5188a 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -28,16 +28,9 @@ struct cryptomgr_param {
 		struct crypto_attr_type data;
 	} type;
 
-	union {
+	struct {
 		struct rtattr attr;
-		struct {
-			struct rtattr attr;
-			struct crypto_attr_alg data;
-		} alg;
-		struct {
-			struct rtattr attr;
-			struct crypto_attr_u32 data;
-		} nu32;
+		struct crypto_attr_alg data;
 	} attrs[CRYPTO_MAX_ATTRS];
 
 	char template[CRYPTO_MAX_ALG_NAME];
@@ -104,12 +97,10 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	i = 0;
 	for (;;) {
-		int notnum = 0;
-
 		name = ++p;
 
 		for (; isalnum(*p) || *p == '-' || *p == '_'; p++)
-			notnum |= !isdigit(*p);
+			;
 
 		if (*p == '(') {
 			int recursion = 0;
@@ -123,7 +114,6 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 					break;
 			}
 
-			notnum = 1;
 			p++;
 		}
 
@@ -131,18 +121,9 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 		if (!len)
 			goto err_free_param;
 
-		if (notnum) {
-			param->attrs[i].alg.attr.rta_len =
-				sizeof(param->attrs[i].alg);
-			param->attrs[i].alg.attr.rta_type = CRYPTOA_ALG;
-			memcpy(param->attrs[i].alg.data.name, name, len);
-		} else {
-			param->attrs[i].nu32.attr.rta_len =
-				sizeof(param->attrs[i].nu32);
-			param->attrs[i].nu32.attr.rta_type = CRYPTOA_U32;
-			param->attrs[i].nu32.data.num =
-				simple_strtol(name, NULL, 0);
-		}
+		param->attrs[i].attr.rta_len = sizeof(param->attrs[i]);
+		param->attrs[i].attr.rta_type = CRYPTOA_ALG;
+		memcpy(param->attrs[i].data.name, name, len);
 
 		param->tb[i + 1] = &param->attrs[i].attr;
 		i++;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 86f0748009af..41d42e649da4 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -118,7 +118,6 @@ void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 			struct crypto_alg *alg);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index da5e0d74bb2f..3b9263d6122f 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -647,7 +647,6 @@ enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
 	CRYPTOA_TYPE,
-	CRYPTOA_U32,
 	__CRYPTOA_MAX,
 };
 
@@ -665,10 +664,6 @@ struct crypto_attr_type {
 	u32 mask;
 };
 
-struct crypto_attr_u32 {
-	u32 num;
-};
-
 /* 
  * Transform user interface.
  */
-- 
2.18.0.huawei.25

