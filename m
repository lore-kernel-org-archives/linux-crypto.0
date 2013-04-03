From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 0/2] add devicetree support for timeriomem_rng
Date: Wed, 3 Apr 2013 09:55:07 +0800
Message-ID: <20130403015507.GG20205@gondor.apana.org.au>
References: <1364747691-19874-1-git-send-email-alex@digriz.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>
To: Alexander Clouter <alex@digriz.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39272 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759242Ab3DCB5r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Apr 2013 21:57:47 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by fornost.hengli.com.au with esmtp (Exim 4.72 #1 (Debian))
	id 1UNCxN-0004vG-PR
	for <linux-crypto@vger.kernel.org>; Wed, 03 Apr 2013 12:57:45 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.72)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1UNCxN-0005K9-JE
	for linux-crypto@vger.kernel.org; Wed, 03 Apr 2013 09:57:45 +0800
Content-Disposition: inline
In-Reply-To: <1364747691-19874-1-git-send-email-alex@digriz.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 31, 2013 at 05:34:49PM +0100, Alexander Clouter wrote:
> This patchset cleans up, readies, and adds devicetree support to the
> timeriomem_rng driver.
> 
> Changelog:
>  v2 - fix probe() to release mem region in-case of error
> 
> Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
> 
> Alexander Clouter (2):
>   hw_random: timeriomem_rng: update to support more than one device
>   hw_random: timeriomem_rng: added devicetree hooks

Patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
