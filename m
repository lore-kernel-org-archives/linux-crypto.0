Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39016 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbeLWEDj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:03:39 -0500
Date: Sun, 23 Dec 2018 12:03:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Jampala Srikanth <Jampala.Srikanth@cavium.com>
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix build with !CONFIG_DEBUG_FS
Message-ID: <20181223040336.eqlgclmfdsyfb7pt@gondor.apana.org.au>
References: <20181216230030.26206-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181216230030.26206-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 16, 2018 at 03:00:30PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fixes: cf718eaa8f9b ("crypto: cavium/nitrox - Enabled Mailbox support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
