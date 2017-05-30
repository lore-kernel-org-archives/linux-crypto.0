From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/2] crypto: ecdh - add privkey generation support
Date: Tue, 30 May 2017 17:23:13 +0200
Message-ID: <1782175.fxql8cH1xg@tauon.chronox.de>
References: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com> <10614195.cHMlZhE11R@tauon.chronox.de> <401a2c0d-b2f6-b31a-f7e5-7155d8846a7c@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, marcel@holtmann.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59866 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750733AbdE3PXP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 11:23:15 -0400
In-Reply-To: <401a2c0d-b2f6-b31a-f7e5-7155d8846a7c@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 30. Mai 2017, 17:18:41 CEST schrieb Tudor Ambarus:

Hi Tudor,

> You missed the return. When generating the key I just exit with the
> return value of ecc_gen_privkey().

Rrrright :-)

Reviewed-by: Stephan Müller <smueller@chronox.de>

Ciao
Stephan
