From: Bai Shuwei <baishuwei@gmail.com>
Subject: device-mapper: remove ioctl failed: device or resource busy
Date: Sat, 6 Feb 2010 11:32:35 +0800
Message-ID: <f3566d61002051932n4f2a30cx4e4f0e962af25a37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:45223 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0BFDjN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Feb 2010 22:39:13 -0500
Received: by pzk17 with SMTP id 17so391093pzk.4
        for <linux-crypto@vger.kernel.org>; Fri, 05 Feb 2010 19:39:13 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, All:
   I port the xts-aes algorithm to FPGA board and use it to
encrypt/decrypt the disc.  i will get the bellow information

   But when excute the bellow commands
   cryptsetup luksFormat -c aes-xts-plain -s 256 /dev/loop0
  or
   cryptsetup luksOpen /dev/loop0 test0

   I get the bellow information
   ....
   device-mapper: remove ioctl failed: device or resource busy
   ....

   But others are all fine! I can format and mount test0. So i want to
know why the message is printed? Thanks!

Best REgards


Bai Shuwei

-- 
Love other people, as same as love yourself!
Don't think all the time, do it by your hands!

E-Mail: baishuwei@gmail.com
