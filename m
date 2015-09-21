From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: crc32c-pclmul: use .rodata instead of .rotata
Date: Mon, 21 Sep 2015 23:10:01 +0800
Message-ID: <20150921151000.GB2836@gondor.apana.org.au>
References: <1442760156-2501-1-git-send-email-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442760156-2501-1-git-send-email-nicolas.iooss_linux@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 20, 2015 at 04:42:36PM +0200, Nicolas Iooss wrote:
> Module crc32c-intel uses a special read-only data section named .rotata.
> This section is defined for K_table, and its name seems to be a spelling
> mistake for .rodata.
> 
> Fixes: 473946e674eb ("crypto: crc32c-pclmul - Shrink K_table to 32-bit words")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
