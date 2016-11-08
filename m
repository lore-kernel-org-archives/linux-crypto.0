From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH v4] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Tue, 08 Nov 2016 08:52:39 +0100
Message-ID: <1478591559.5216.7.camel@strongswan.org>
References: <20161107191253.17998-1-Jason@zx2c4.com>
         <20161107194709.20457-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:58063 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbcKHIBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 03:01:36 -0500
In-Reply-To: <20161107194709.20457-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> By using the unaligned access helpers, we drastically improve
> performance on small MIPS routers that have to go through the
> exception fix-up handler for these unaligned accesses.

I couldn't measure any slowdown here, so:

Acked-by: Martin Willi <martin@strongswan.org>

> -       dctx->s[0] = le32_to_cpuvp(key +  0);
> +       dctx->s[0] = get_unaligned_le32(key +  0);

Not sure what the exact alignment rules for key/iv are, but maybe we
want to replace the same function in chacha20_generic.c as well?

Martin
