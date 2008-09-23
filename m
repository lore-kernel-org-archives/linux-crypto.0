From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Tue, 23 Sep 2008 22:18:42 +0400
Message-ID: <20080923181840.GA24982@2ka.mipt.ru>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Dimitri Puzin <max@psycast.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:46251 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbYIWSTg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 14:19:36 -0400
Content-Disposition: inline
In-Reply-To: <48D93028.20903@psycast.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 23, 2008 at 08:06:32PM +0200, Dimitri Puzin (max@psycast.de) wrote:
> With this patch applied it still doesn't work as expected. The overflow
> messages are gone however syslog shows
> [  120.924266] hifn0: abort: c: 0, s: 1, d: 0, r: 0.
> when doing cryptsetup luksFormat as in original e-mail. At this point
> cryptsetup hangs and can't be killed with -SIGKILL. I've attached
> SysRq-t dump of this condition.

Yes, I was wrong with the patch: HIFN does not support 64-bit addresses
afaics.

Attached patch should not allow HIFN to be registered on 64-bit arch, so
crypto layer will fallback to the software algorithms.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81f3f95..31c75d4 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2787,6 +2787,11 @@ static int __devinit hifn_init(void)
 	unsigned int freq;
 	int err;
 
+	if (sizeof(dma_addr_t) > 4) {
+		printk(KERN_INFO "HIFN supports only 32-bit addresses.\n");
+		return -EINVAL;
+	}
+
 	if (strncmp(hifn_pll_ref, "ext", 3) &&
 	    strncmp(hifn_pll_ref, "pci", 3)) {
 		printk(KERN_ERR "hifn795x: invalid hifn_pll_ref clock, "


-- 
	Evgeniy Polyakov
