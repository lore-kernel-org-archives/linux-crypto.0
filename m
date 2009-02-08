From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 06/10] crypto/des_generic: des_generic_mod_init
 simplification.
Date: Sun, 08 Feb 2009 06:53:12 -0500
Message-ID: <20090208115312.5455.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17665 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752725AbZBHL7y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:59:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

---
 crypto/des_generic.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index d9a81d8..647189e 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -934,9 +934,7 @@ MODULE_ALIAS("des3_ede");
 
 static int __init des_generic_mod_init(void)
 {
-	int ret = 0;
