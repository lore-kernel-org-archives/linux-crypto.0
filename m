From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] crypto: doc- Fix double words "the the" in crypto-API.tmpl
Date: Thu,  7 Jul 2016 21:58:16 +0900
Message-ID: <20160707125816.4411-1-standby24x7@gmail.com>
Cc: Masanari Iida <standby24x7@gmail.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34451 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbcGGM6W (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2016 08:58:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix double words "the the" in crypto-API.tmpl.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/crypto-API.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index d55dc5a39bad..fb2a1526f6ec 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -440,8 +440,8 @@
      The type flag specifies the type of the cipher algorithm.
      The caller usually provides a 0 when the caller wants the
      default handling. Otherwise, the caller may provide the
-     following selections which match the the aforementioned
-     cipher types:
+     following selections which match the aforementioned cipher
+     types:
     </para>
 
     <itemizedlist>
-- 
2.9.0.243.g5c589a7
