From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Thu, 28 Jan 2016 12:19:42 +0900
Message-ID: <20160128031941.GA14467@js1304-P5Q-DELUXE>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au>
 <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
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
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:39895 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967625AbcA1Dur (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 22:50:47 -0500
Content-Disposition: inline
In-Reply-To: <20160127080926.GA31516@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, Herbert.

On Wed, Jan 27, 2016 at 04:09:26PM +0800, Herbert Xu wrote:
> On Wed, Jan 27, 2016 at 04:03:55PM +0800, Herbert Xu wrote:
> > On Wed, Jan 27, 2016 at 03:59:05PM +0800, Li, Weigang wrote:
> > >
> > > The acomp is also SG-based, while scomp only accepts flat buffer.
> > 
> > Right, but do we need a pointer-based scomp at all? IPComp would
> > certainly be better off with an SG-based interface.  Any other
> > users of compression are presumably dealing with large amounts
> > of data where an SG interface would make more sense.
> > 
> > A pointer interface makes sense for shash because you may be hashing
> > 16 bytes at a time.  Nobody sane is going to be compressing 16 bytes,
> > or are they?

Hmm... I'm not an expert on this area so below of my analysis would be
wrong.

Some of compression example in kernel do compression with PAGE_SIZE and
compressed size is naturally less than PAGE_SIZE. There are many cases
that compressed size is below than 100 bytes. To keep and handle data,
they somtimes use kmalloced buffer and I guess it isn't suitable for
SG-based interface. Is it okay to use SG-based interface
if kmalloced object covers two pages?

And, even, someone uses vmalloced buffer that's also not suitable for
SG-based interface. For large amount data case, vmalloced buffer is
more suitable and it needs pointer interface.

> Note that I'm fine with keeping an scomp interface underneath
> for those algorithms where the best way to handle SG input is
> to linearise things.  But I would prefer that this interface is
> not exposed to kernel users unless it is absolutely required.

I have tested asynchronous compression APIs in zram and I saw
regression. Atomic allocation and setting up SG lists are culprit
for this regression. Moreover, zram optimizes linearisation
to get the best performance so it has two Kconfig options. One of
them cannot be support in the general layer. Not supporting pointer
based APIs unavoidably causes regression to zram in this case.

And, S/W compression algorithms that exists in kernel
are pointer based so it's natural to support it first
in crypto compression. That will help existing users to change
their direct library call to crypto compression without any regression.
They may be happy to change it because they just could get more
algorithm support without any loss.

I think that supporting pointer-based interface has some merits
mentioned above. However, I'm not sure what's the benefit if we only
support SG-based interface and it's bigger than above.

Thanks.
