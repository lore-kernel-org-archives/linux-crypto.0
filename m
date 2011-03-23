From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: caam - dereferencing ERR_PTR on allocation
	failure
Date: Wed, 23 Mar 2011 21:20:55 +0800
Message-ID: <20110323132055.GB4374@gondor.apana.org.au>
References: <20110315065747.GO2008@bicker> <20110315172034.3038b124.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59706 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWNVI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2011 09:21:08 -0400
Content-Disposition: inline
In-Reply-To: <20110315172034.3038b124.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2011 at 05:20:34PM -0500, Kim Phillips wrote:
> On Tue, 15 Mar 2011 09:57:47 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > t_alg is an ERR_PTR here so we can't dereference it.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
