From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Thu,  5 Nov 2015 08:48:57 +0100
Message-ID: <1446709737-11316-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	stable@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
A recent change make impossible to load them without giving statesize.
This patch specifiy statesize for sha1 and md5.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index eab6fe2..107cd2a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -39,6 +39,7 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.import = sun4i_hash_import_md5,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct md5_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-sun4i-ss",
@@ -66,6 +67,7 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.import = sun4i_hash_import_sha1,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
+			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-sun4i-ss",
-- 
2.4.10
