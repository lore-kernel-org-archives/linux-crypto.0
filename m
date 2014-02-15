From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Sun, 16 Feb 2014 07:41:23 +0800
Message-ID: <20140215234122.GA3401@gondor.apana.org.au>
References: <1392405277.27116.72.camel@schen9-DESK>
 <20140215012314.GA28843@gondor.apana.org.au>
 <1392429666.27116.93.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38200 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBOXlf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Feb 2014 18:41:35 -0500
Content-Disposition: inline
In-Reply-To: <1392429666.27116.93.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 14, 2014 at 06:01:06PM -0800, Tim Chen wrote:
> 
> Module A selects CRYPTO_ALG_B in config, which causes the generic
> ALG_B to get built and a module dependency to the generic
> ALG_B to be established.  Then when module A loads,

No, if you select ALG_B then yes it'll get built but it certainly
won't establish a module dependency on ALG_B.  Only a softdep could
create such a dependency.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
