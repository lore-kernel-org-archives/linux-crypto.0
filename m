From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] crypto: testmgr - remove fips_allowed flag from
 camellia-aesni null-tests
Date: Tue, 13 Nov 2012 11:47:32 +0200
Message-ID: <20121113094732.25071.31295.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:43133 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2KMJre (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 04:47:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove incorrect fips_allowed from camellia null-test entries. Caused by
incorrect copy-paste of aes-aesni null-tests into camellia-aesni null-tests.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3933241..b8695bf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2175,7 +2175,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cryptd(__driver-cbc-camellia-aesni)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -2207,7 +2206,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cryptd(__driver-ecb-camellia-aesni)",
 		.test = alg_test_null,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
