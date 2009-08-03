From: Peter Lieven <pl@dlh.net>
Subject: kcryptd performance issues, write faster than read on raid0/lvm?!
Date: Mon, 03 Aug 2009 21:41:07 +0200
Message-ID: <4A773D53.5040907@dlh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zion.dlh.net ([91.198.192.1]:42483 "EHLO mail.dlh.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752637AbZHCUIB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2009 16:08:01 -0400
Received: from office1.dus1.de.inetbone.net ([213.203.192.254] helo=[192.168.253.26])
	by mail.dlh.net with asmtp (Exim 3.36 #24 (Debian))
	id 1MY3PB-0001yi-00
	for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2009 21:41:09 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Community,

I use an Atom 330 (Dual-Core) ION based system as work station at home.
The rootfs is crypted with cryptsetup/luks.

As the Atom 330 is rather weak in cryptographic speed and I realized th=
at a single
blockdevice is always handled by only one kcryptd thread, I tried out a=
 tweak
to spread the work to 2 CPU cores.

I have a volume group on the built-in SSD of the Nettop and I created t=
wo
equally-sized volumes. Each of the volumes is encrypted using cryptsetu=
p.
When both volumes are succesfully unlocked they form a raid-0 device.
Since I work on an SSD this should not create a performance problem
due to high amount of seeks.

And here is what is totally strange:
When I read from this raid, I get a throughput of about 24MB/s (what is
about the amount an Atom Core @1.6GHz (aes_x86) can decrypt per second.=
 Looking
at the 2 kcryptd processes I find that each is using nearly 50% cpu
time. As if they where running only on a single core and/or waiting
for each other?!

lieven@dozer64-ssd:~$ sh speedtest-read.sh
Sa 1. Aug 21:52:19 CEST 2009
1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 43,661 s, 24,6 MB/s
Sa 1. Aug 21:53:03 CEST 2009

# 1024MB / 44 sec =3D 23,2 MB/sec

lieven@dozer64-ssd:~$ cat speedtest-read.sh
#!/bin/sh
sync
date
dd if=3D/home/lieven/speedtest.dat of=3D/dev/null bs=3D1M
sync
date

hdparm outputs about the same performance:
lieven@dozer64-ssd:~$ sudo hdparm -tT /dev/md0

/dev/md0:
 Timing cached reads:   1244 MB in  2.00 seconds =3D 621.48 MB/sec
 Timing buffered disk reads:   70 MB in  3.04 seconds =3D  23.01 MB/sec

But, when I write to /dev/md0 I get a significantly better performance:

lieven@dozer64-ssd:~$ sh speedtest-write.sh
Sa 1. Aug 22:19:04 CEST 2009
1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 27,2655 s, 39,4 MB/s
Sa 1. Aug 22:19:36 CEST 2009

# 1024 MB / 32 sec =3D 32 MB / sec

lieven@dozer64-ssd:~$ cat speedtest-write.sh
#!/bin/sh
sync
date
dd if=3D/dev/zero of=3D/home/lieven/speedtest.dat bs=3D1M count=3D1024
sync
date

If I look at the both kcryptd processes I see that both are using
roughly 100% of one CPU core each when i write to /dev/md0.

Before I made this setup, I tried it on an unencrypted volume
with 2 files mounted via loop, crypted and then added to raid.
In this case, the read performance is as expected (about 45MB/s).

I tried with ubuntu jaunty kernel 2.6.28-13 and I also tried
2.6.30.4 as I read about the kcrypt workqueue patch that was
added recently.

Does anyone have an explaination for this?

Thanks,
Peter




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkp3PVMACgkQO/ibohXUOnKYXQCcDrZ0qmnfsn+IkBoAmnEZXkVN
rWAAoL0NYiPYeawhMMP2zvbslftyhNeZ
=3DIfDQ
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
