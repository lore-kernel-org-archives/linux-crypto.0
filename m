From: Andreas Gerlich <linux-crypto@online.de>
Subject: hifn_795x and geode-aes module
Date: Sat, 01 Nov 2008 18:22:35 +0100
Message-ID: <490C905B.10807@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYKARWj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Nov 2008 13:22:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

hardware:  net5510-70 (Soekris board) 500 Mhz
	   vpn1401 (Soekris) PCI-card with HIFN 7955

software:  Debian Linux Lenny/sid, standart installation
	   kernel 2.6.27.4 from kernel.org and
	   the kernel 2.6.26 which belongs to Debian Lenny/sid

Console:   serial line (no vga present on that board)

-----------------------------------------------------------
Crypto-Options: aes-cbc-essiv:sha256, keysize=3D128

After I have created the the device and have made a mkfs:

command: time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D700000

	without goede-aes (128 Bit keylength)	1m40.313s, 1m44.596s
	(hifn_795x module also unloaded)

	with geode-aes (128 Bit keylength)	36.792s,   37.774s
	(hifn_795x module unloaded)

command: time cat 700MB-file >/dev/null

	without geode-aes (128 Bit keylength)	1m35.057s, 1m36.257s
	(hifn_795x module also unloaded)

	with geode-aes (128 Bit keylength):	32.546s,   32.656s
	(hifn_795x module unloaded)

It seems the geode-aes module works very well (keysize 128 bit)!!!


Crypto-Options: aes-cbc-essiv:sha256, keysize=3D256 <<<

command: time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D700000

	with geode-aes & hifn_795x		2m11.968s, 2m16.296s

	without geode-aes & hifn_795x		2m9.441s,  2m9.779s

geode-aes are not used because it works only with keysize 128 Bit.
But it seems the hifn_795x module are also not used.

Look with lsmod for the usage (when the crypted partition is mounted an=
d
geode-aes
and hifn_795x module is loaded):
-----------------------------------------------------------------------=
------------
piepmatz:/var/log# lsmod
Module                  Size  Used by
sha256_generic         11392  0
aes_i586                7680  2
aes_generic            27816  1 aes_i586
cbc                     3456  1
ipv6                  221668  18
dm_crypt               11140  1
dm_snapshot            15136  0
dm_mirror              15104  0
dm_log                  8192  1 dm_mirror
dm_mod                 46252  6 dm_crypt,dm_snapshot,dm_mirror,dm_log

=2E..

hifn_795x              17156  0  <------------------ !!!
rng_core                3844  2 geode_rng,hifn_795x
des_generic            16384  1 hifn_795x
cs5535_gpio             3656  0
geode_aes               5508  3  <------------------ !!!
soundcore               5956  1 snd
crypto_blkcipher       15108  5 cbc,dm_crypt,hifn_795x,geode_aes

=2E..

piepmatz:/var/log# _
-----------------------------------------------------------------------=
--------------

geode-aes is used by 3
hifn_795x is used by 0 !!!

When I umount and close with "cryptsetup luksClose ..." the device
I unload geode-aes and load only the hifn_795x module:
then I try to mount:
-----------------------------------------------------------------------=
--------------
piepmatz:~# miscmount
cryptsetup luksOpen /dev/hdb4 sehrsicher
Enter LUKS passphrase:
key slot 0 unlocked.

  Now I waits ca. 4 minutes until the next message ...

Command successful.
fsck.ext2 /dev/mapper/sehrsicher
e2fsck 1.41.2 (02-Oct-2008)

  Now I wait ...... after 10 minutes ......


-----------------------------------------------------------------------=
---------------

In an another login I made a lsmod:
-----------------------------------------------------------------------=
-----
piepmatz:~# lsmod
Module                  Size  Used by
hifn_795x              17156  1 <------------------ !!!
des_generic            16384  1 hifn_795x
sha256_generic         11392  0
aes_i586                7680  1
aes_generic            27816  1 aes_i586
cbc                     3456  0
ipv6                  221668  18
dm_crypt               11140  1
dm_snapshot            15136  0
dm_mirror              15104  0
dm_log                  8192  1 dm_mirror
dm_mod                 46252  6 dm_crypt,dm_snapshot,dm_mirror,dm_log

=2E..

crypto_blkcipher       15108  4 hifn_795x,cbc,dm_crypt
=2E..
piepmatz:~# _
-----------------------------------------------------------------------=
------

The hifn_795x module is used by 1 process, but it doesn't work.

-------------------------------------------------------------

I try the same with the original linux kernel (2.6.26) which belongs to
Debian Lenny/sid:

With geode-aes & hifn_795x:

-----------------------------------------------------------------------=
------

(/dev/hdb4 is created with keysize 256 bit)

piepmatz:~# miscmount
cryptsetup luksOpen /dev/hdb4 sehrsicher
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.
fsck.ext2 /dev/mapper/sehrsicher
e2fsck 1.41.2 (02-Oct-2008)
MISC: sauber, 12/19226624 Dateien, 1397936/76884824 Bl=F6cke
mount -o noatime /dev/mapper/sehrsicher /misc
piepmatz:~#
piepmatz:~# lsmod
Module                  Size  Used by
sha256_generic         11392  0
aes_i586                7680  2
aes_generic            29224  1 aes_i586
cbc                     3200  1
ipv6                  225172  18
dm_crypt               11012  1
dm_snapshot            14240  0
dm_mirror              14720  0
dm_log                  8192  1 dm_mirror
dm_mod                 45384  6 dm_crypt,dm_snapshot,dm_mirror,dm_log

=2E..

hifn_795x              17028  0  <------------- !!!
cs5535_gpio             3804  0
rng_core                3972  2 geode_rng,hifn_795x
des_generic            16640  1 hifn_795x
geode_aes               5508  3  <------------- !!!
soundcore               6112  1 snd
crypto_blkcipher       14724  5 cbc,dm_crypt,hifn_795x,geode_aes

=2E..

piepmatz:~# cd /misc
piepmatz:/misc# time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D7=
00000
700000+0 Datens=E4tze ein
700000+0 Datens=E4tze aus
716800000 Bytes (717 MB) kopiert, 124,913 s, 5,7 MB/s

real    2m6.286s
user    0m0.940s
sys     0m10.669s
piepmatz:/misc#
piepmatz:/misc# rm xxx.img
piepmatz:/misc# time dd if=3D/dev/zero of=3Dxxx.img bs=3D1024 count=3D7=
00000
700000+0 Datens=E4tze ein
700000+0 Datens=E4tze aus
716800000 Bytes (717 MB) kopiert, 124,961 s, 5,7 MB/s

real    2m4.987s
user    0m0.880s
sys     0m10.345s
piepmatz:/misc#
-----------------------------------------------------------------------=
--------------


I unload geode-aes and let the hifn_795x

-----------------------------------------------------------------------=
--------------
piepmatz:/misc# cd
piepmatz:~# miscumount
umount /misc
cryptsetup luksClose sehrsicher
piepmatz:~#
piepmatz:~# modprobe -r geode-aes
piepmatz:~# miscmount
cryptsetup luksOpen /dev/hdb4 sehrsicher
Enter LUKS passphrase:
[  895.128730] device-mapper: table: 254:0: crypt: Block size of ESSIV
cipher does not match IV size of block cipher
[  895.131582] device-mapper: ioctl: error adding target to table
[  895.201864] device-mapper: ioctl: device doesn't appear to be in the
dev hash table.
Command failed: No key available with this passphrase.

piepmatz:~#
-----------------------------------------------------------------------=
--------------

I try an another chiper ("aes-cbc-plain", keysize 256 Bit)


piepmatz:/usr/local/sbin# createmisc
cryptsetup -c aes-cbc-plain -y -s 256 luksFormat /dev/hdb4

WARNING!
=3D=3D=3D=3D=3D=3D=3D=3D
This will overwrite data on /dev/hdb4 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase:
Verify passphrase:
[ 1106.016371] device-mapper: crypt: Selected cipher does not support I=
Vs
[ 1127.932915] ------------[ cut here ]------------
[ 1127.935606] kernel BUG at mm/slab.c:3008!
[ 1127.935606] invalid opcode: 0000 [#1]
[ 1127.935606] Modules linked in: sha256_generic aes_i586 aes_generic
cbc ipv6 dm_crypt dm_snapshot dm_mirror dm_log dm_mod loop evdev
snd_pcsp snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy geode_rng
snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device
hifn_795x cs5535_gpio rng_core snd des_generic soundcore
crypto_blkcipher snd_page_alloc ext2 mbcache ide_disk ata_generic libat=
a
scsi_mod dock ide_pci_generic ohci_hcd ehci_hcd amd74xx ide_core usbcor=
e
via_rhine mii thermal_sys [laaded: geode_aes]27.935606]
[ 1127.935606] Pid: 2148, comm: sshd Not tainted (2.6.26-1-486 #1)
[ 1127.935606] EIP: 0060:[<c0162f1d>] EFLAGS: 00010092 CPU: 0
[ 1127.935606] EIP is at cache_alloc_refill+0xc4/0x3e3
[ 1127.935606] EAX: 0000001e EBX: 00000000 ECX: df401240 EDX: df401240
[ 1127.935606] ESI: df740020 EDI: df4031a0 EBP: df406800 ESP: df6b7e9c
[ 1127.935606]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1127.935606] Process sshd (pid: 2148, ti=3Ddf6b6000 task=3Dde2d1400
task.ti=3Ddf6b6000)
[ 1127.935606] Stack: 00000001 de7bc56c 000000d0 df401240 00000010
00000001 00000000 00000001
[ 1127.935606]        c0349480 df401240 00000296 000000d0 c0162e1c
c0349480 fffffffe de0d93c0
[ 1127.935606]        00000000 c0189afb df6b7fb8 de0d93c0 00000007
de7bc56c df6b7f44 00000000
[ 1127.935606] Call Trace:
[ 1127.935606]  [<c0162e1c>] kmem_cache_alloc+0x40/0x7d
[ 1127.935606]  [<c0189afb>] load_elf_binary+0x1d/0x103d
[ 1127.935606]  [<c01560be>] get_user_pages+0x29d/0x32d
[ 1127.935606]  [<c0168406>] get_arg_page+0x2a/0x79
[ 1127.935606]  [<c0168650>] copy_strings+0x161/0x16b
[ 1127.935606]  [<c01686fc>] search_binary_handler+0x76/0x17c
[ 1127.935606]  [<c0169573>] do_execve+0x12b/0x1b6
[ 1127.935606]  [<c0102138>] sys_execve+0x2a/0x49
[ 1127.935606]  [<c01037b2>] syscall_call+0x7/0xb
[ 1127.935606]  [<c02a0000>] wext_handle_ioctl+0x17f/0x357
[ 1127.935606]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[ 1127.935606] Code: c0 00 00 00 8b 37 39 fe 75 15 8b 77 10 8d 47 10 c7
47 30 01 00 00 00 39 c6 0f 84 9c 00 00 00 8b 54 24 0c 8b 42 1c 39 46 10
72 2e <0f> 0b eb fe 8b 44 24 0c 8b 5e 14 8b 4d 00 8b 50 10 8b 44 24 04
[ 1127.935606] EIP: [<c0162f1d>] cache_alloc_refill+0xc4/0x3e3 SS:ESP
0068:df6b7e9c
[ 1127.935606] ---[ end trace 3a58b8adb484f036 ]---

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.932915] ------------[ cut here ]------------

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] invalid opcode: 0000 [#1]

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] Process sshd (pid: 2148, ti=3Ddf6b6000
task=3Dde2d1400 task.ti=3Ddf6b6000)

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] Stack: 00000001 de7bc56c 000000d0
df401240 00000010 00000001 00000000 00000001

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]        c0349480 df401240 00000296
000000d0 c0162e1c c0349480 fffffffe de0d93c0

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]        00000000 c0189afb df6b7fb8
de0d93c0 00000007 de7bc56c df6b7f44 00000000

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] Call Trace:

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0162e1c>] kmem_cache_alloc+0x40/0x7=
d

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0189afb>] load_elf_binary+0x1d/0x10=
3d

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c01560be>] get_user_pages+0x29d/0x32=
d

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0168406>] get_arg_page+0x2a/0x79

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0168650>] copy_strings+0x161/0x16b

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c01686fc>]
search_binary_handler+0x76/0x17c

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0169573>] do_execve+0x12b/0x1b6

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c0102138>] sys_execve+0x2a/0x49

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c01037b2>] syscall_call+0x7/0xb

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  [<c02a0000>] wext_handle_ioctl+0x17f/0=
x357

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] Code: c0 00 00 00 8b 37 39 fe 75 15 8b
77 10 8d 47 10 c7 47 30 01 00 00 00 39 c6 0f 84 9c 00 00 00 8b 54 24 0c
8b 42 1c 39 46 10 72 2e <0f> 0b eb fe 8b 44 24 0c 8b 5e 14 8b 4d 00 8b
50 10 8b 44 24 04

Message from syslogd@piepmatz at Sat Nov  1 16:58:20 2008 ...
piepmatz kernel: [ 1127.935606] EIP: [<c0162f1d>]
cache_alloc_refill+0xc4/0x3e3 SS:ESP 0068:df6b7e9c

-----------------------------------------------------------------------=
---------------------------------------------

After reboot:

-----------------------------------------------------------------------=
---------------------------------------------
piepmatz:/usr/local/sbin# modprobe -vr geode-aes hifn_795x
rmmod /lib/modules/2.6.26-1-486/kernel/drivers/crypto/geode-aes.ko
rmmod /lib/modul[  179.825599] Driver for HIFN 795x crypto accelerator
chip has been successfully unregistered.
es/2.6.26-1-486/kernel/drivers/crypto/hifn_795x.ko
rmmod /lib/modules/2.6.26-1-486/kernel/crypto/des_generic.ko
piepmatz:/usr/local/sbin#
piepmatz:/usr/local/sbin# createmisc
cryptsetup -c aes-cbc-plain -y -s 256 luksFormat /dev/hdb4

WARNING!
=3D=3D=3D=3D=3D=3D=3D=3D
This will overwrite data on /dev/hdb4 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase:
Verify passphrase:
[  266.354881] padlock: VIA PadLock not detected.
Command successful.
piepmatz:/usr/local/sbin#
piepmatz:/usr/local/sbin# cryptsetup luksOpen /dev/hdb4 sehrsicher
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.
piepmatz:/usr/local/sbin#
piepmatz:/usr/local/sbin# mkfs.ext2 -L MISC /dev/mapper/sehrsicher
mke2fs 1.41.2 (02-Oct-2008)
Dateisystem-Label=3DMISC
OS-Typ: Linux
Blockgr=F6=DFe=3D4096 (log=3D2)
=46ragmentgr=F6=DFe=3D4096 (log=3D2)
19226624 Inodes, 76884824 Bl=F6cke
3844241 Bl=F6cke (5.00%) reserviert f=FCr den Superuser
Erster Datenblock=3D0
Maximale Dateisystem-Bl=F6cke=3D0
2347 Blockgruppen
32768 Bl=F6cke pro Gruppe, 32768 Fragmente pro Gruppe
8192 Inodes pro Gruppe
Superblock-Sicherungskopien gespeichert in den Bl=F6cken:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616

Schreibe Inode-Tabellen:  1313erledigt
Schreibe Superbl=F6cke und Dateisystem-Accountinginformationen: erledig=
t

Das Dateisystem wird automatisch nach jeweils 30 Einh=E4ng-Vorg=E4ngen =
bzw.
alle 180 Tage =FCberpr=FCft, je nachdem, was zuerst eintritt. Ver=E4nde=
rbar mit
tune2fs -c oder -t .
piepmatz:/usr/local/sbin#
-----------------------------------------------------------------------=
-------------

=46AZIT:

When I use the software modules (aes_i586, aes_generic) all works.

The hifn_795x module without geode-aes module works NOT!
It seems when both modules hifn_795x and goede-aes are loaded only
the geode-aes is used (only with keysize 128).

Regards
Andreas
--=20
Andreas Gerlich, University of Ulm, Germany
open source project --> http://yaze-ag.de/ (Yet Another Z80 Emulator)

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
