From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: =?utf-8?B?5Zue5aSN77yaUmU=?=
	=?utf-8?Q?=3A?= vgdisplay problem with hifn795x
Date: Sun, 30 Nov 2008 13:12:08 +0300
Message-ID: <20081130101208.GA20720@ioremap.net>
References: <20081130082600.C00C836FC34@mail3-113.sinamail.sina.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: tanglb@sina.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:57774 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYK3KML (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Nov 2008 05:12:11 -0500
Content-Disposition: inline
In-Reply-To: <20081130082600.C00C836FC34@mail3-113.sinamail.sina.com.cn>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 30, 2008 at 04:26:00PM +0800, tanglb@sina.com (tanglb@sina.com) wrote:
> I downloaded the source file from your link and compiled successfully.
> But it still hang when I tried to run "mkfs.xfs".

Please enable debug mode with attached patch and send dmesg output.
Thank you.

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 6e9b39c..ca621f6 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -38,7 +38,7 @@
 
 #include <asm/kmap_types.h>
 
-//#define HIFN_DEBUG
+#define HIFN_DEBUG
 
 #ifdef HIFN_DEBUG
 #define dprintk(f, a...) 	printk(f, ##a)

-- 
	Evgeniy Polyakov
