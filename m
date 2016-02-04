From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Thu, 4 Feb 2016 22:53:38 +0800
Message-ID: <20160204145338.GA7202@gondor.apana.org.au>
References: <20160127074140.GA30335@gondor.apana.org.au>
 <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
 <20160129100901.GA17272@gondor.apana.org.au>
 <20160201021141.GA32125@js1304-P5Q-DELUXE>
 <56B2C4A7.6060106@intel.com>
 <20160204032850.GA2060@gondor.apana.org.au>
 <CAAmzW4NcXR+n5qeQh4NP7tJ-thhun_OE89WpLVAUnJ28U6n=3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Li, Weigang" <weigang.li@intel.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36198 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965577AbcBDOyo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Feb 2016 09:54:44 -0500
Content-Disposition: inline
In-Reply-To: <CAAmzW4NcXR+n5qeQh4NP7tJ-thhun_OE89WpLVAUnJ28U6n=3Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 04, 2016 at 04:17:41PM +0900, Joonsoo Kim wrote:
>
> Do you think not to merge scomp? Please let me know your overall
> plan about this.?

I'm fine with a driver-side scomp interface.  But I'd rather
avoid having yet another user-side compression interface in the
form of scomp if we can avoid it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
