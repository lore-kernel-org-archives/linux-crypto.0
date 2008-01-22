From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] [CRYPTO]: constify function pointer tables
Date: Tue, 22 Jan 2008 20:44:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801222044100.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46076 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYAVToY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jan 2008 14:44:24 -0500
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 crypto/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 3d73323..24164b2 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -78,7 +78,7 @@ static int c_show(struct seq_file *m, void *p)
 	return 0;
 }
 
-static struct seq_operations crypto_seq_ops = {
+static const struct seq_operations crypto_seq_ops = {
 	.start		= c_start,
 	.next		= c_next,
 	.stop		= c_stop,
-- 
1.5.3.4
