From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH v3 2/5] crypto: marvell: fix stack smashing in marvell/hash.c
Date: Fri, 09 Oct 2015 20:43:38 +0100
Message-ID: <E1ZkdZq-0005IZ-M2@rmk-PC.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:51400 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbJITns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:43:48 -0400
In-Reply-To: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Several of the algorithms in marvell/hash.c have a statesize of zero.
When an AF_ALG accept() on an already-accepted file descriptor to
calls into hash_accept(), this causes:

	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];

to be zero-sized, but we still pass this to:

	err = crypto_ahash_export(req, state);

which proceeds to write to 'state' as if it was a "struct md5_state",
"struct sha1_state" etc.  Add the necessary initialisers for the
.statesize member.

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index e8d0d7128137..a259aced3b42 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -870,6 +870,7 @@ struct ahash_alg mv_md5_alg = {
 	.import = mv_cesa_md5_import,
 	.halg = {
 		.digestsize = MD5_DIGEST_SIZE,
+		.statesize = sizeof(struct md5_state),
 		.base = {
 			.cra_name = "md5",
 			.cra_driver_name = "mv-md5",
@@ -959,6 +960,7 @@ struct ahash_alg mv_sha1_alg = {
 	.import = mv_cesa_sha1_import,
 	.halg = {
 		.digestsize = SHA1_DIGEST_SIZE,
+		.statesize = sizeof(struct sha1_state),
 		.base = {
 			.cra_name = "sha1",
 			.cra_driver_name = "mv-sha1",
@@ -1048,6 +1050,7 @@ struct ahash_alg mv_sha256_alg = {
 	.import = mv_cesa_sha256_import,
 	.halg = {
 		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct sha256_state),
 		.base = {
 			.cra_name = "sha256",
 			.cra_driver_name = "mv-sha256",
-- 
2.1.0
