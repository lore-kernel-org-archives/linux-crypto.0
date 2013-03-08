From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix typo "CRYPTO_AHASH"
Date: Thu, 7 Mar 2013 18:51:27 -0600
Message-ID: <20130307185127.a525f832276be2b30153aedf@freescale.com>
References: <1362490396.16460.87.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:1798 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077Ab3CHAyv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Mar 2013 19:54:51 -0500
In-Reply-To: <1362490396.16460.87.camel@x61.thuisdomein>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 5 Mar 2013 14:33:16 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> The Kconfig entry for CAAM's hash algorithm implementations has always
> selected CRYPTO_AHASH. But there's no corresponding Kconfig symbol.
> 
> It seems it was intended to select CRYPTO_HASH, like other crypto
> drivers do. That would apparently (indirectly) select CRYPTO_HASH2,
> which would enable the ahash functionality this driver uses.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim
