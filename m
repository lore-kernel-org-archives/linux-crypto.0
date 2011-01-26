From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] crypto: mark ghash as fips_allowed
Date: Wed, 26 Jan 2011 12:00:54 -0500
Message-ID: <20110126170054.GB18067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1AZRBA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 12:01:00 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A self-test failure in fips mode means a panic. Well, gcm(aes)
self-tests currently fail in fips mode, as gcm is dependent on ghash,
which semi-recently got self-test vectors added, but wasn't marked as a
fips_allowed algorithm. Because of gcm's dependence on what is now seen
as a non-fips_allowed algorithm, its self-tests refuse to run.
Previously, ghash got a pass in fips mode, due to the lack of any test
vectors at all, and thus gcm self-tests were able to run. After this
patch, a 'modprobe tcrypt mode=35' no longer panics in fips mode, and
successful self-test of gcm(aes) is reported.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/testmgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 521fdb2..2854865 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2077,6 +2077,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ghash",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = ghash_tv_template,
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com
