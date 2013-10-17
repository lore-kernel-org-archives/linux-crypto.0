From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] [CRYPTO] kconfig: Corrected a typo
Date: Fri, 18 Oct 2013 00:03:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1310180002350.12405@pobox.suse.cz>
References: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Siddharth Goel <siddharth98391@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762289Ab3JQWDI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Oct 2013 18:03:08 -0400
In-Reply-To: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 17 Oct 2013, Siddharth Goel wrote:

> Corrected a typo in option description in Kconfig
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=60848
> 
> Signed-off-by: Siddharth Goel <siddharth98391@gmail.com>
> ---
>  crypto/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 69ce573..84698cf 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1084,7 +1084,7 @@ config CRYPTO_SERPENT
>  
>  	  Keys are allowed to be from 0 to 256 bits in length, in steps
>  	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
> -	  variant of Serpent for compatibility with old kerneli.org code.
> +	  variant of Serpent for compatibility with old kernel.org code.

Automatic conversion of kerneli -> kernel is not correct, it's not a typo. 
Please google for "kerneli" in LKML archives.

-- 
Jiri Kosina
SUSE Labs
