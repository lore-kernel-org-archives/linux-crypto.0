From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/5] camellia: code shrink and 64-bit optimization
Date: Thu, 22 Nov 2007 14:41:44 -0800
Message-ID: <200711221441.45027.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Denys Vlasenko <vda.linux@googlemail.com>,
	herbert@gondor.apana.org.au,
	Noriaki TAKAMIYA <takamiya@linux-ipv6.org>,
	davem@davemloft.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:43607 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXKVWlz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 17:41:55 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2480486rvb
        for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 14:41:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patches start from 5 because pathches 1..4 are already
in cryptodev-2.6.

camellia5:
        Remove unused macro params.
        Use (u8)(expr) instead of (expr) & 0xff,
        helps gcc to realize how to use simpler commands.
        Move CAMELLIA_FLS macro closer to encrypt/decrypt routines.

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

camellia9:
        Adds 64-bit key setup, it is used if BITS_PER_LONG is 64.
        30% faster key setup and 1k (7%) smaller module on amd64.

Code sizes:
64-bit:
dec      hex   filename
22786    5902  2.6.23.1.camellia4.t64/crypto/camellia.o
15670    3d36  2.6.23.1.camellia9.t64/crypto/camellia.o

32-bit:
29948    74fc  2.6.23.1.camellia4.t/crypto/camellia.o
18454    4816  2.6.23.1.camellia9.t/crypto/camellia.o

These patches apply cleanly to current cryptodev-2.6.
They should be applied in order.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
