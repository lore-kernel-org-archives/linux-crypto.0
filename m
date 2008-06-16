From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/4] crypto/talitos: rm duplicate timeout definition
Date: Mon, 16 Jun 2008 11:10:40 -0500
Message-ID: <20080616111040.b8bde43a.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:62581 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYFPQTq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jun 2008 12:19:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 989763d..27deb65 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -28,8 +28,6 @@
  *
  */
 
-#define TALITOS_TIMEOUT 100000
