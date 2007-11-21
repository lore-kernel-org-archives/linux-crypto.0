From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/4] camellia: 64-bit optimization and code shrink
Date: Wed, 21 Nov 2007 00:22:28 -0800
Message-ID: <200711210022.28510.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: herbert@gondor.apana.org.au,
	Noriaki TAKAMIYA <takamiya@linux-ipv6.org>,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:9515 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXKUIWh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 03:22:37 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2703177wah
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 00:22:37 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patches start from 5 because pathches 1..4 are already
in cryptodev-2.6.

camellia5:
        adds 64-bit key setup, it is used if BITS_PER_LONG is 64.

camellia6:
        unifies encrypt/decrypt routines for different key lengths.
        This reduces module size by ~25%, with tiny (less than 1%)
        speed impact.
        Also collapses encrypt/decrypt into more readable
        (visually shorter) form using macros.

camellia7:
        Move "key XOR is end of F-function" code part into
        camellia_setup_tail(), it is sufficiently similar
        between camellia_setup128 and camellia_setup256.

camellia8:
        Analogously to camellia7 patch, move
        "absorb kw2 to other subkeys" and "absorb kw4 to other subkeys"
        code parts into camellia_setup_tail(). This further reduces
        source and object code size at the cost of two brances
        in key setup code.

Code sizes:
64-bit:
dec      hex   filename
22786    5902  2.6.23.1.camellia4.t64/crypto/camellia.o
21422    53ae  2.6.23.1.camellia5.t64/crypto/camellia.o
16355    3fe3  2.6.23.1.camellia6.t64/crypto/camellia.o
15813    3dc5  2.6.23.1.camellia7.t64/crypto/camellia.o
15670    3d36  2.6.23.1.camellia8.t64/crypto/camellia.o

32-bit:
29948    74fc  2.6.23.1.camellia4.t/crypto/camellia.o
29457    7311  2.6.23.1.camellia5.t/crypto/camellia.o
21414    53a6  2.6.23.1.camellia6.t/crypto/camellia.o
20518    5026  2.6.23.1.camellia7.t/crypto/camellia.o
18454    4816  2.6.23.1.camellia8.t/crypto/camellia.oamellia.o

These patches apply cleanly to current cryptodev-2.6.
They should be applied in order.
Compile and run tested.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
