From: sri sowj <srisowj4linux@gmail.com>
Subject: Counter Size in CTR mode for AES Driver
Date: Sat, 11 Apr 2015 00:30:30 +0530
Message-ID: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34395 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbbDJTAa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 15:00:30 -0400
Received: by obbry2 with SMTP id ry2so28534674obb.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2015 12:00:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

I have seen multiple open source drivers for AES(CTR) mode for
different Crypto Hardware Engines, I was not really sure on
countersize,nonce etc.
Please can any one provide some info on the following

#1:How does AES driver identifies the counter size during the CTR mode
of operation?

looks like AES in CTR mode supports "countersize" of multiple lengths as below:

>>1: First is a counter which is made up of a nonce and counter. The nonce is random, and the remaining bytes are counter bytes (which are incremented).
 For example, a 16 byte block cipher might use the high 8 bytes as a
nonce, and the low 8 bytes as a counter.

>>2: Second is a counter block, where all bytes are counter bytes and can be incremented as carries are generated.
 For example, in a 16 byte block cipher, all 16 bytes are counter bytes

#2: Does Linux Kernel Crypto subsystem increments the counter value
for every block of input or is it needs tp be taken care by Kernel
Driver for the respective Crypto H/W ?


#3:counters and nonces are something which will be extracted from the
IV i.e., IV = nonce + counter
Note if "l" is length of IV then first "l/2" is length of nonce and
next "l/2" is length of counter.

Any information regarding the above is really appreciable.

BR,
SriSowj
