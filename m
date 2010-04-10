From: Bai Shuwei <baishuwei@gmail.com>
Subject: where does tw routine point to in xts.c?
Date: Sat, 10 Apr 2010 11:20:45 +0800
Message-ID: <j2sf3566d61004092020p21210b27u46b401073a8672e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:41668 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab0DJDUq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Apr 2010 23:20:46 -0400
Received: by iwn35 with SMTP id 35so52126iwn.21
        for <linux-crypto@vger.kernel.org>; Fri, 09 Apr 2010 20:20:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, All:
  When i use the cryptsetup command to set the aes-xts-plain
encryption, the system will entry the crypt() routine which defined in
the xts.c file. I find the routine will call two important routines:
tw and fn. I think the fn will point to the aes_encrypt/decrypt
routine. But i want to know which routine the tw will point to for
aes-xts-plain encryption? and where i can find its source code? I put
the segment where the tw routine will be called in the bellow.

       wsrc = w->src.virt.addr;
       wdst = w->dst.virt.addr;

       /* calculate first value of T */
       tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);

       goto first;

       for (;;) {
               do {


Thanks all!

Best Regards

-- 
Love other people, as same as love yourself!
Don't think all the time, do it by your hands!

E-Mail: baishuwei@gmail.com
