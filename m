From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: picoxcell - Cleanups removing non-DT code
Date: Fri, 13 Jan 2017 00:39:43 +0800
Message-ID: <20170112163943.GC20085@gondor.apana.org.au>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 02, 2017 at 02:06:56PM -0300, Javier Martinez Canillas wrote:
> Hello,
> 
> This small series contains a couple of cleanups that removes some driver's code
> that isn't needed due the driver being for a DT-only platform.
> 
> The changes were suggested by Arnd Bergmann as a response to a previous patch:
> https://lkml.org/lkml/2017/1/2/342
> 
> Patch #1 allows the driver to be built when the COMPILE_TEST option is enabled.
> Patch #2 removes the platform ID table since isn't needed for DT-only drivers.
> Patch #3 removes a wrapper function that's also not needed if driver is DT-only.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
