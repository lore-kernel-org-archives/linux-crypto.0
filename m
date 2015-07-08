From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: omap-aes: Add support for GCM mode
Date: Wed, 8 Jul 2015 15:11:49 +0800
Message-ID: <20150708071149.GA18702@gondor.apana.org.au>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 07, 2015 at 09:01:42PM +0530, Lokesh Vutla wrote:
> This series does some basic cleanup and adds support for
> AES GCM mode for omap aes driver.
> 
> Changes since v1:
> - Switched GCM to new AEAD interface

Patches 1-4 and 7 applied.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
