From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/aes.c remove operator ? and variable t in bf_setkey
Date: Wed, 25 Jul 2007 14:51:32 +0800
Message-ID: <20070725065132.GA20677@gondor.apana.org.au>
References: <1184547154.23516.12.camel@localhost> <20070716032831.GA25617@gondor.apana.org.au> <1184591714.8255.16.camel@localhost> <20070717123505.GB7211@gondor.apana.org.au> <1184795705.11987.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Frederik Sdun <fs_1600@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4037 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752776AbXGYGvu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jul 2007 02:51:50 -0400
Content-Disposition: inline
In-Reply-To: <1184795705.11987.11.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2007 at 11:55:05PM +0200, Frederik Sdun wrote:
> 
> Removed the temporary variable t which is not needed working copy of p.
> Operator ? removed out of loop by false case. 

Sorry, the tabs are still coming across as spaces.
 
Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
