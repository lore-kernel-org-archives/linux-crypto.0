From: Alexandru Ardelean <ardeleanalex@gmail.com>
Subject: [PATCH] crypto: talitos: fix driver init
Date: Thu, 28 Apr 2016 17:15:30 +0300
Message-ID: <1461852930-714-1-git-send-email-aardelean@riverbed.com>
Cc: Alexandru Ardelean <ardeleanalex@gmail.com>,
	Alexandru Ardelean <aardelean@riverbed.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33602 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbcD1OPg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Apr 2016 10:15:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id r12so23951439wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 28 Apr 2016 07:15:35 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Alexandru Ardelean <ardeleanalex@gmail.com>

Crypto hash algorithms must provide the statesize sometime
from kernel 4.2 onwards.
Since commit 8996eafdcbad149ac0f772fb1649fbb75c482a6a

Signed-off-by: Alexandru Ardelean <aardelean@riverbed.com>
---
 drivers/crypto/talitos.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index aae0554..080e329 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2458,6 +2458,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-talitos",
@@ -2473,6 +2474,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-talitos",
@@ -2488,6 +2490,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-talitos",
@@ -2503,6 +2506,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-talitos",
@@ -2518,6 +2522,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "sha384",
 				.cra_driver_name = "sha384-talitos",
@@ -2533,6 +2538,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "sha512",
 				.cra_driver_name = "sha512-talitos",
@@ -2548,6 +2554,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "hmac-md5-talitos",
@@ -2563,6 +2570,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-talitos",
@@ -2578,6 +2586,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "hmac-sha224-talitos",
@@ -2593,6 +2602,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-talitos",
@@ -2608,6 +2618,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "hmac-sha384-talitos",
@@ -2623,6 +2634,7 @@ static struct talitos_alg_template driver_algs[] = {
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
 			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.statesize  = sizeof(struct talitos_ahash_req_ctx),
 			.halg.base = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "hmac-sha512-talitos",
-- 
2.8.1
