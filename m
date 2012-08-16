From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: twofish-avx - tune assembler code for ~10%
 more performance
Date: Thu, 16 Aug 2012 22:40:34 +0800
Message-ID: <20120816144034.GA30420@gondor.apana.org.au>
References: <20120730113620.23527.64087.stgit@localhost6.localdomain6>
 <20120816173049.142814pli51b0qas@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:33861 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957Ab2HPOlB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2012 10:41:01 -0400
Content-Disposition: inline
In-Reply-To: <20120816173049.142814pli51b0qas@www.81.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 16, 2012 at 05:30:49PM +0300, Jussi Kivilinna wrote:
> Please, ignore this patchset as it causes performance regression on
> Bulldozer. I'll make new patchset with this issue fixed.

OK.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
