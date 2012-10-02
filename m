From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] crypto: tegra: remove include of <mach/clk.h>
Date: Tue,  2 Oct 2012 16:17:40 -0600
Message-ID: <1349216260-917-1-git-send-email-swarren@wwwdotorg.org>
Cc: linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:48942 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2JBWRq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2012 18:17:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Stephen Warren <swarren@nvidia.com>

Nothing from this file is used, and the file will hopefully be deleted
soon.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Herbert, if this patch can get into 3.7 (it's late, I know) then that
would be great. If not, may I please request an ack so I can take the
change through the Tegra tree in 3.8, since I will probably have cleanup
patches that depend on this change. Thanks.
---
 drivers/crypto/tegra-aes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index ac236f6..88d860b 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -41,8 +41,6 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 
-#include <mach/clk.h>
-
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 #include <crypto/internal/rng.h>
-- 
1.7.0.4
