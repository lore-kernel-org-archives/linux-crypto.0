From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/18] crypto: lrw: fix memleak
Date: Tue, 18 Oct 2011 13:32:14 +0300
Message-ID: <20111018103214.3074.48453.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:38967 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1JRKcQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:16 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LRW module leaks child cipher memory when init_tfm() fails because of child
block size not being 16.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/lrw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 358f80b..fca3246 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -220,6 +220,7 @@ static int init_tfm(struct crypto_tfm *tfm)
 
 	if (crypto_cipher_blocksize(cipher) != 16) {
 		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
+		crypto_free_cipher(cipher);
 		return -EINVAL;
 	}
 
