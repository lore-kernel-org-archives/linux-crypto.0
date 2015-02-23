From: Johannes Ernst <johannes.ernst@gmail.com>
Subject: Re: [dm-crypt] cryptsetup problem on Raspberry Pi 2 w 512bit key-size (works on Raspberry Pi 1, x86_64, 256bit)
Date: Mon, 23 Feb 2015 15:02:15 -0800
Message-ID: <4E1A4B12-1B94-4ECF-B2E8-BDAD1EE0C37C@gmail.com>
References: <2E68FEAA-A69B-4E25-84F9-F30B2E7DFB69@gmail.com> <54E7B46D.8060805@tu-ilmenau.de> <E401AE9C-F988-4839-AC13-62D4FADD7290@gmail.com> <54E82B80.8000607@gmail.com> <EE112BA4-BDD8-4CB3-BD7B-BDA984D15089@gmail.com> <54EA39FA.7010408@gmail.com> <707C4FCB-0182-44E3-946A-19434F32BEAB@gmail.com> <54EB7977.70503@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dm-crypt@saout.de, Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
	linux-crypto@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38227 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbBWXCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 18:02:18 -0500
Received: by pdbfp1 with SMTP id fp1so28752923pdb.5
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 15:02:17 -0800 (PST)
In-Reply-To: <54EB7977.70503@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All in one place:

> dd if=3D/dev/zero of=3D./test.img count=3D8 bs=3D1M

> cryptsetup --hash sha512 --key-size 512 -v luksFormat ./test.img
Used password =E2=80=98asdf=E2=80=99 (no quotes)

> cryptsetup open test.img test
Enter passphrase for test.img:=20
No key available with this passphrase.
Enter passphrase for test.img:=20
No key available with this passphrase.
^C

> cryptsetup luksDump test.img    =20
LUKS header information for test.img

Version:       	1
Cipher name:   	aes
Cipher mode:   	xts-plain64
Hash spec:     	sha512
Payload offset:	4096
MK bits:       	512
MK digest:     	a6 c0 8d f7 f8 db b0 95 77 b7 72 09 3f 8f 86 ff 6f 31 0=
b a1=20
MK salt:       	1c 9f 21 cf 2c 81 26 49 cc 36 a0 3a 6d 9e 49 a3=20
               	43 3d a7 38 7d 12 86 5b 4e df f9 ac 38 1c a4 38=20
MK iterations: 	1000
UUID:          	d4a0b4ab-b15e-4faf-8504-7e01d88dd9de

Key Slot 0: ENABLED
	Iterations:         	4289
	Salt:               	3c 8b 2e de 72 3f 17 5c 4c 3b d3 ca 5e 09 77 11=20
	                      	69 10 1d 54 ab de c8 87 f9 fd 76 b5 e4 13 1e 04=
=20
	Key material offset:	8
	AF stripes:            	4000
Key Slot 1: DISABLED
Key Slot 2: DISABLED
Key Slot 3: DISABLED
Key Slot 4: DISABLED
Key Slot 5: DISABLED
Key Slot 6: DISABLED
Key Slot 7: DISABLED

> cryptsetup open --debug test.img test
# cryptsetup 1.6.6 processing "cryptsetup open --debug test.img test"
# Running command open.
# Locking memory.
# Installing SIGINT/SIGTERM handler.
# Unblocking interruption on signal.
# Allocating crypt device test.img context.
# Trying to open and read device test.img.
# Initialising device-mapper backend library.
# Trying to load LUKS1 crypt type from device test.img.
# Crypto backend (gcrypt 1.6.2) initialized.
# Detected kernel Linux 3.18.7-5-ARCH armv7l.
# Reading LUKS header of size 1024 from device test.img
# Key length 64, device size 16384 sectors, header size 4036 sectors.
# Timeout set to 0 miliseconds.
# Password retry count set to 3.
# Password verification disabled.
# Iteration time set to 1000 miliseconds.
# Activating volume test [keyslot -1] using [none] passphrase.
# dm version   OF   [16384] (*1)
# dm versions   OF   [16384] (*1)
# Detected dm-crypt version 1.13.0, dm-ioctl version 4.28.0.
# Device-mapper backend running with UDEV support enabled.
# dm status test  OF   [16384] (*1)
# Interactive passphrase entry requested.
Enter passphrase for test.img:=20
# Trying to open key slot 0 [ACTIVE_LAST].
# Reading key slot 0 area.
# Using userspace crypto wrapper to access keyslot area.
# Trying to open key slot 1 [INACTIVE].
# Trying to open key slot 2 [INACTIVE].
# Trying to open key slot 3 [INACTIVE].
# Trying to open key slot 4 [INACTIVE].
# Trying to open key slot 5 [INACTIVE].
# Trying to open key slot 6 [INACTIVE].
# Trying to open key slot 7 [INACTIVE].
No key available with this passphrase.
# Interactive passphrase entry requested.
Enter passphrase for test.img:=20
# Trying to open key slot 0 [ACTIVE_LAST].
# Reading key slot 0 area.
# Using userspace crypto wrapper to access keyslot area.
Key slot 0 unlocked.
# Allocating a free loop device.
# Trying to open and read device /dev/loop5.
# Calculated device size is 12288 sectors (RW), offset 4096.
# DM-UUID is CRYPT-LUKS1-d4a0b4abb15e4faf85047e01d88dd9de-test
# Udev cookie 0xd4d3a56 (semid 720898) created
# Udev cookie 0xd4d3a56 (semid 720898) incremented to 1
# Udev cookie 0xd4d3a56 (semid 720898) incremented to 2
# Udev cookie 0xd4d3a56 (semid 720898) assigned to CREATE task(0) with =
flags         (0x0)
# dm create test CRYPT-LUKS1-d4a0b4abb15e4faf85047e01d88dd9de-test OF  =
 [16384] (*1)
# dm reload test  OFW    [16384] (*1)
# dm resume test  OFW    [16384] (*1)
# test: Stacking NODE_ADD (253,9) 0:0 0600 [verify_udev]
# test: Stacking NODE_READ_AHEAD 256 (flags=3D1)
# Udev cookie 0xd4d3a56 (semid 720898) decremented to 1
# Udev cookie 0xd4d3a56 (semid 720898) waiting for zero
# Udev cookie 0xd4d3a56 (semid 720898) destroyed
# test: Processing NODE_ADD (253,9) 0:0 0600 [verify_udev]
# test: Processing NODE_READ_AHEAD 256 (flags=3D1)
# test (253:9): read ahead is 256
# test: retaining kernel read ahead of 256 (requested 256)
# Releasing crypt device test.img context.
# Releasing device-mapper backend.
# Closed loop /dev/loop5 (test.img).
# Unlocking memory.
Command successful.
