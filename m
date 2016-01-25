From: Stephan Mueller <smueller@chronox.de>
Subject: AF_ALG: hash returns -ENOKEY
Date: Mon, 25 Jan 2016 22:22:36 +0100
Message-ID: <6333443.68gdEOIkbe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42490 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015AbcAYVWr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 16:22:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

during testing of the current cryptodev-2.6 key, the AF_ALG hash does not seem 
to work as it used to.

Regardless whether I use the vmsplice or the sendmsg call, I get -ENOKEY using 
a normal hash.

When you use by libkcapi/test/ [1] test application with the following 
command, I always get the error:

./kcapi -x 3 -c sha256 -p 38f86d

Expected result is 
cc42f645c5aa76ac3154b023359b665375fc3ae42f025fe961fb0f65205ad70e

[1] http://www.chronox.de/libkcapi.html

Ciao
Stephan
