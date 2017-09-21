From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - fix gcc-4.9 warnings
Date: Thu, 21 Sep 2017 16:07:05 +0800
Message-ID: <20170921080705.GF7718@gondor.apana.org.au>
References: <20170912101232.3688217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912101232.3688217-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 12, 2017 at 12:12:16PM +0200, Arnd Bergmann wrote:
> All older compiler versions up to gcc-4.9 produce these
> harmless warnings:
> 
> drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: missing braces around initializer [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: (near initialization for ‘result.completion’) [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: missing braces around initializer [-Wmissing-braces]
> drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: (near initialization for ‘result.completion’) [-Wmissing-braces]
> 
> This changes the syntax to something that works on all versions
> without warnings.
> 
> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
