From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Fri, 29 Jan 2016 18:09:01 +0800
Message-ID: <20160129100901.GA17272@gondor.apana.org.au>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au>
 <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Li, Weigang" <weigang.li@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58254 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbcA2KJb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 05:09:31 -0500
Content-Disposition: inline
In-Reply-To: <20160128031941.GA14467@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 28, 2016 at 12:19:42PM +0900, Joonsoo Kim wrote:
>
> I have tested asynchronous compression APIs in zram and I saw
> regression. Atomic allocation and setting up SG lists are culprit
> for this regression. Moreover, zram optimizes linearisation

So which is it, atomic allocations or setting up SG lists? There
is nothing in acomp that requires you to do an atomic allocation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
