From: Stephan Mueller <stephan.mueller@atsec.com>
Subject: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 18:10:49 +0200
Message-ID: <1567400.ZMFoPuCv2K@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.atsec.com ([138.201.47.226]:44056 "EHLO mail1.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbcEZQSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 12:18:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.atsec.com (Postfix) with ESMTP id 5F03F7A6
	for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 18:10:57 +0200 (CEST)
Received: from mail1.atsec.com ([127.0.0.1])
	by localhost (mail1.atsec.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id IN9-_MzD_yHf for <linux-crypto@vger.kernel.org>;
	Thu, 26 May 2016 18:10:51 +0200 (CEST)
Received: from tauon.atsec.com (mail.eperm.de [89.247.134.16])
	(Authenticated sender: smueller)
	by mail1.atsec.com (Postfix) with ESMTPSA id 8C5B785
	for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 18:10:51 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

for the DRBG and the LRNG work I am doing, I also test the speed of the=
 DRBG.=20
The DRBG can be considered as a form of block chaining mode on top of a=
 raw=20
cipher.

What I am wondering is that when encrypting 256 16 byte blocks, I get a=
 speed=20
of about 170 MB/s with the AES-NI driver. When using the aes-generic or=
 aes-
asm, I get up to 180 MB/s with all else being equal. Note, that figure=20
includes a copy_to_user of the generated data.

To be precise, the code does the following steps:

1. setkey

2. AES encrypt 256 blocks and copy_to_user

3. Use AES to generate a new key and start at step 1.

I am wondering why the AES-NI driver is slower than the C/ASM implement=
ations=20
given that all else is equal.

Note, if I have less blocks in step 2 above, AES-NI is becoming faster.=
 E.g.=20
if I have 8 blocks or just one block in step 2 above, AES-NI is faster =
by 10=20
or 20%.

Ciao
Stephan
--=20
atsec information security GmbH, Steinstra=DFe 70, 81667 M=FCnchen, Ger=
many
P: +49 89 442 49 830 - F: +49 89 442 49 831
M: +49 172 216 55 78 - HRB: 129439 (Amtsgericht M=FCnchen)
US: +1 949 545 4096
GF: Salvatore la Pietra, Staffan Persson
atsec it security news blog - atsec-information-security.blogspot.com
