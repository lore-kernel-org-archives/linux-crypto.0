From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: crypto regression?
Date: Thu, 8 Dec 2016 11:41:55 +0100
Message-ID: <10260816-d835-746e-d69e-da4cd7b6b88e@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:36711 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbcLHKmA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 05:42:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Let me report a potential regression I've noticed this morning when testing
linux-next.

I've set CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n when compiling both kernel
images.


On 4.9.0-rc2-next-20161028, /proc/crypto displays:
driver       : atmel-xts-aes
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

and no output from the test manager in the boot log.


Whereas on 4.9.0-rc8-next-20161208, we get:
driver       : atmel-xts-aes
module       : kernel
priority     : 300
refcnt       : 1
selftest     : unknown
internal     : no
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>


Also I see the following traces during the boot:

alg: skcipher: Chunk test 1 failed on encryption at page 0 for atmel-xts-aes
00000000: 1c 3b 3a 10 2f 77 03 86 e4 83 6c 99 e3 70 cf 9b
00000010: ea 00 80 3f 5e 48 23 57 a4 ae 12 d4 14 a3 e6 3b
00000020: 5d 31 e2 76 f8 fe 4a 8d 66 b3 17 f9 ac 68 3f 44
00000030: 68 0a 86 ac 35 ad fc 33 45 be fe cb 4b b1 88 fd
00000040: 57 76 92 6c 49 a3 09 5e b1 08 fd 10 98 ba ec 70
00000050: aa a6 69 99 a7 2a 82 f2 7d 84 8b 21 d4 a7 41 b0
00000060: c5 cd 4d 5f ff 9d ac 89 ae ba 12 29 61 d0 3a 75
00000070: 71 23 e9 87 0f 8a cf 10 00 02 08 87 89 14 29 ca
00000080: 2a 3e 7a 7d 7d f7 b1 03 55 16 5c 8b 9a 6d 0a 7d
00000090: e8 b0 62 c4 50 0d c4 cd 12 0c 0f 74 18 da e3 d0
000000a0: b5 78 1c 34 80 3f a7 54 21 c7 90 df e1 de 18 34
000000b0: f2 80 d7 66 7b 32 7f 6c 8c d7 55 7e 12 ac 3a 0f
000000c0: 93 ec 05 c5 2e 04 93 ef 31 a1 2d 3d 92 60 f7 9a
000000d0: 28 9d 6a 37 9b c7 0c 50 84 14 73 d1 a8 cc 81 ec
000000e0: 58 3e 96 45 e0 7b 8d 96 70 65 5b a5 bb cf ec c6
000000f0: dc 39 66 38 0a d8 fe cb 17 b6 ba 02 46 9a 02 0a
00000100: 84 e1 8e 8f 84 25 20 70 c1 3e 9f 1f 28 9b e5 4f
00000110: bc 48 14 57 77 8f 61 60 15 e1 32 7a 02 b1 40 f1
00000120: 50 5e b3 09 32 6d 68 37 8f 83 74 59 5c 84 9d 84
00000130: f4 c3 33 ec 44 23 88 51 43 cb 47 bd 71 c5 ed ae
00000140: 9b e6 9a 2f fe ce b1 be c9 de 24 4f be 15 99 2b
00000150: 11 b7 7c 04 0f 12 bd 8f 6a 97 5a 44 a0 f9 0c 29
00000160: a9 ab c3 d4 d8 93 92 72 84 c5 87 54 cc e2 94 52
00000170: 9f 86 14 dc d2 ab a9 91 92 5f ed c4 ae 74 ff ac
00000180: 6e 33 3b 93 eb 4a ff 04 79 da 9a 41 0e 44 50 e0
00000190: dd 7a e4 c6 e2 91 09 00 57 5d a4 01 fc 07 05 9f
000001a0: 64 5e 8b 7e 9b fd ef 33 94 30 54 ff 84 01 14 93
000001b0: c2 7b 34 29 ea ed b4 ed 53 76 44 1a 77 ed 43 85
000001c0: 1a d7 7f 16 f5 41 df d2 69 d5 0d 6a 5f 14 fb 0a
000001d0: b5 32 fd 6f 01 77 3d 53 f7 a4 70 83 46 bc 5f c4
000001e0: f3 6f fd a9 fc ea 70 b9 c6 e6 93 e1

The output is a little bit long for test 1, isn't it?
When I look at aes_xts_enc_tv_template[] from crypto/testmgr.h
I see .rlen = 32 .


I didn't bisect to find out exactly since when the regression is there. I
wanted to warn you quickly since we are close to the merge window.
Also if you have already been notified about this issue, please, sorry for
the noise!

Best regards,

Cyrille
