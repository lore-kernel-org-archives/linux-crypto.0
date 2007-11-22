From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [0/11] Add IV generators and givcrypt
Date: Thu, 22 Nov 2007 14:57:07 +0300
Message-ID: <20071122115707.GE28024@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <20071122112558.GE2444@2ka.mipt.ru> <20071122113116.GD8781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59282 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbXKVL5b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:57:31 -0500
Content-Disposition: inline
In-Reply-To: <20071122113116.GD8781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 07:31:16PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Idea and implementation look very good, I have couple of comments on
> > patches and one generic comment here: you absolutely have to write at
> > least bits of documentation for this new interfaces, how they behave and
> > who and how should use it :)
> 
> Sorry, when my employer starts paying me to do that or hires
> someone to do that for me is when better docs will exist :)

Somehow you described that to others - just combine things together and
put to Documentation/crypto and that will be enough.

> Until that happens why don't you chip in and contribute some
> documentation the user?

It is only possible if I clearly understand the whole idea, but it is
not that simple like it looks from author's point of view :)

For example this patchset looks like possible first step in proper
chaining mechanism for hardware devices, but if this will be impemented
this way, then each hardware completion callback should be wrapped with
proper geniv methods (like those which copy iv back to req->info). Is
this right approach (for those users who care about correct returned
IV), or will it just use software implementation only?

-- 
	Evgeniy Polyakov
