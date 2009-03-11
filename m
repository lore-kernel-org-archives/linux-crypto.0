From: Melchior FRANZ <melchior.franz@gmail.com>
Subject: [2.6.28.5] dm/crypt oops: "unable to handle kernel NULL pointer dereference" (tainted)
Date: Wed, 11 Mar 2009 13:19:43 +0100
Message-ID: <200903111319.43778@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:32366 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755511AbZCKMTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2009 08:19:53 -0400
Received: from smarthub94.highway.telekom.at (HELO email.aon.at) ([172.18.5.236])
          (envelope-sender <melchior.franz@gmail.com>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 11 Mar 2009 12:19:50 -0000
Received: from 91-115-179-21.adsl.highway.telekom.at (HELO server.lan) ([91.115.179.21])
          (envelope-sender <melchior.franz@gmail.com>)
          by smarthub94.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 11 Mar 2009 12:19:41 -0000
Received: from localhost (localhost [IPv6:::1])
	by server.lan (Postfix) with ESMTP id E5641160C4856
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2009 13:19:44 +0100 (CET)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

a few days ago I got an oops in the crypt module. This is with an
nvidia-tainted kernel, so I didn't file a bugzilla report, but
Geert and Milan suggested that I post it here if the oops isn't
related to the nvidia driver. Of course, I can't be sure, but
I've been using both nvidia-drivers and dm/crypt since years
and never got this problem, and there's no indication in the bt
that nvidia is any way involved.

I couldn't reproduce the problem with or without the nvidia
driver (173.14.17 for an FX5500), nor can I say which of my
input exactly caused it (done by a script), but it was when
"destroying" a loop-mounted ~4GB file, ext3 formatted and aes
encrypted, so one of these:

  umount ...
  cryptsetup remove ...
  losetup -d ...

This has worked for years, so it's probably not some recent
user error. The next time I mounted/unmounted the file it
worked flawlessly, as it used to. System:

  Intel P4, 2.4G
  Linux 2.6.28.5  (vanilla)
  gcc 4.3.1  (openSuSE 11.0)
  libc 2.8

All modules compiled in, except for the nvidia module and
scsi_wait_scan (for historic reasons).

One thing might be of interest: I had the (desktop-)system
hibernated a few times in a row (2 or 3 times?). Or maybe
it was just bitflipping due to cosmic rays?  :-)



BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c0158a75>] mempool_free+0xd/0x9a
*pde =3D 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/block/dm-1/range
Modules linked in: nvidia(P) scsi_wait_scan

Pid: 19181, comm: loop1 Tainted: P           (2.6.28.5 #4) MS-6788
EIP: 0060:[<c0158a75>] EFLAGS: 00010286 CPU: 0
EIP is at mempool_free+0xd/0x9a
EAX: d36af0d4 EBX: 00000000 ECX: 00000001 EDX: 00000000
ESI: d36af0d4 EDI: 00000000 EBP: 00000000 ESP: f621bf58
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process loop1 (pid: 19181, ti=3Df621a000 task=3Dd98537b0 task.ti=3Df621=
a000)
Stack:
 c03b3a94 c03b3bb6 00000000 c0198dfb f71a13f0 c032ca0a 00336000 0000000=
0
 00000000 f723dd08 f723dc00 c72c1780 00001000 00000001 00000001 0000000=
0
 c032c570 00000000 00000000 00000000 f621bfb4 08005000 00000000 f723dc0=
0
Call Trace:
 [<c03b3a94>] crypt_dec_pending+0x28/0x4e
 [<c03b3bb6>] crypt_endio+0x0/0xde
 [<c0198dfb>] bio_endio+0x19/0x30
 [<c032ca0a>] loop_thread+0x2f6/0x42d
 [<c032c570>] do_lo_send_aops+0x0/0x1a4
 [<c032c714>] loop_thread+0x0/0x42d
 [<c0131c38>] kthread+0x37/0x5f
 [<c0131c01>] kthread+0x0/0x5f
 [<c0103d93>] kernel_thread_helper+0x7/0x14
Code: 08 08 74 05 e8 79 45 37 00 8b 04 24 8b 50 0c 89 f0 8b 0c 24 ff 51=
 14
      31 c0 e9 90 fe ff ff 56 53 83 ec 04 89 c6 89 d3 85 c0 74 54 <8b> =
42
      04 3b 02 7d 6b 9c 59 fa 89 e0 25 00 e0 ff ff 83 40 14 01=C3=97
EIP: [<c0158a75>] mempool_free+0xd/0x9a SS:ESP 0068:f621bf58
---[ end trace 916d6e0bbba638c2 ]---

m.
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
