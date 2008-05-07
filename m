From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [HIFN 04/n]: Handle ablkcipher_walk errors
Date: Wed, 7 May 2008 16:44:18 +0400
Message-ID: <20080507124418.GB23422@2ka.mipt.ru>
References: <48219D24.1040702@trash.net> <48219E92.20802@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57729 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbYEGMob (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:44:31 -0400
Content-Disposition: inline
In-Reply-To: <48219E92.20802@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:20:34PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> commit 7e24c849df30a5d2b0bb89165b933ea2faa747bd
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Wed May 7 12:43:20 2008 +0200
> 
>     [HIFN]: Handle ablkcipher_walk errors
>     
>     ablkcipher_walk may return a negative error value, handle this properly
>     instead of treating it as a huge number of scatter-gather elements.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Ooops, ACK :)


-- 
	Evgeniy Polyakov
