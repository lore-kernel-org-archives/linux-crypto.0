From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel panic when using ccm(aes) with the Atmel AES HW
 accelerator
Date: Tue, 24 Oct 2017 11:20:36 +0800
Message-ID: <20171024032036.GA28462@gondor.apana.org.au>
References: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
 <39a43561-e0e6-a3b7-e2c0-bd7e6bf1be47@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34780 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdJXDVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 23:21:06 -0400
Content-Disposition: inline
In-Reply-To: <39a43561-e0e6-a3b7-e2c0-bd7e6bf1be47@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 23, 2017 at 03:38:59PM +0300, Tudor Ambarus wrote:
>
> I will propose a fix, but I'm taking my time to better understand why
> CTR requires to overwrite the iv with the last ciphertext block.

That's an API requirement.  So we should fix ccm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
