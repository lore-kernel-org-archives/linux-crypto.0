From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/11] crypto: seqiv - Fix module unload/reload crash
Date: Wed, 27 May 2015 14:37:40 +0800
Message-ID: <E1YxUyC-0006ng-Qw@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50315 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbE0Gho (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:44 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUyD-0005eM-GI
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:41 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On module unload we weren't unregistering the seqniv template,
thus leading to a crash the next time someone walks the template
list.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index c0dba8f..2333974 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -874,6 +874,7 @@ out_undo_niv:
 
 static void __exit seqiv_module_exit(void)
 {
+	crypto_unregister_template(&seqniv_tmpl);
 	crypto_unregister_template(&seqiv_tmpl);
 }
 
