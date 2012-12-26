From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Workaround for tcrypt bug?
Date: Wed, 26 Dec 2012 02:34:46 +0100
Message-ID: <CAELiMBOPsPOWNe6+LahiBqGteucai0xrqY+eQ0nxkghjAEsy-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49588 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2LZBll (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Dec 2012 20:41:41 -0500
Received: by mail-qc0-f173.google.com with SMTP id b12so4162483qca.4
        for <linux-crypto@vger.kernel.org>; Tue, 25 Dec 2012 17:41:41 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

On my Fedora 17 64bit AMD desktop computer I get this error

[root@amd ~]# uname -a
Linux amd 3.6.10-2.fc17.x86_64 #1 SMP Tue Dec 11 18:07:34 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux
[root@amd ~]# modprobe tcrypt sec=1 type=1000
ERROR: could not insert 'tcrypt': No such file or directory
[root@amd ~]# tail -f /var/log/messages
Dec 26 02:32:04 amd kernel: [ 1908.753473] alg: hash: Failed to load
transform for hmac(crc32): -2
Dec 26 02:32:04 amd kernel: [ 1908.765333] alg: hash: Failed to load
transform for hmac(crc32): -2
Dec 26 02:32:04 amd kernel: [ 1908.772012] tcrypt: one or more tests failed!

Does anyone know of a way to workaround this?

Hugs,
Sandra
