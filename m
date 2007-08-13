From: joe@perches.com
Subject: [PATCH] [139/2many] MAINTAINERS - CRYPTO API
Date: Sun, 12 Aug 2007 23:25:46 -0700
Message-ID: <46bff96a.HHCwZ6i46IaoRLWU%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4219 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966126AbXHMG0s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 794fe99..bc2e348 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1352,6 +1352,7 @@ M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
+F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
