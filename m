From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 00/12] crypto: inside-secure - hmac(sha256/sha224) support
Date: Thu, 15 Mar 2018 16:45:54 +0100
Message-ID: <20180315154554.GD2947@kwain>
References: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Thu, Mar 15, 2018 at 04:38:39PM +0100, Antoine Tenart wrote:
> 
> This series brings hmac(sha256) and hmac(sha224) support to the Inside
> Secure cryptographic engine driver.
> 
> The first 10 patches are fixes and reworks needed for the hmac(sha256)
> and hmac(224) support to land in. Then 2 patches adds the 2 new
> algorithms.

I made a small mistake as the first 3 patches of the series already
were merged into your tree, as they already were sent in a previous
series. You can just ignore them.

Sending a v2 is probably unnecessary but I can if needed.

Sorry for this,
Antoine

-- 
Antoine Ténart, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
