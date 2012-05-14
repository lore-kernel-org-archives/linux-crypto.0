From: Rodel Miguel <rodelfmiguel@gmail.com>
Subject: CRYPTO_ALG_TYPE_ABLKCIPHER concepts guide
Date: Mon, 14 May 2012 12:46:52 +0800
Message-ID: <CAPihpKCBxW6kFF9ZZLB9Y7P-EqbTEo_bnbPoCOZB16dxUT1APA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63593 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2ENEqx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 May 2012 00:46:53 -0400
Received: by yhmm54 with SMTP id m54so3865842yhm.19
        for <linux-crypto@vger.kernel.org>; Sun, 13 May 2012 21:46:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Experts,

I am writing a driver for my AES encryption hardware.  It is a
hardware which can do encryption of 4k bytes of data every time.  I
have tried creating a driver based on geode-aes.c code which uses the
CRYPTO_ALG_TYPE_BLKCIPHER interface.  While testing the driver, I
found out that the limit for this type of API is 512 bytes of data
sent on every encryption/decryption call.  I have sent the dm-crypt
mailing list a query about this and they said that this limit cannot
be changed at the moment.

I am now looking at a different type of crypto API which is the
CRYPTO_ALG_TYPE_ABLKCIPHER but I could not find any
tutorials/documentation which would guide to the minimum code required
to create this type of driver.  I looked at the mv_cesa.c but I am
still quite lost at the procedures in doing this type of driver.  The
reason I want to explore this driver is that I am assuming that the
CRYPTO_ALG_TYPE_ABLKCIPHER type of interface would allow me to collect
4k bytes of data first before doing DMA to my hardware for
encryption/decryption.  Is this a correct assumption?

Is there a good documentation that would lay out the requirements to
write an asynchronous type of block cipher?

Thank you very much for your help!

Kind Regards,
Rodel
