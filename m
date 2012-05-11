From: Rodel Miguel <rodelfmiguel@gmail.com>
Subject: Writing Asynchronous Block Ciphers
Date: Sat, 12 May 2012 00:58:24 +0800
Message-ID: <CAPihpKCc3pmf3g0vEMxq3XOo9xccwG1ZT2gqM7vRacfFBdFAEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62438 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EKQ60 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 May 2012 12:58:26 -0400
Received: by pbbrp8 with SMTP id rp8so3535561pbb.19
        for <linux-crypto@vger.kernel.org>; Fri, 11 May 2012 09:58:26 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I would like to know if anyone has a tutorial/document link in writing
a CRYPTO_ALG_TYPE_ABLKCIPHER crypto device driver?  I am looking at
drivers/cipher/mv_cesa.c but there are lots of things going on which
are hardware context related.  I would like to know what the minimum
requirements for an asynchronous block cipher drivers are before I
hand over (DMA) the collected data to my encryption hardware.

Thanks in advance for your help!

Kind Regards,
Rodel
