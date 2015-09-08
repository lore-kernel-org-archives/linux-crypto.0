From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: testmgr: test IV value after a cipher
 operation
Date: Tue, 8 Sep 2015 13:32:25 +0800
Message-ID: <20150908053225.GB6517@gondor.apana.org.au>
References: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
 <43689867.jVbFUkvrcd@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39690 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbbIHFcg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Sep 2015 01:32:36 -0400
Content-Disposition: inline
In-Reply-To: <43689867.jVbFUkvrcd@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 08, 2015 at 05:23:59AM +0200, Stephan Mueller wrote:
> Am Dienstag, 16. Juni 2015, 11:46:46 schrieb Boris Brezillon:
> 
> Hi Herbert,
> 
> >The crypto drivers are supposed to update the IV passed to the crypto
> >request before calling the completion callback.
> >Test for the IV value before considering the test as successful.
> 
> May I ask whether there is anything wrong with this patch?
> 
> I am asking because the keywrapping template I would like to release would 
> need the test manager to check the generated IV.

There is nothing wrong with the patch.  I just wanted to finish
the skcipher conversion before adding this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
