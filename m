From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 4/4] md: dm-crypt: Initialize the sector number for one request
Date: Thu,  3 Mar 2016 13:19:39 +0800
Message-ID: <7c56c594c2398b4d5740d733d7e98d6586217819.1456981315.git.baolin.wang@linaro.org>
References: <cover.1456981314.git.baolin.wang@linaro.org>
Cc: akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, robert.jarzmik@free.fr,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	baolin.wang@linaro.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1456981314.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1456981314.git.baolin.wang@linaro.org>
References: <cover.1456981314.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

