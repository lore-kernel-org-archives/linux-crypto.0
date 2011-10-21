From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: twofish: add 3-way parallel x86_64
	assembler implemention
Date: Fri, 21 Oct 2011 14:37:52 +0200
Message-ID: <20111021123752.GB17486@gondor.apana.org.au>
References: <20110926134715.21453.18179.stgit@localhost6.localdomain6> <20110926134725.21453.68210.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47776 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1JUMhy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 08:37:54 -0400
Content-Disposition: inline
In-Reply-To: <20110926134725.21453.68210.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 26, 2011 at 04:47:25PM +0300, Jussi Kivilinna wrote:
> Patch adds 3-way parallel x86_64 assembly implementation of twofish as new
> module. New assembler functions crypt data in three blocks chunks, improving
> cipher performance on out-of-order CPUs.

All three patches applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
