From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Mon, 1 Feb 2016 11:11:42 +0900
Message-ID: <20160201021141.GA32125@js1304-P5Q-DELUXE>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au>
 <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
 <20160129100901.GA17272@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Li, Weigang" <weigang.li@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:46407 "EHLO
	lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbcBACLY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Jan 2016 21:11:24 -0500
Content-Disposition: inline
In-Reply-To: <20160129100901.GA17272@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2016 at 06:09:01PM +0800, Herbert Xu wrote:
> On Thu, Jan 28, 2016 at 12:19:42PM +0900, Joonsoo Kim wrote:
> >
> > I have tested asynchronous compression APIs in zram and I saw
> > regression. Atomic allocation and setting up SG lists are culprit
> > for this regression. Moreover, zram optimizes linearisation
> 
> So which is it, atomic allocations or setting up SG lists? There
> is nothing in acomp that requires you to do an atomic allocation.

Atomic allocation are called for linearisation when needed. Zram's
compressed content is usually stored in two physically separate pages
so linearisation is needed. See scomp_map().

Setting up SG lists means that to use acomp, sg_init_table(),
sg_set_page() are need to be called by zram unlike the case just
passing the pointer based buffer.

Thanks.
