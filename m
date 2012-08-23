From: Ben Collins <ben.c@servergy.com>
Subject: [PATCH] crypto/caam: Export gen_split_key symbol for other modules
Date: Thu, 23 Aug 2012 18:39:57 -0400
Message-ID: <BD4C563D-C5E9-494F-91DD-EA145917FCEC@servergy.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Yuan Kang <Yuan.Kang@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:53963 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752963Ab2HWWqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Aug 2012 18:46:48 -0400
Received: by pbbrq2 with SMTP id rq2so2087747pbb.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Aug 2012 15:46:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In 3.6-rc3, without this patch, the following error occurs with a modular build:

ERROR: "gen_split_key" [drivers/crypto/caam/caamhash.ko] undefined!
ERROR: "gen_split_key" [drivers/crypto/caam/caamalg.ko] undefined!

Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yuan Kang <Yuan.Kang@freescale.com>

diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 0028881..d216cd3 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -120,3 +120,4 @@ u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 
 	return ret;
 }
+EXPORT_SYMBOL(gen_split_key);

--
Ben Collins
Servergy, Inc.
