From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] crypto: mark xts(aes) as fips_allowed
Date: Tue, 25 Jan 2011 16:32:48 -0500
Message-ID: <20110125213248.GD3427@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1AYVdP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Jan 2011 16:33:15 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We (Red Hat) are intending to include dm-crypt functionality, using
xts(aes) for disk encryption, as part of an upcoming FIPS-140-2
certification effort, and xts(aes) *is* on the list of possible
mode/cipher combinations that can be certified. To make that possible, we
need to mark xts(aes) as fips_allowed in the crypto subsystem.

A 'modprobe tcrypt mode=10' in fips mode shows xts(aes) self-tests
passing successfully after this change.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 27ea9fe..521fdb2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2453,6 +2453,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "xts(aes)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {

-- 
Jarod Wilson
jarod@redhat.com
