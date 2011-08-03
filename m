From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - Make module loading even quieter
	when hardware is missing
Date: Wed, 3 Aug 2011 14:08:01 +0800
Message-ID: <20110803060801.GA32481@gondor.apana.org.au>
References: <201107281403.27224.ralfjung-e@gmx.de> <20110730061307.GA24394@gondor.apana.org.au> <20110730115011.GA2837@elie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 485070@bugs.debian.org, Ralf Jung <ralfjung-e@gmx.de>,
	linux-crypto@vger.kernel.org, katzj@redhat.com
To: Jonathan Nieder <jrnieder@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48466 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab1HCGIN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Aug 2011 02:08:13 -0400
Content-Disposition: inline
In-Reply-To: <20110730115011.GA2837@elie>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 30, 2011 at 01:50:12PM +0200, Jonathan Nieder wrote:
> When loading aes via the module alias, a padlock module failing to
> load due to missing hardware is not particularly notable.  With
> v2.6.27-rc1~1107^2~14 (crypto: padlock - Make module loading quieter
> when hardware isn't available, 2008-07-03), the padlock-aes module
> suppresses the relevant messages when the "quiet" flag is in use; but
> better to suppress this particular message completely, since the
> administrator can already distinguish such errors by the absence of a
> message indicating initialization failing or succeeding.
> 
> This avoids occasional messages in syslog of the form
> 
> 	padlock_aes: VIA PadLock not detected.
> 
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>


Patch applied.  Thanks Jonathan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
