From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: IV copy strategy
Date: Tue, 20 Nov 2007 17:23:42 +0300
Message-ID: <20071120142342.GA30073@2ka.mipt.ru>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru> <20071118065237.GA26456@gondor.apana.org.au> <20071119103840.GC2048@2ka.mipt.ru> <20071119115655.GA5033@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53329 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXKTOYa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2007 09:24:30 -0500
Content-Disposition: inline
In-Reply-To: <20071119115655.GA5033@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 19, 2007 at 07:56:55PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > I'm not sure what user will do, when it request chaining, but driver
> > will set CRYPTO_ALG_CIPHER_NOCHAIN itself and return wrong/old in
> > req->info?
> > For IPsec it is not an issue though, but I can not say that for all.
> 
> Drivers that set CRYPTO_ALG_CIPHER_NOCHAIN won't be returned
> if the user requests for a chaining cipher.  This is the same
> as when you request for a cipher with no fallback that the
> system won't return one needing a fallback.
> 
> If you're worried about users doing chaining we could even
> create a new frontend type for it.  So the user would need
> to allocate an object of type crypto_chncipher and use that
> for operations that chain.

Well, this looks like a good way forward.
Not even getting into account, that it requires essentially zero
efforts from driver writers :)

-- 
	Evgeniy Polyakov
