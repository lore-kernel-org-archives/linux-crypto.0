From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] mv_cesa: no need to write to that FPGA_INT_STATUS
 field
Date: Tue, 12 Jun 2012 18:03:55 +0800
Message-ID: <20120612100355.GC14078@gondor.apana.org.au>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
 <1337954089-12702-2-git-send-email-phil.sutter@viprinet.com>
 <4FC2DBC8.2070805@gmail.com>
 <20120529114529.GB5711@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "cloudy.linux" <cloudy.linux@gmail.com>,
	linux-crypto@vger.kernel.org
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58604 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751092Ab2FLKEA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 06:04:00 -0400
Content-Disposition: inline
In-Reply-To: <20120529114529.GB5711@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 29, 2012 at 01:45:29PM +0200, Phil Sutter wrote:
> 
> Oh, that explains why it's not needed on Kirkwood but still left there.
> I could make it compile-time optional, depending on ARCH_ORION5X e.g. or
> simply drop the patch and leave it alone since it really doesn't hurt
> that much. 

OK I've skipped number two and applied the other three.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
