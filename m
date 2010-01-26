From: Bai Shuwei <baishuwei@gmail.com>
Subject: how the key is generated?
Date: Tue, 26 Jan 2010 16:41:38 +0800
Message-ID: <f3566d61001260041s13286706ra5c032ea2b4ce1d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47565 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0AZIlj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 03:41:39 -0500
Received: by pwi21 with SMTP id 21so2848979pwi.21
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2010 00:41:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, everyone:
    i add one line in the setkey function which is in xts.c file to
print the in_key value. I find the key value not same i set in the
keyfile by cryptsetup

   my command is
#   cryptsetup luksFormat -d my_keyfile -c xts-aes-plain -s 256 /dev/loop0

# cat my_keyfile
1234567890abcdef1234567890abcdef


I want to know how i set my key to encrypt/decrypt the disc for
xts-aes and aes alogrithm? And how the crypto get the real key to
encrypt the disc or how the key printed in the setkey is genereted and
when? Thanks very much!

Best Regards

Bai Shuwei

-- 
Love other people, as same as love yourself!
Don't think all the time, do it by your hands!

E-Mail: baishuwei@gmail.com
