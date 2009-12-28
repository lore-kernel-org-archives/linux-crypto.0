From: Max Vozeler <max@hinterhof.net>
Subject: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 28 Dec 2009 19:59:12 +0100
Message-ID: <1262026755-23056-2-git-send-email-max@hinterhof.net>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Cc: linux-crypto@nl.linux.org, Max Vozeler <max@hinterhof.net>,
	Milan Broz <mbroz@redhat.com>,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:45814 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZL1Tcz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 14:32:55 -0500
In-Reply-To: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The original code used cc->cipher for two things:

(a) It starts out containing the cipher mode string
("xts(aes)") used to get the ablkcipher.

(b) Then it gets overwritten to contain just the plain
cipher string ("aes") used to allocate the plain cipher
for essiv and for display by dm status.

So change it to be used only for the latter and put
cipher mode string on the stack.

Signed-off-by: Max Vozeler <max@hinterhof.net>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
---
 drivers/md/dm-crypt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a936372..e783f93 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1014,6 +1014,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	char *ivopts;
 	unsigned int key_size;
 	unsigned long long tmpll;
+	char ciphermode[CRYPTO_MAX_ALG_NAME];
 
 	if (argc != 5) {
 		ti->error = "Not enough arguments";
@@ -1049,13 +1050,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_cipher;
 	}
 
-	if (snprintf(cc->cipher, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+	if (snprintf(ciphermode, CRYPTO_MAX_ALG_NAME, "%s(%s)",
 		     chainmode, cipher) >= CRYPTO_MAX_ALG_NAME) {
 		ti->error = "Chain mode + cipher name is too long";
 		goto bad_cipher;
 	}
 
-	tfm = crypto_alloc_ablkcipher(cc->cipher, 0, 0);
+	tfm = crypto_alloc_ablkcipher(ciphermode, 0, 0);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm";
 		goto bad_cipher;
-- 
1.6.5.4

