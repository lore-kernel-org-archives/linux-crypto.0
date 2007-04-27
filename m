From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Fri, 27 Apr 2007 13:50:37 +0400
Message-ID: <20070427095033.GB29804@2ka.mipt.ru>
References: <000601c787e1$e169ff00$1a04010a@V505CP> <20070427081051.GA28960@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Martin Schiller <mschiller@tdt.de>, info-linux@geode.amd.com,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59140 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526AbXD0Jvc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Apr 2007 05:51:32 -0400
Content-Disposition: inline
In-Reply-To: <20070427081051.GA28960@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 27, 2007 at 06:10:51PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Has anyone else tried to test the geode-aes driver with the tcrypt module?
> > 
> > I am also not able to use the geode-aes driver with openswan-2.4.7 on kernel
> > 2.6.19 (with patched-in geode driver).
> 
> Jordan, do you have any ideas why this is happening?

Could it be compiler problem and broken hardware?
Martin, can you test attached patch?

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6d3840e..724169b 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -78,7 +78,7 @@ static int
 do_crypt(void *src, void *dst, int len, u32 flags)
 {
 	u32 status;
-	u32 counter = AES_OP_TIMEOUT;
+	int counter = AES_OP_TIMEOUT;
 
 	iowrite32(virt_to_phys(src), _iobase + AES_SOURCEA_REG);
 	iowrite32(virt_to_phys(dst), _iobase + AES_DSTA_REG);
@@ -89,7 +89,9 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 
 	do
 		status = ioread32(_iobase + AES_INTR_REG);
-	while(!(status & AES_INTRA_PENDING) && --counter);
+	while(--counter > 0 && !(status & AES_INTRA_PENDING));
+
+	WARN_ON(!counter);
 
 	/* Clear the event */
 	iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase + AES_INTR_REG);
-- 
	Evgeniy Polyakov
