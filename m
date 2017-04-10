From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] arm64: marvell: add cryptographic engine support for
 7k/8k
Date: Mon, 10 Apr 2017 17:39:03 +0800
Message-ID: <20170410093903.GA8035@gondor.apana.org.au>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51798 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdDJJjo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 05:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 29, 2017 at 02:44:25PM +0200, Antoine Tenart wrote:
> Hi all,
> 
> This series adds support for the Inside Secure SafeXcel EIP197
> cryptographic engine which can be found on Marvell Armada 7k and 8k
> boards. A new cryptographic engine driver is added, as well as the
> relevant device tree definition for the Armada 7040 DB and 8040 DB
> boards.
> 
> This driver needs two firmwares to work correctly. These firmware are
> usually used for more advanced operations than the ones supported (as of
> now), but we still need them to pass the data to the internal
> cryptographic engine.
> 
> This series was tested in various ways on both the Armada 7040 DB and
> the Armada 8040 DB: using the crypto framework self tests, using tcrypt
> and while performing various transfers with iperf on top of IPsec.
> 
> This series is based on top of v4.11-rc1, and is available on a branch
> (which also contains the PPv2 support for 7k/8k, to ease the process of
> testing IPsec): https://github.com/atenart/linux  v4.11-rc1/7k8k-crypto
> I can rebase if needed.
> 
> Thanks,
> Antoine
> 
> 
> Antoine Tenart (7):
>   Documentation/bindings: Document the SafeXel cryptographic engine
>     driver
>   crypto: inside-secure: add SafeXcel EIP197 crypto engine driver
>   MAINTAINERS: add a maintainer for the Inside Secure crypto driver
>   arm64: marvell: dts: add crypto engine description for 7k/8k
>   arm64: marvell: dts: enable the crypto engine on the Armada 7040 DB
>   arm64: marvell: dts: enable the crypto engine on the Armada 8040 DB
>   arm64: defconfig: enable the Safexcel crypto engine as a module

I have no problems with the crypto bits.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
