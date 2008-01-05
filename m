From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 1/2] [XFRM] remove ifdef crypto
Date: Sat, 5 Jan 2008 13:36:37 +0100
Message-ID: <E1JB8I6-0003Pk-OJ@Chamillionaire.breakpoint.cc>
References: <20080105123637.GA12561@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34841 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYAEMiT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2008 07:38:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

and select the crypto subsystem if neccessary

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 net/xfrm/Kconfig     |    1 +
 net/xfrm/xfrm_algo.c |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 577a4f8..74ab643 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -3,6 +3,7 @@
 #
 config XFRM
        bool
+       select CRYPTO
        depends on NET
 
 config XFRM_USER
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 1686f64..b5c5347 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -486,7 +486,6 @@ EXPORT_SYMBOL_GPL(xfrm_ealg_get_byidx);
  */
 void xfrm_probe_algs(void)
 {
-#ifdef CONFIG_CRYPTO
 	int i, status;
 
 	BUG_ON(in_softirq());
@@ -511,7 +510,6 @@ void xfrm_probe_algs(void)
 		if (calg_list[i].available != status)
 			calg_list[i].available = status;
 	}
-#endif
 }
 EXPORT_SYMBOL_GPL(xfrm_probe_algs);
 
-- 
1.5.3.7
