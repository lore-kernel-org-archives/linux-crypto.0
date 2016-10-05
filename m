From: Matthijs van Duin <matthijsvanduin@gmail.com>
Subject: Re: [PATCH v3 0/8] Add support for SafeXcel IP-76 to OMAP RNG
Date: Wed, 5 Oct 2016 22:37:23 +0200
Message-ID: <CAALWOA-YpczKPVOtMErSj3YBW5yYTVjG+xN+T2GpsED7UDhTYQ@mail.gmail.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
 <57DBEB1A.4050602@free-electrons.com> <57E8F1F1.6040906@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32990 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753455AbcJEUhp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Oct 2016 16:37:45 -0400
In-Reply-To: <57E8F1F1.6040906@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>> The driver omap-rng has a lot of similarity with the IP block SafeXcel
>>> IP-76. A lot of registers are the same and the way that the driver works
>>> is very closed the description of the TRNG EIP76 in its datasheet.

Specifically the omap rng, at least the version I've examined, is a
SafeXcel EIP-75a core with a TI wrapper according to my notes. I don't
remember anymore where I obtained the "a", but the peripheral does
identify itself as EIP-75 v2.0.0 in the register at offset 0x7c.

Matthijs
