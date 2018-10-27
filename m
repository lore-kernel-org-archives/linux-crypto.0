Return-Path: <SRS0=Hu3O=NH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52299 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbeJ0Xaq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Oct 2018 19:30:46 -0400
From: Colin King <colin.king@canonical.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcrypt: use format specifier in kobject_add
Date: Sat, 27 Oct 2018 15:49:26 +0100
Message-Id: <20181027144926.8433-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Passing string 'name' as the format specifier is potentially hazardous
because name could (although very unlikely to) have a format specifier
embedded in it causing issues when parsing the non-existent arguments
to these.  Follow best practice by using the "%s" format string for
the string 'name'.

Cleans up clang warning:
crypto/pcrypt.c:397:40: warning: format string is not a string literal
(potentially insecure) [-Wformat-security]

Fixes: a3fb1e330dd2 ("pcrypt: Added sysfs interface to pcrypt")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/pcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index f8ec3d4ba4a8..29d2cf989c05 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -394,7 +394,7 @@ static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 	int ret;
 
 	pinst->kobj.kset = pcrypt_kset;
-	ret = kobject_add(&pinst->kobj, NULL, name);
+	ret = kobject_add(&pinst->kobj, NULL, "%s", name);
 	if (!ret)
 		kobject_uevent(&pinst->kobj, KOBJ_ADD);
 
-- 
2.19.1
