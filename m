From: "Benjamin Gilbert" <bgilbert@cs.cmu.edu>
Subject: [PATCH 2/3] crypto: api - Remove digest case from procfs show handler
Date: Thu,  8 Oct 2009 17:41:04 -0400
Message-ID: <1255038065-3113-3-git-send-email-bgilbert@cs.cmu.edu>
References: <1255038065-3113-1-git-send-email-bgilbert@cs.cmu.edu>
 <1255038065-3113-2-git-send-email-bgilbert@cs.cmu.edu>
Cc: linux-crypto@vger.kernel.org,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from SMTP03.SRV.CS.CMU.EDU ([128.2.217.198]:32782 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZJHVrs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2009 17:47:48 -0400
In-Reply-To: <1255038065-3113-2-git-send-email-bgilbert@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove special handling of old-style digest algorithms from the procfs
show handler.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---
 crypto/proc.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 5dc07e4..ff4cb4a 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -115,13 +115,6 @@ static int c_show(struct seq_file *m, void *p)
 		seq_printf(m, "max keysize  : %u\n",
 					alg->cra_cipher.cia_max_keysize);
 		break;
-		
-	case CRYPTO_ALG_TYPE_DIGEST:
-		seq_printf(m, "type         : digest\n");
-		seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-		seq_printf(m, "digestsize   : %u\n",
-		           alg->cra_digest.dia_digestsize);
-		break;
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		seq_printf(m, "type         : compression\n");
 		break;
-- 
1.5.6.5

