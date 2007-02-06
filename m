From: "Tsai, Hong-Bin" <hbtsai@gmail.com>
Subject: how can I protect my kernel image from being disclosed?
Date: Tue, 6 Feb 2007 17:09:49 +0800
Message-ID: <3befbf920702060109p4fefe8d4g949a401330b1034b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:44624 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXBFJJv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Feb 2007 04:09:51 -0500
Received: by an-out-0708.google.com with SMTP id b33so1230396ana
        for <linux-crypto@vger.kernel.org>; Tue, 06 Feb 2007 01:09:50 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dear Gurus:

I've surveyed for secure boot for days and most of them are either
grub-md5-crypt or u-boot and TPM support.
There is a thread about using grub to decrypt kernel image, but the
discussion didn't go to anywhere.

--> http://www.mail-archive.com/bug-grub@gnu.org/msg01976.html

So, I'd like to know if there is any bootloader capable of decrypting
an encrypted kernel image via a secret key supplied, without the
constraint of TPM?

Thanks in advance.

-- 
Best regards,
Hong-Bin
blog: http://furseal.wordpress.com
msn: benjamin@benjamin.idv.tw
