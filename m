From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 4/4] md: dm-crypt: Initialize the sector number for one request
Date: Tue, 15 Mar 2016 15:48:02 +0800
Message-ID: <db3291f8338ef47059c64b10d4510d506acaac3d.1458023699.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33096 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbcCOHs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2016 03:48:57 -0400
Received: by mail-pf0-f181.google.com with SMTP id 124so18013778pfg.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2016 00:48:56 -0700 (PDT)
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the crypto engine can support the bulk mode, that means the contiguous
requests from one block can be merged into one request to be handled by
crypto engine. If so, the crypto engine need the sector number of one request
to do merging action.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3147c8d..9e2dbfd 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -866,6 +866,7 @@ static int crypt_convert_block(struct crypt_config *cc,
 			return r;
 	}
 
+	req->sector = ctx->cc_sector;
 	ablkcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
 				     1 << SECTOR_SHIFT, iv);
 
-- 
1.7.9.5
