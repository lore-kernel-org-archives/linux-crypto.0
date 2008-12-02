From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
Subject: Re: next-20081125: crypto hard disk gets unaccessable
Date: Tue, 2 Dec 2008 12:55:42 +0100
Message-ID: <20081202115542.GB4525__46645.7624723718$1228219046$gmane$org@denkbrett.schottelius.org>
References: <20081128063355.GA4700@denkbrett.schottelius.org> <20081129192939.925275f0.akpm@linux-foundation.org> <20081201173528.GD8005@denkbrett.schottelius.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christophe Saout <christophe@saou
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.schottelius.org ([77.109.138.221]:35282 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYLBLzo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 06:55:44 -0500
Content-Disposition: inline
In-Reply-To: <20081201173528.GD8005@denkbrett.schottelius.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--8X7/QrJGcKSMr1RN
Content-Type: multipart/mixed; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Same issue with next-20081201, dmesg attached.

I am not sure whether this happened before I tried to suspend
it the second time (echo mem > /sys/power/state) or directly
when I issued that command (maybe the latter one).

One time suspend + resume worked, though.

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash-2.6.28-rc6-next-20081201-denkbrett"
Content-Transfer-Encoding: quoted-printable

[45950.154982] sierra ttyUSB0: Sierra USB modem converter now disconnected =
=66rom ttyUSB0
[45950.155025] sierra 8-1:1.0: device disconnected
[45950.155577] sierra ttyUSB1: Sierra USB modem converter now disconnected =
=66rom ttyUSB1
[45950.155613] sierra 8-1:1.1: device disconnected
[45950.156624] sierra ttyUSB2: Sierra USB modem converter now disconnected =
=66rom ttyUSB2
[45950.156663] sierra 8-1:1.2: device disconnected
[45950.157070] sierra 8-1:1.3: device disconnected
[45950.157744] sierra ttyUSB4: Sierra USB modem converter now disconnected =
=66rom ttyUSB4
[45950.158358] sierra 8-1:1.4: device disconnected
[45950.159357] sierra ttyUSB5: Sierra USB modem converter now disconnected =
=66rom ttyUSB5
[45950.159401] sierra 8-1:1.5: device disconnected
[45950.160888] sierra ttyUSB6: Sierra USB modem converter now disconnected =
=66rom ttyUSB6
[45950.160932] sierra 8-1:1.6: device disconnected
[45950.832292] sierra ttyUSB3: Sierra USB modem converter now disconnected =
=66rom ttyUSB3
[45953.116551] general protection fault: 0000 [#1] PREEMPT SMP=20
[45953.116562] last sysfs file: /sys/class/power_supply/BAT0/energy_full
[45953.116567] CPU 1=20
[45953.116571] Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd=
_comp ppp_async crc_ccitt ppp_generic slhc sierra usbserial usb_storage lib=
usual i915 drm rfcomm l2cap bluetooth uinput autofs4 ipv6 cpufreq_powersave=
 sha256_generic ansi_cprng krng chainiv rng aes_x86_64 aes_generic cbc dm_c=
rypt dm_mod md_mod loop arc4 ecb cryptomgr aead crypto_blkcipher crypto_has=
h snd_hda_intel snd_pcm snd_page_alloc snd_hwdep snd_seq snd_timer snd_seq_=
device iwlagn iwlcore rtc_cmos rtc_core rtc_lib i2c_i801 mac80211 snd pcspk=
r i2c_core soundcore cfg80211 ehci_hcd uhci_hcd usbcore video output e1000e=
 wmi 8250_pci 8250 serial_core ata_generic pata_acpi intel_agp thinkpad_acp=
i rfkill hwmon backlight led_class nvram
[45953.116693] Pid: 2686, comm: kcryptd Tainted: G        W  2.6.28-rc6-nex=
t-20081201-denkbrett #17
[45953.116699] RIP: 0010:[<ffffffff8031f56a>]  [<ffffffff8031f56a>] crypto_=
xor+0x7/0x48
[45953.116714] RSP: 0018:ffff88007a54dcc8  EFLAGS: 00010212
[45953.116719] RAX: 00000000fffffff0 RBX: b6e3880000000010 RCX: 00000000000=
00000
[45953.116725] RDX: 0000000000000010 RSI: b6e3880000000000 RDI: ffff88007ac=
b8be0
[45953.116729] RBP: 0000000000000010 R08: 0000000000000010 R09: 00000000000=
00000
[45953.116734] R10: 0000000000000000 R11: ffff88007acb8be0 R12: 00000000000=
00010
[45953.116740] R13: ffff8800208d1000 R14: ffff88007acb8be0 R15: 00000000000=
001f0
[45953.116746] FS:  0000000000000000(0000) GS:ffff88007c002a80(0000) knlGS:=
0000000000000000
[45953.116751] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[45953.116756] CR2: 00007fff1eb20ff0 CR3: 0000000000201000 CR4: 00000000000=
006a0
[45953.116761] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[45953.116766] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[45953.116772] Process kcryptd (pid: 2686, threadinfo ffff88007a54c000, tas=
k ffff88007b4117c0)
[45953.116777] Stack:
[45953.116780]  ffffffffa027426a ffffffff805e3d40 ffff88007a54ddb0 ffff8800=
799e9c00
[45953.116788]  ffff8800794b0660 ffffffffa0287705 fffffff000011212 00000000=
00000000
[45953.116797]  b6e3880000000000 ffffe2000071edb8 ffff8800208d1000 ffff8800=
7acb8ba0
[45953.116807] Call Trace:
[45953.116813]  [<ffffffffa027426a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
[45953.116825]  [<ffffffffa0287705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
[45953.116838]  [<ffffffffa021867d>] ? async_encrypt+0x35/0x3a [crypto_blkc=
ipher]
[45953.116852]  [<ffffffffa026ba6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
[45953.116864]  [<ffffffffa026bed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
[45953.116875]  [<ffffffffa026baf0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]
[45953.116885]  [<ffffffff802417f0>] ? run_workqueue+0x87/0x122
[45953.116894]  [<ffffffff80241963>] ? worker_thread+0xd8/0xe7
[45953.116901]  [<ffffffff80244eec>] ? autoremove_wake_function+0x0/0x2e
[45953.116910]  [<ffffffff8024188b>] ? worker_thread+0x0/0xe7
[45953.116917]  [<ffffffff8024188b>] ? worker_thread+0x0/0xe7
[45953.116924]  [<ffffffff80244bd3>] ? kthread+0x47/0x73
[45953.116931]  [<ffffffff8020c4e9>] ? child_rip+0xa/0x21
[45953.116939]  [<ffffffff80244b8c>] ? kthread+0x0/0x73
[45953.116946]  [<ffffffff8020c4df>] ? child_rip+0x0/0x21
[45953.116953] Code: 08 48 89 51 08 48 89 0a 48 b9 00 01 10 00 00 00 ad de =
48 ba 00 02 20 00 00 00 ad de 48 89 08 48 89 50 08 c3 41 89 d0 31 c9 eb 0e =
<8b> 04 0e 41 83 e8 04 31 04 0f 48 83 c1 04 41 83 f8 03 77 ec 41=20
[45953.117025] RIP  [<ffffffff8031f56a>] crypto_xor+0x7/0x48
[45953.117032]  RSP <ffff88007a54dcc8>
[45953.117078] ---[ end trace 2f749ac1980d74d3 ]---
[45953.117085] note: kcryptd[2686] exited with preempt_count 2
[45963.517068] PM: Syncing filesystems ... <3>ata2: exception Emask 0x10 SA=
ct 0x0 SErr 0x4040000 action 0xe frozen
[47502.081664] ata2: irq_stat 0x00000040, connection status changed
[47502.081672] ata2: SError: { CommWake DevExch }
[47502.081689] ata2: hard resetting link
[47502.804285] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[47502.953771] thinkpad_acpi: unhandled HKEY event 0x6030
[47502.956461] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[47502.959227] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 failed (Emask=3D0x100=
 Stat=3D0x00 Err=3D0x01)
[47503.049288] ACPI: \_SB_.GDCK - docking
[47503.081834] ata2: hard resetting link
[47503.188102] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 4
[47503.321265] usb 7-5: configuration #1 chosen from 1 choice
[47503.321428] hub 7-5:1.0: USB hub found
[47503.321723] hub 7-5:1.0: 4 ports detected
[47503.400070] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[47503.407511] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[47503.408402] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[47503.420001] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[47503.420901] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[47503.424871] ata2.00: configured for UDMA/133
[47503.489845] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: None
[47503.489849] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[47503.490102] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[47503.530452] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[47503.530457] ata2: irq_stat 0x40000001
[47503.558432] ata2.00: configured for UDMA/133
[47503.558437] ata2: EH complete
[47503.608112] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 5
[47503.705093] usb 7-5.4: configuration #1 chosen from 1 choice
[47503.819505] usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[47503.819520] usbcore: registered new interface driver usblp
[47511.469524] hal_lpadmin[755] general protection ip:44c404 sp:7ffff02997a=
0 error:0 in python2.5[400000+125000]
[47517.724104] eth0: no IPv6 routers present
You have new mail.                                                         =
                             =20
[9:34] ikn:eof-hemden%=20


--kXdP64Ggrk/fb43R--

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1Ij4ACgkQuL75KpiFGIwgXgCeIKR30wYLcuV6SVOg5b2cegxO
a3YAoMz2twFhPxlLWVIDJ0J/rg4o3THZ
=uhUs
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
