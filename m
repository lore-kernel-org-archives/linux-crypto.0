From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: [PATCH] crypto: rsa-pkcs1pad - Fix akcipher request allocation
Date: Thu, 14 Jul 2016 20:39:18 -0700
Message-ID: <bed68e2b-6397-1663-606c-6f19695d94ed@gmail.com>
References: <1468491905-2597-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	andrew.zaborowski@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32873 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbcGODj2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 23:39:28 -0400
Received: by mail-pf0-f195.google.com with SMTP id i6so5368631pfe.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Jul 2016 20:39:27 -0700 (PDT)
In-Reply-To: <1468491905-2597-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Salvatore,
On 07/14/2016 03:25 AM, Salvatore Benedetto wrote:
> Embedding the akcipher_request in pkcs1pad_request don't take
> into account the context space required by the akcipher object.

I think we do take into account the sub request context. See line 675.
The only thing that is wrong is that the child_req should be at
the end of the structure. This is build tested only.

---8<---
From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: rsa-pkcs1pad - fix rsa-pkcs1pad request struct

To allow for child request context the struct akcipher_request child_req
needs to be at the end of the structure.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa-pkcs1pad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 880d3db..877019a 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -101,10 +101,9 @@ struct pkcs1pad_inst_ctx {
 };
 
 struct pkcs1pad_request {
-	struct akcipher_request child_req;
-
 	struct scatterlist in_sg[2], out_sg[1];
 	uint8_t *in_buf, *out_buf;
+	struct akcipher_request child_req;
 };
 
 static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
