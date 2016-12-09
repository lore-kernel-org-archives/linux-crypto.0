From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: scatterwalk_map_and_copy incorrect optimization
Date: Fri, 9 Dec 2016 14:26:30 +0100
Message-ID: <CAHmME9rq9NjawkZw6wQpWsrY58ZgyRutBKT5UL7RA+8Pv2GOew@mail.gmail.com>
References: <CAHmME9p24bkNPD2CfGMUOHxgOX+OuFO_rVqfhOQdDexwW53ExA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:42334 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753436AbcLIN0f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 08:26:35 -0500
In-Reply-To: <CAHmME9p24bkNPD2CfGMUOHxgOX+OuFO_rVqfhOQdDexwW53ExA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hah, looks like I missed [1] by a couple weeks. Looks like it's been
settled then.

Is this a stable@ candidate?


[1] https://git.zx2c4.com/linux/commit/?id=c8467f7a3620698bf3c22f0e199b550fb611a8ae
