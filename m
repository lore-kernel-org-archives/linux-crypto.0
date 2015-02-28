From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] cryptsetup problem on Raspberry Pi 2 w 512bit key-size
 (works on Raspberry Pi 1, x86_64, 256bit)
Date: Sat, 28 Feb 2015 01:48:22 +0100
Message-ID: <54F11056.7020206@gmail.com>
References: <2E68FEAA-A69B-4E25-84F9-F30B2E7DFB69@gmail.com> <54E7B46D.8060805@tu-ilmenau.de> <E401AE9C-F988-4839-AC13-62D4FADD7290@gmail.com> <54E82B80.8000607@gmail.com> <EE112BA4-BDD8-4CB3-BD7B-BDA984D15089@gmail.com> <54EA39FA.7010408@gmail.com> <707C4FCB-0182-44E3-946A-19434F32BEAB@gmail.com> <54EB7977.70503@gmail.com> <4E1A4B12-1B94-4ECF-B2E8-BDAD1EE0C37C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dm-crypt@saout.de, Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
	linux-crypto@vger.kernel.org
To: Johannes Ernst <johannes.ernst@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39911 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbB1As2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 19:48:28 -0500
Received: by wggx12 with SMTP id x12so23447600wgg.6
        for <linux-crypto@vger.kernel.org>; Fri, 27 Feb 2015 16:48:27 -0800 (PST)
In-Reply-To: <4E1A4B12-1B94-4ECF-B2E8-BDAD1EE0C37C@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/24/2015 12:02 AM, Johannes Ernst wrote:
> All in one place:
>=20
>> dd if=3D/dev/zero of=3D./test.img count=3D8 bs=3D1M
>=20
>> cryptsetup --hash sha512 --key-size 512 -v luksFormat ./test.img
> Used password =E2=80=98asdf=E2=80=99 (no quotes)
>=20
>> cryptsetup open test.img test
> Enter passphrase for test.img:=20
> No key available with this passphrase.
> Enter passphrase for test.img:=20
> No key available with this passphrase.

I was able to reproduce it on Raspberry Pi2 B+ and indeed it is Neon co=
de issue.
I am using Raspian, where all cryptocode is compiled as modules:

Without ARM aes_arm_bs module it works:

# echo xxx|src/cryptsetup open test.img --test-passphrase -v
Key slot 0 unlocked.
Command successful.

# modprobe aes_arm_bs

# echo xxx|src/cryptsetup open test.img --test-passphrase -v
device-mapper: reload ioctl on  failed: No such file or directory
=46ailed to setup dm-crypt key mapping for device test.img.
Check that kernel supports aes-xts-plain64 cipher (check syslog for mor=
e info).
Command failed with code 5: Input/output error

(Userspace crypto wrapper failed so code tries to use old dmcrypt tempo=
rary device,
errors above are not directly related to Neon issue.)

And in dmesg module even failed test:

[  318.445489] alg: skcipher: Chunk test 1 failed on decryption at page=
 0 for xts-aes-neonbs
[  318.445515] 00000000: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0=
f
[  318.445526] 00000010: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1=
f
[  318.445534] 00000020: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2=
f
[  318.445543] 00000030: 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3=
f
[  318.445553] 00000040: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4=
f
[  318.445562] 00000050: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5=
f
[  318.445570] 00000060: 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6=
f
[  318.445580] 00000070: 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7=
f
[  318.445588] 00000080: 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8=
f
[  318.445597] 00000090: 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9=
f
[  318.445607] 000000a0: a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae a=
f
[  318.445616] 000000b0: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be b=
f
[  318.445624] 000000c0: c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce c=
f
[  318.445634] 000000d0: d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de d=
f
[  318.445643] 000000e0: e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee e=
f
[  318.445651] 000000f0: f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe f=
f
[  318.445661] 00000100: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0=
f
[  318.445670] 00000110: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1=
f
[  318.445678] 00000120: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2=
f
[  318.445688] 00000130: 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3=
f
[  318.445697] 00000140: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4=
f
[  318.445705] 00000150: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5=
f
[  318.445715] 00000160: 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6=
f
[  318.445723] 00000170: 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7=
f
[  318.445732] 00000180: 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8=
f
[  318.445742] 00000190: 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9=
f
[  318.445750] 000001a0: a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae a=
f
[  318.445759] 000001b0: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be b=
f
[  318.445769] 000001c0: c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce c=
f
[  318.445777] 000001d0: ab 1c bb 4c 15 50 be 97 f7 ab 40 66 19 3c 4c a=
a
[  318.445786] 000001e0: 5b 41 ef c3 ba 09 50 93 f2 c5 00 48

Seems there is an issue with the Neon AES implementation...

Milan
