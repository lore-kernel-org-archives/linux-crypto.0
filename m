From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Mon, 26 Nov 2007 14:54:38 +0300
Message-ID: <20071126115437.GB9020@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au> <20071122111711.GC2444@2ka.mipt.ru> <20071125123141.GA12170@gondor.apana.org.au> <20071125125834.GA12324@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35352 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbXKZLzE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 06:55:04 -0500
Content-Disposition: inline
In-Reply-To: <20071125125834.GA12324@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 25, 2007 at 08:58:34PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Sun, Nov 25, 2007 at 08:31:41PM +0800, Herbert Xu wrote:
> > 
> > OK, one night I suddenly had this idea that we can postpone the
> > uncommon collision case to process context.  Here's the patch.
> 
> Small improvement, set the may-sleep flag when postponed.  So
> now it can sleep where it couldn't before, ironic huh :)

Great! I believe eventually we will even get rid of the lock around it :)

-- 
	Evgeniy Polyakov
