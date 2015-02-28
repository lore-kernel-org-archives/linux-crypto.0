From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: mxs-dcp - fix type of ret for wait_for_completion_timeout
Date: Sat, 28 Feb 2015 23:33:17 +1300
Message-ID: <20150228103317.GB7591@gondor.apana.org.au>
References: <1423296581-10563-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39980 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbB1Kd0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 05:33:26 -0500
Content-Disposition: inline
In-Reply-To: <1423296581-10563-1-git-send-email-hofrat@osadl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 07, 2015 at 03:09:41AM -0500, Nicholas Mc Guire wrote:
> return type of wait_for_completion_timeout is unsigned long not int, this
> patch changes the type of ret from int to unsigned long.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

All four patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
