From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/3] crypto: properly handle null input and assoc data aead test vectors
Date: Wed, 15 Apr 2009 09:36:10 -0400
Message-ID: <200904150936.10800.jarod@redhat.com>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZDONgu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2009 09:36:50 -0400
In-Reply-To: <200904150935.15947.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currenty, if either input or associated data are null in an aead
test vector, we'll have random contents of the input and assoc
arrays. Similar to the iv, play it safe and zero out the contents.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bfee6e9..a8bdcb3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -314,8 +314,18 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			input = xbuf[0];
 			assoc = axbuf[0];
 
-			memcpy(input, template[i].input, template[i].ilen);
-			memcpy(assoc, template[i].assoc, template[i].alen);
+			if (template[i].input)
+				memcpy(input, template[i].input,
+				       template[i].ilen);
+			else
+				memset(input, 0, MAX_IVLEN);
+
+			if (template[i].assoc)
+				memcpy(assoc, template[i].assoc,
+				       template[i].alen);
+			else
+				memset(assoc, 0, MAX_IVLEN);
+
 			if (template[i].iv)
 				memcpy(iv, template[i].iv, MAX_IVLEN);
 			else
-- 
1.6.2.2


-- 
Jarod Wilson
jarod@redhat.com
