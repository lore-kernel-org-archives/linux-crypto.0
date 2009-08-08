From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] typo in crypto/rng.c
Date: Sat, 8 Aug 2009 07:22:08 -0400
Message-ID: <20090808112208.GA18518@localhost.localdomain>
References: <alpine.DEB.2.01.0908072346000.5831@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47662 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbZHHLWR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Aug 2009 07:22:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908072346000.5831@bogon.housecafe.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 07, 2009 at 11:49:20PM -0700, Christian Kujau wrote:
> 
> Correct a typo in crypto/rng.c
> 
> Signed-off-by: Christian Kujau <lists@nerdbynature.de>
> 
> --- linux-2.6-git/crypto/rng.c.orig	2009-08-08 08:43:49.227693375 +0200
> +++ linux-2.6-git/crypto/rng.c	2009-08-08 08:44:54.735426448 +0200
> @@ -123,4 +123,4 @@ void crypto_put_default_rng(void)
>  EXPORT_SYMBOL_GPL(crypto_put_default_rng);
>  
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Random Number Genertor");
> +MODULE_DESCRIPTION("Random Number Generator");
> 
> -- 
> BOFH excuse #229:
> 
> wrong polarity of neutron flow
> 

Thanks!

Acked-by: Neil Horman <nhorman@tuxdriver.com>

