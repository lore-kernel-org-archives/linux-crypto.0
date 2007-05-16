From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.
Date: Wed, 16 May 2007 16:52:31 +0900 (JST)
Message-ID: <20070516.165231.783376564.takamiya@po.ntts.co.jp>
References: <20061018.161510.796986352.takamiya@po.ntts.co.jp>
	<20061018.161749.782295638.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_May_16_16_52_31_2007_518)--"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	takamiya@po.ntts.co.jp, camellia-oss@sec.ms.ntts.co.jp
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:57010 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbXEPILy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 May 2007 04:11:54 -0400
In-Reply-To: <20061018.161749.782295638.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

----Next_Part(Wed_May_16_16_52_31_2007_518)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, Herbert,

  First of all, thank you for pushing Camellia codes to the mainline.

  I checked the linux-2.6.21.y.git and linux-2.6.git tree.

  The patch I sent had the compat name for "camellia", but applied
  code doesn't have it.

  This causes that the user must use "cbc(camellia)" to use Camellia
  algorithm for ESP(e.g, ip command).

  This patch is comprehensive for user to use jst "camellia" keyword
  while using Camellia algorithm.

  I think this is the small bug, so could you push this patch both
  linux-2.6.21.y.git and linux-2.6.git tree?

  Regareds,

---
Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

----Next_Part(Wed_May_16_16_52_31_2007_518)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-XFRM-Camellia-fixed-to-add-compat-name-for-Camellia.txt"

>From 80299fc884ce6e1403ba4e0656a82f4fcb6986d0 Mon Sep 17 00:00:00 2001
From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Date: Wed, 16 May 2007 16:45:01 +0900
Subject: [PATCH] [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.
  fixed to add compat name for Camellia.
  The user can use the "camellia" keyword instead of "cbc(camellia)"
  while setting IPsec SA.

  Signed-off-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
---
 net/xfrm/xfrm_algo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 6249a94..5d28ca9 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -267,6 +267,7 @@ static struct xfrm_algo_desc ealg_list[]
 },
 {
 	.name = "cbc(camellia)",
+	.compat = "camellia",
 
 	.uinfo = {
 		.encr = {
-- 
1.4.4


----Next_Part(Wed_May_16_16_52_31_2007_518)----
