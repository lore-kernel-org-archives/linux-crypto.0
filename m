From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: LRW endian issues?
Date: Thu, 5 Feb 2009 11:55:37 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902051146540.6558@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41721 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751869AbZBEKzj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 05:55:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When running "modprobe tcrypt mode=3D10" on ppc64 (PS3), I get the foll=
owing
error:

| alg: skcipher: Test 8 failed on encryption for lrw(aes-generic)
| 00000000: 1a 1d a9 30 ad f9 2f 9b b6 1d ae ef f0 2f f8 5a=20
| 00000010: 3d de 22 4d 7e b1 75 e0 d2 db 9e ba 64 b2 5d 93=20
| 00000020: 4d 14 3d b8 5b 80 9d 57 2e 64 c7 95 d8 b5 a7 3b=20
| 00000030: 3d 39 8a 9b 59 1c 73 12 2f 58 00 6f 28 3f 72 23=20
| 00000040: ad 75 cd c0 17 2b bf 62 d2 b2 f9 b7 3f de 3e 83=20
| 00000050: f2 fa e2 3a e3 03 14 84 3b 47 0e 94 ad 7f e0 dc=20
| 00000060: 13 c7 56 75 3c 8f 38 88 dd 7f b7 44 b9 30 aa f6=20
| 00000070: 61 dc b7 4d 72 7e 43 3e 19 a9 fb 1b d4 18 d6 1c=20
| 00000080: 1d 73 9b 47 7a c9 c7 4b 30 2a 12 4f d7 1e eb bc=20
| 00000090: e3 13 5b 1c f0 41 33 ae f8 81 a4 54 42 d0 fc 6c=20
| 000000a0: 65 c5 b2 d8 96 43 ba 11 8d 89 a7 4d 75 e4 3e 07=20
| 000000b0: 82 11 74 47 70 ff 37 5d 03 ef ec 1d 43 9b 28 10=20
| 000000c0: ea 67 4e f9 10 9a f4 70 36 e6 af db cb 05 22 54=20
| 000000d0: 56 41 fa 15 01 c3 ed ce 2f 15 35 df 0e fc 88 bc=20
| 000000e0: c1 a9 df 2e 25 74 64 5a 21 81 e7 7d 43 ea 85 fc=20
| 000000f0: 50 d2 5c e6 70 be 56 8a dc cb d1 c3 98 e5 d8 0d=20
| 00000100: c5 93 2a 30 b7 0e 29 44 6a a4 ca 64 f8 a8 21 6a=20
| 00000110: 48 8e fc 5f e7 d7 d3 73 20 e6 fe 97 cd d4 33 2e=20
| 00000120: 0c 57 0c 55 15 e4 4e 62 cf 6a 0a 5f b0 c0 2e da=20
| 00000130: 86 f8 97 7b 8c ba fc 28 11 29 60 a1 84 0e 4d be=20
| 00000140: 75 04 45 8d 9b 43 e9 69 e3 46 87 8d 4c c9 c9 e8=20
| 00000150: cf 35 82 38 c8 91 13 db cd 4e 8f 39 13 0f fd c9=20
| 00000160: 70 73 d2 8d e3 1b 2b 3b 1d b2 bc 53 bc 05 ca 69=20
| 00000170: ee c7 62 77 4e 40 d2 88 7e 1b 81 54 38 9d 98 f1=20
| 00000180: ef cb dd 4b 14 50 fe 57 0a 2c 5c ed 27 a8 de e3=20
| 00000190: 73 c1 55 d3 43 1a f0 98 54 7c 82 9f 7b fa 48 5c=20
| 000001a0: b5 b9 90 e2 62 f4 5d 3d 28 34 34 52 47 58 9d ec=20
| 000001b0: d3 82 07 aa 75 c1 7e f5 03 1f 7f 4b 89 ac a9 89=20
| 000001c0: 3c 91 85 7e 5f 70 00 20 55 aa 31 84 3c a9 d2 44=20
| 000001d0: 88 da 71 71 d8 e0 c3 86 c6 6e c2 5e cb 5a 6c fc=20
| 000001e0: a7 52 0d bf 42 0e c2 fa 9f 59 a6 9b ca 4d fa 50=20
| 000001f0: 02 fa 55 94 a7 d0 5b 68 3c 35 49 0f 49 d4 3d b4=20

and the modprobe hangs.

I also tried on ppc32 and m68k, where I got similar results (the first =
line is
identical to the ppc64 case, the others aren't):

| alg: skcipher: Test 8 failed on encryption for lrw(aes-generic)
| 00000000: 1a 1d a9 30 ad f9 2f 9b b6 1d ae ef f0 2f f8 5a=20
| 00000010: bd 65 86 e6 dd 79 e0 2a d4 0c c3 9d 03 fd e5 eb=20
| 00000020: 3f 8e 52 4e ea b4 f5 a9 d3 7f 96 88 4d ea ab db=20
| 00000030: 7e ae b4 ac ba ea 06 88 40 55 28 3e 6c 65 12 08=20
| 00000040: fe 6d 1b 5e b3 ba 88 95 f5 f1 ba 74 12 c7 59 bd=20
| 00000050: 59 66 bc 71 2c 72 82 36 03 45 e9 1f cd 39 a0 a8=20
| 00000060: a3 44 6e 4b e8 80 c7 ec d3 5d 21 37 1d e6 ca 43=20
| 00000070: 66 a0 32 e7 fc a5 8f e7 83 bc 71 47 78 3b 50 bf=20
| 00000080: 92 74 53 44 ac de b4 16 45 87 45 f4 43 8a 19 0e=20
| 00000090: 4b 7a b6 f1 d9 5e 22 82 4c 0e b7 82 ac 8e 9c 88=20
| 000000a0: d4 3b 7e 5d 9a eb 71 fa 21 11 88 79 51 56 05 c3=20
| 000000b0: af 3a 45 8a 00 d1 96 77 59 04 90 cb d4 fc 2a 35=20
| 000000c0: e7 47 00 83 fd 9c 88 0c 0b 89 3e 69 e3 63 d0 73=20
| 000000d0: 70 b3 71 21 9f 22 dd 20 3c 2a 9a 3a 03 3b d2 22=20
| 000000e0: fc 35 68 d4 99 b6 01 41 48 cf 3c a5 86 83 06 0d=20
| 000000f0: 49 8f 41 ed fa 43 42 e9 37 81 58 4e 18 bf fc d2=20
| 00000100: 06 c1 73 1e 92 0d 73 c6 86 a6 73 9f 97 5a 62 10=20
| 00000110: 18 0a ce 5c 58 66 4d 4d c8 25 6d fe c9 b7 ca e3=20
| 00000120: 4c 29 d7 9d bc 7a 8b 61 29 82 8f 4c 3e 80 61 13=20
| 00000130: 85 2c 5b 9c 78 ec 8e d6 1f 66 85 b5 2f 74 bd cd=20
| 00000140: 5a 5d 1f 17 b5 e5 ae 12 d8 3e 3a bc 28 a3 b2 77=20
| 00000150: 3c 4b 7a f8 bd 1a d3 5f 73 3e 84 df 3a a7 0b 30=20
| 00000160: 4e 82 34 e8 64 a0 cf 29 b6 de da 39 69 1c 59 91=20
| 00000170: 0d c7 ec 79 83 1b 25 1f f9 2d e8 ff d5 07 00 16=20
| 00000180: de 61 f3 a5 2a ed 95 96 31 4d da 2c f9 c4 84 4b=20
| 00000190: 44 47 da 1a 97 17 f1 01 cd 3e 55 69 89 99 50 9a=20
| 000001a0: d8 5c 6f 53 ad 07 89 22 6e 78 42 c3 84 3a 01 b9=20
| 000001b0: a8 05 4a f6 b6 d5 d9 f5 38 96 cf 45 53 42 ac 63=20
| 000001c0: 17 f2 59 7a 46 a4 04 68 c1 a7 7a de 59 65 44 7b=20
| 000001d0: 29 b2 d0 75 17 8b f2 f9 22 ef 13 48 7d 17 d6 23=20
| 000001e0: 91 f3 2e aa e5 2f df e6 f4 84 8a b7 0a 0c 0b c1=20
| 000001f0: 0b 72 75 de 9a b9 ec e2 05 2c 87 0c ca 7e a8 a8=20

On x86-32 (User-Mode-Linux) it works fine, so this looks like an endian=
 issue.

I'm using 2.6.29-rc3+.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
