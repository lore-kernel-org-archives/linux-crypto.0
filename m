From: Jean-Christophe Dubois <jcd@tribudubois.net>
Subject: [PATCH] remove unnecessary variable in xfrm_output_resume()
Date: Tue, 12 Aug 2008 08:12:24 +0200
Message-ID: <200808120812.26363.jcd@tribudubois.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:59280 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYHLGOE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Aug 2008 02:14:04 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix1-g20.free.fr (Postfix) with ESMTP id C00CB293CA3B
	for <linux-crypto@vger.kernel.org>; Tue, 12 Aug 2008 08:14:01 +0200 (CEST)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 9A4A2B0177
	for <linux-crypto@vger.kernel.org>; Tue, 12 Aug 2008 08:12:30 +0200 (CEST)
Received: from lancelot.dubois.etowns.net (lns-bzn-51f-81-56-146-209.adsl.proxad.net [81.56.146.209])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 7AC31B015E
	for <linux-crypto@vger.kernel.org>; Tue, 12 Aug 2008 08:12:30 +0200 (CEST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Small fix removing an unnecessary intermediate variable.

Signed-off-by: Jean-Christophe DUBOIS  <jcd@tribudubois.net>
---

diff -Naur linux-2.6.26.2.org/net/xfrm/xfrm_output.c linux-2.6.26.2/net/xfrm/xfrm_output.c
--- linux-2.6.26.2.org/net/xfrm/xfrm_output.c   2008-08-12 00:37:29.000000000 +0200
+++ linux-2.6.26.2/net/xfrm/xfrm_output.c       2008-08-12 00:40:40.000000000 +0200
@@ -112,16 +112,13 @@
 int xfrm_output_resume(struct sk_buff *skb, int err)
 {
        while (likely((err = xfrm_output_one(skb, err)) == 0)) {
-               struct xfrm_state *x;
