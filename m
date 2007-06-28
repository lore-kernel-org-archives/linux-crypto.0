From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Thu, 28 Jun 2007 14:50:36 +0400
Message-ID: <20070628105034.GA3771@2ka.mipt.ru>
References: <20070626225952.GA4571@Chamillionaire.breakpoint.cc> <20070627102420.GA11016@2ka.mipt.ru> <20070627114159.GA6456@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49789 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbXF1KvG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jun 2007 06:51:06 -0400
Content-Disposition: inline
In-Reply-To: <20070627114159.GA6456@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2007 at 01:41:59PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> Yes I do. Those number are gathered from a PS3 and with a sync
> interface. sync means the SPU is idle, I queue the request, start the
> SPU, SPU requests the data, waits from completion, computes it,
> transfers it back and finally the SPU stops (idle again). Oh and only
> one SPU is used.
> The test is generated with a simple module that allocated four pages (16
> kb) and calls the SPU crypto code over and over again until approx 156
> MB of memory passed/processed. From the time and total size I get my
> kb/sec.
...
> [1] http://breakpoint.cc/spu_aes/spu_code.png
> [2] http://breakpoint.cc/spu_aes/spu_sync_blocksize.png

Mmm, looks really good. Did powerpc folks acked this changes?

-- 
	Evgeniy Polyakov
