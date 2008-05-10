From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [HIFN 1/1] Remove duplicated include
Date: Sat, 10 May 2008 11:50:58 +0400
Message-ID: <20080510075057.GB5145@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49012 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYEJHvQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 May 2008 03:51:16 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Removed duplicated include file <linux/interrupt.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- a/drivers/crypto/hifn_795x.c        2008-05-08 22:03:12.000000000 +0800
+++ b/drivers/crypto/hifn_795x.c        2008-05-08 22:03:56.000000000 +0800
@@ -29,7 +29,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
-#include <linux/interrupt.h>
 #include <linux/crypto.h>
 #include <linux/hw_random.h>
 #include <linux/ktime.h>


-- 
	Evgeniy Polyakov
