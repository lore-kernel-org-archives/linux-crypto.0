Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80058C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Oct 2022 14:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiJEOYn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Oct 2022 10:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJEOYm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Oct 2022 10:24:42 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 07:24:40 PDT
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78D165E9
        for <linux-crypto@vger.kernel.org>; Wed,  5 Oct 2022 07:24:40 -0700 (PDT)
Received: (qmail 17739 invoked from network); 5 Oct 2022 14:17:57 -0000
Received: from p200300cf070f090076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70f:900:76d4:35ff:feb7:be92]:41786 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <sparclinux@vger.kernel.org>; Wed, 05 Oct 2022 16:17:57 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     sparclinux@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: Issues with hw crypto and random support on Niagara2
Date:   Wed, 05 Oct 2022 16:17:45 +0200
Message-ID: <3804667.3oa1dkRz9v@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2108249.AKfn3jg4vr"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--nextPart2108249.AKfn3jg4vr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: sparclinux@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Subject: Issues with hw crypto and random support on Niagara2
Date: Wed, 05 Oct 2022 16:17:45 +0200
Message-ID: <3804667.3oa1dkRz9v@eto.sf-tec.de>
MIME-Version: 1.0

[Resend with CC linux-crypto]

I recently upgraded my Sun T5120 the kernel to 5.19.12. The first thing I 
noticed afterwards was that the boot took nearly one hour and spewed lots of 
warnings about crng_init=0. As a workaround I did that:

# grep -n quality /usr/src/linux/drivers/char/hw_random/n2-drv.c 
770:    np->hwrng.quality = 5;

This has solved the issue for me, boot is now down to ~2min again. I wonder if 
I'm missing something obvious like another driver that I should activate?

Then I noticed that the hw crypto support from drivers/crypto/n2_core.c fails 
to load with -EINVAL. From looking at the code I think this is because 
statesize is not set for the hash algorithms, so registering the first one 
(md5) fails and nothing else is tried. I then set NUM_HASH_TMPLS to 0 so they 
were never attempted, which resulted in the second loop succeeding:

[   40.561230] n2_crypto: n2_crypto.c:v0.2 (July 28, 2011)
[   40.561361] n2_crypto: Found N2CP at /virtual-devices@100/n2cp@7
[   40.561506] n2_crypto: Registered NCS HVAPI version 2.0
[   40.562493] n2_crypto: ecb(des) alg registered
[   40.562567] n2_crypto: cbc(des) alg registered
[   40.562687] n2_crypto: cfb(des) alg registered
[   40.562760] n2_crypto: ecb(des3_ede) alg registered
[   40.562833] n2_crypto: cbc(des3_ede) alg registered
[   40.562906] n2_crypto: cfb(des3_ede) alg registered
[   40.563007] n2_crypto: ecb(aes) alg registered
[   40.563084] n2_crypto: cbc(aes) alg registered
[   40.563156] n2_crypto: ctr(aes) alg registered
[   40.563890] n2_crypto: Found NCP at /virtual-devices@100/ncp@6

Maybe someone with the knowledge about the right statesize could send a patch? 
I'm open for testing. This is probably broken for a very long time, i.e. 
8996eafdcbad149ac0f772fb1649fbb75c482a6a (kernel v4.3).

Greetings,

Eike
--nextPart2108249.AKfn3jg4vr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYz2SCQAKCRBcpIk+abn8
Tp2JAKCTzkjE32Q8dazATdi5F3jNsWHYbwCfb1jw+YM6yaua+Gc+KkeOZbFxgtA=
=MGIp
-----END PGP SIGNATURE-----

--nextPart2108249.AKfn3jg4vr--



