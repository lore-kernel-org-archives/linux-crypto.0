From: "Martin Schiller" <mschiller@tdt.de>
Subject: RE: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 08:19:52 +0200
Message-ID: <000301c78d4b$0f9ab810$1a04010a@V505CP>
References: <000601c787e1$e169ff00$1a04010a@V505CP> <20070427081051.GA28960@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.tdt.de ([195.243.126.82]:38575 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXECGTq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 02:19:46 -0400
Received: from ns (root@localhost)
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with SMTP id l436JhK17348
	for <linux-crypto@vger.kernel.org>; Thu, 3 May 2007 08:19:43 +0200
Received: from V505CP (mschiller3 [10.1.4.26])
	by ns.tdt.de (8.11.6/8.11.6/SuSE Linux 0.5) with ESMTP id l436JhQ17341
	for <linux-crypto@vger.kernel.org>; Thu, 3 May 2007 08:19:43 +0200
In-Reply-To: <20070427081051.GA28960@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday, April 27, 2007 02:53:30 -0700 , Evgeniy Polyakov wrote:

>> Could it be compiler problem and broken hardware?
>> Martin, can you test attached patch?
>
>Or better this one:
>
>diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
>index 6d3840e..724169b 100644
>--- a/drivers/crypto/geode-aes.c
>+++ b/drivers/crypto/geode-aes.c
>@@ -78,7 +78,7 @@ static int
> do_crypt(void *src, void *dst, int len, u32 flags)
> {
>        u32 status;
>-       u32 counter = AES_OP_TIMEOUT;
>+       int counter = 0x1000;
> 
>        iowrite32(virt_to_phys(src), _iobase + AES_SOURCEA_REG);
>        iowrite32(virt_to_phys(dst), _iobase + AES_DSTA_REG);
>@@ -89,7 +89,9 @@ do_crypt(void *src, void *dst, int len, u32 flags)
> 
>        do
>                status = ioread32(_iobase + AES_INTR_REG);
>-       while(!(status & AES_INTRA_PENDING) && --counter);
>+       while(--counter > 0 && !(status & AES_INTRA_PENDING));
>+
>+       WARN_ON(!counter);
> 
>        /* Clear the event */
>        iowrite32((status & 0xFF) | AES_INTRA_PENDING, _iobase +
AES_INTR_REG);
>

Hi Evgeniy,

Sorry for my late answer, but I didn't get your message because I haven't
subscribed to the mailing-list.
I've "found" it yesterday on the mailing-list archive. So please, could you
reply directly to me and to the mailing-list on any further messages?

I've tested the patch now, but nothing changed. When doing any aes cipher
tests with the tcrypt test module, the machine freezes without any error.

Regards, 
Martin
