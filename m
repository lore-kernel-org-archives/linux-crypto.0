From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Thu, 4 Feb 2016 22:56:12 +0800
Message-ID: <20160204145612.GB7202@gondor.apana.org.au>
References: <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
 <20160129100901.GA17272@gondor.apana.org.au>
 <20160201021141.GA32125@js1304-P5Q-DELUXE>
 <56B2C4A7.6060106@intel.com>
 <20160204032850.GA2060@gondor.apana.org.au>
 <20160204032945.GA2100@gondor.apana.org.au>
 <56B2CA96.4010104@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Li, Weigang" <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52428 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859AbcBDO4o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Feb 2016 09:56:44 -0500
Content-Disposition: inline
In-Reply-To: <56B2CA96.4010104@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 04, 2016 at 11:50:46AM +0800, Li, Weigang wrote:
>
> Seems I need go back to my first acomp patch.. Assuming we shall
> still keep the comp i/f, and the linearisation of sg-list in acomp
> to fit the "comp" API? What do you mean by the driver-side scomp?

What I mean is that the bottom half of the scomp patches can still
be used.  We just want to hide it away from the users so won't
provide the direct entry points such as crypto_alloc_scomp, etc..

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
