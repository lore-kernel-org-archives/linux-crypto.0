From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] crypto: allow compression algs in fips mode
Date: Mon, 19 Nov 2012 20:45:40 +0100
Message-ID: <1353354340-4188-1-git-send-email-mbroz@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab2KSTpv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 14:45:51 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qAJJjpfj028804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2012 14:45:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When in fips mode, compression algoritms fails to initialize,
e.g. modprobe ubifs returns
  UBIFS error: compr_init: cannot initialize compressor lzo, error -2

FIPS mode should not care about compression algoritms at all.

Patch just set fips_enabled flag to 1 to all compression algorithms
managed by testmgr.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 crypto/testmgr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 941d75c..02bc58f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2383,6 +2383,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "deflate",
 		.test = alg_test_comp,
+		.fips_allowed = 1,
 		.suite = {
 			.comp = {
 				.comp = {
@@ -2859,6 +2860,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "lzo",
 		.test = alg_test_comp,
+		.fips_allowed = 1,
 		.suite = {
 			.comp = {
 				.comp = {
@@ -3226,6 +3228,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "zlib",
 		.test = alg_test_pcomp,
+		.fips_allowed = 1,
 		.suite = {
 			.pcomp = {
 				.comp = {
-- 
1.7.10.4
