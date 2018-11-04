Return-Path: <SRS0=8KRZ=NP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:58086 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbeKDTUi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 14:20:38 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
Date: Sun,  4 Nov 2018 10:05:24 +0000
Message-Id: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
allowed as a FIPS mode algorithm. Mark it as such.

[1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b1f79c6..1a371d01 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2805,6 +2805,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cts(cbc(aes))",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = __VECS(cts_mode_tv_template)
 		}
-- 
2.7.4
