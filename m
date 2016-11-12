From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Sun, 13 Nov 2016 00:31:32 +0100
Message-ID: <CAHmME9q5NXj=C1CKah=ongbwJKErozWV2a46unH+k5v157B0_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:51901 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751506AbcKLXbj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Nov 2016 18:31:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello friendly test robot,

On Sun, Nov 13, 2016 at 12:27 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi Jason,
>
> [auto build test ERROR on cryptodev/master]

That error was fixed by v4 in this series. The version that should be
tested and ultimately applied is v4 and can be found here:

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1265977.html

Regards from a human,
Jason
