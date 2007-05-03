From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 11:57:44 +0400
Message-ID: <20070503075744.GC17966@2ka.mipt.ru>
References: <000601c787e1$e169ff00$1a04010a@V505CP> <20070427081051.GA28960@gondor.apana.org.au> <000301c78d4b$0f9ab810$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Martin Schiller <mschiller@tdt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51239 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161495AbXECH6S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 03:58:18 -0400
Content-Disposition: inline
In-Reply-To: <000301c78d4b$0f9ab810$1a04010a@V505CP>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 03, 2007 at 08:19:52AM +0200, Martin Schiller (mschiller@tdt.de) wrote:
> Hi Evgeniy,

Hi Martin.

> Sorry for my late answer, but I didn't get your message because I haven't
> subscribed to the mailing-list.
> I've "found" it yesterday on the mailing-list archive. So please, could you
> reply directly to me and to the mailing-list on any further messages?

I did, but your mail server bounced message.
This message is also sent to you directly, hope it will pass through.
Btw, AMD list bounces too.

> I've tested the patch now, but nothing changed. When doing any aes cipher
> tests with the tcrypt test module, the machine freezes without any error.

Hmm, that means that main waiting loop of the driver is not an issue.
Since it is PCI, likely bus is locked by incorrect written value into
the space. Can you run with this patch (it will freeze too, but at
least with some useful info), since AMD keeps silence, we will go hard
way:

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6d3840e..6ddfab9 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -61,8 +61,10 @@ static inline void
 _writefield(u32 offset, void *value)
 {
 	int i;
+	printk("%s: start, offset: %x.\n", __func__, offset);
 	for(i = 0; i < 4; i++)
 		iowrite32(((u32 *) value)[i], _iobase + offset + (i * 4));
+	printk("%s: finish, offset: %x.\n", __func__, offset);
 }
 
 /* Read a 128 bit field (either a writable key or IV) */
@@ -70,8 +72,10 @@ static inline void
 _readfield(u32 offset, void *value)
 {
 	int i;
+	printk("%s: start, offset: %x.\n", __func__, offset);
 	for(i = 0; i < 4; i++)
 		((u32 *) value)[i] = ioread32(_iobase + offset + (i * 4));
+	printk("%s: finish, offset: %x.\n", __func__, offset);
 }
 
 static int
@@ -80,19 +84,24 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 	u32 status;
 	u32 counter = AES_OP_TIMEOUT;
 
+	printk("%s: src: %p, dst: %p, len: %d, flags: %x\n", __func__, src, dst, len, flags);
 	iowrite32(virt_to_phys(src), _iobase + AES_SOURCEA_REG);
 	iowrite32(virt_to_phys(dst), _iobase + AES_DSTA_REG);
 	iowrite32(len,  _iobase + AES_LENA_REG);
 
+	printk("%s: start op, likely will freeze.\n", __func__);
 	/* Start the operation */
 	iowrite32(AES_CTRL_START | flags, _iobase + AES_CTRLA_REG);
+	printk("%s: started, but we are stil alive.\n", __func__);
 
-	do
+	do {
 		status = ioread32(_iobase + AES_INTR_REG);
-	while(!(status & AES_INTRA_PENDING) && --counter);
+		printk("%s: status: %x, counter: %u.\n", __func__, status, counter);
+	} while(!(status & AES_INTRA_PENDING) && --counter);
 
 	/* Clear the event */
 	iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase + AES_INTR_REG);
+	printk("%s: completed.\n", __func__);
 	return counter ? 0 : 1;
 }
 
@@ -113,6 +122,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 
 	/* Start the critical section */
 
+	printk("%s: start.\n", __func__);
 	spin_lock_irqsave(&lock, iflags);
 
 	if (op->mode == AES_MODE_CBC) {
@@ -131,6 +141,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 		_readfield(AES_WRITEIV0_REG, op->iv);
 
 	spin_unlock_irqrestore(&lock, iflags);
+	printk("%s: completed.\n", __func__);
 
 	return op->len;
 }


-- 
	Evgeniy Polyakov
