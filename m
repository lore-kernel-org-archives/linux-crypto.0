From: weiyj_lk@163.com
Subject: [PATCH -next] PKCS#7: fix sparse non static symbol warning
Date: Mon, 28 Jul 2014 21:17:12 +0800
Message-ID: <1406553432-29676-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:47837 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaG1NRm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 09:17:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

crypto/asymmetric_keys/pkcs7_key_type.c:73:17: warning:
 symbol 'key_type_pkcs7' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index 8605ff6..9c60e9c 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -70,7 +70,7 @@ error:
  * user defined keys take an arbitrary string as the description and an
  * arbitrary blob of data as the payload
  */
-struct key_type key_type_pkcs7 = {
+static struct key_type key_type_pkcs7 = {
 	.name			= "pkcs7_test",
 	.def_lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
 	.preparse		= pkcs7_preparse,
