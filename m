From: Romain Francoise <romain@orebokech.com>
Subject: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Date: Mon, 15 Sep 2014 10:36:46 +0200
Message-ID: <87sijti8kh.fsf@kima.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stringer.orebokech.com ([212.83.175.182]:45450 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaIOImP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 04:42:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
fails, which makes my IPsec tunnels unhappy (see trace below). Before I
start bisecting (2cddcc7df8fd3 is probably my first guess), is this
already known?

Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Sep 15 08:07:56 silenus kernel: [   35.137149] 00000000: 04 f3 d3 88 17 ef dc ef 8b 04 f8 3a 66 8d 1a 53
Sep 15 08:07:56 silenus kernel: [   35.137150] 00000010: 57 1f 4b 23 e4 a0 af f9 69 95 35 98 8d 4d 8c c1
Sep 15 08:07:56 silenus kernel: [   35.137151] 00000020: f0 b2 7f 80 bb 54 28 a2 7a 1b 9f 77 ec 0e 6e de
Sep 15 08:07:56 silenus kernel: [   35.137152] 00000030: 57 1d d4 66 07 60 e1 80 08 24 3f 93 15 54 bb 2a
Sep 15 08:07:56 silenus kernel: [   35.137153] 00000040: 9f 24 2b 17 92 60 05 68 21 74 a4 0a 28 eb 27 48
Sep 15 08:07:56 silenus kernel: [   35.137153] 00000050: 90 50 37 ca 5c 0b 67 52 27 d2 7c 39 4b 85 35 0a
Sep 15 08:07:56 silenus kernel: [   35.137154] 00000060: 23 90 a1 a0 79 8b 33 c0 73 d6 a0 9b fc 83 c9 f0
Sep 15 08:07:56 silenus kernel: [   35.137155] 00000070: ef 23 22 19 16 6d e8 f4 b1 17 16 30 31 e8 a5 53
Sep 15 08:07:56 silenus kernel: [   35.137155] 00000080: db 04 d8 bf 2e 75 9e 06 68 39 96 ec 38 1c 66 74
Sep 15 08:07:56 silenus kernel: [   35.137156] 00000090: 7f e3 85 62 d5 1c da 83 86 63 07 41 f3 ce 2e c9
Sep 15 08:07:56 silenus kernel: [   35.137157] 000000a0: 3a 6e d8 be bd f3 d7 26 a1 a3 c6 ad 6d 65 32 7b
Sep 15 08:07:56 silenus kernel: [   35.137158] 000000b0: 6a 84 9c 11 1a b2 bc 0f a9 88 1e 4c 6b 36 52 ee
Sep 15 08:07:56 silenus kernel: [   35.137158] 000000c0: eb 4d 79 9d d2 f6 af a9 8c 79 09 16 80 a4 25 9d
Sep 15 08:07:56 silenus kernel: [   35.137159] 000000d0: e1 c5 e5 8e bf 4e cd 3f dd 2d f5 33 b8 ad 3d 2c
Sep 15 08:07:56 silenus kernel: [   35.137160] 000000e0: a1 ac 58 7c 45 3f f7 18 4d 02 93 a1 53 f4 07 f4
Sep 15 08:07:56 silenus kernel: [   35.137161] 000000f0: 4c 31 1e 3a 5b 7f 2d 0a d5 e1 6a eb 1d 55 47 29
Sep 15 08:07:56 silenus kernel: [   35.137161] 00000100: ce 7b 1a 08 c6 62 1a a3 f1 bd 8e 05 7a 86 75 cd
Sep 15 08:07:56 silenus kernel: [   35.137162] 00000110: a7 8e ba 3e 1b 9a ce 2e 10 4b 06 ce ed 5e 6f 77
Sep 15 08:07:56 silenus kernel: [   35.137163] 00000120: 8e bc d0 08 40 2c 86 f2 6b 35 17 4d d7 b8 63 08
Sep 15 08:07:56 silenus kernel: [   35.137163] 00000130: af d9 ed ca ad 5e 0b a4 d9 8e ff 8a d7 9f ae 1b
Sep 15 08:07:56 silenus kernel: [   35.137164] 00000140: 11 1e 51 8e 98 22 09 99 2d ff a3 df 8a 38 76 5c
Sep 15 08:07:56 silenus kernel: [   35.137165] 00000150: df 1a b1 79 2f 00 dc 39 42 d2 fe 0f 66 2b 75 72
Sep 15 08:07:56 silenus kernel: [   35.137166] 00000160: 31 e0 59 34 2e 5a c6 51 3e 39 10 11 a6 42 48 34
Sep 15 08:07:56 silenus kernel: [   35.137166] 00000170: 72 5b 16 8d b4 f8 92 e1 9c 84 34 48 2c db 20 38
Sep 15 08:07:56 silenus kernel: [   35.137167] 00000180: ef 74 1b d1 71 f9 84 f7 17 0e df cc ec 13 80 a3
Sep 15 08:07:56 silenus kernel: [   35.137168] 00000190: 7c 66 7c 2c 1e a4 09 8e ff 4a 19 b6 5f 6d fb 84
Sep 15 08:07:56 silenus kernel: [   35.137169] 000001a0: 13 99 37 d1 b7 e6 36 06 a9 b8 40 39 46 25 56 eb
Sep 15 08:07:56 silenus kernel: [   35.137169] 000001b0: 98 59 07 b2 80 95 fb 98 47 30 e1 8f be 7f c4 7e
Sep 15 08:07:56 silenus kernel: [   35.137170] 000001c0: 77 8f 11 c9 b2 08 15 58 6c 57 20 c0 39 f8 5e f4
Sep 15 08:07:56 silenus kernel: [   35.137171] 000001d0: 0d 91 dc 86 0f b5 99 09 d4 e2 8f a0 bf 83 99 b3
Sep 15 08:07:56 silenus kernel: [   35.137171] 000001e0: c3 98 13 9c dc f7 ad 6a 1c 02 8e 45 43 da 3e c6
Sep 15 08:07:56 silenus kernel: [   35.137195] alg: aead: setkey failed on test 1 for rfc4106-gcm-aesni: flags=0
