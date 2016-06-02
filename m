From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 04/10] crypto: add quick decompression api
Date: Thu, 2 Jun 2016 17:15:22 +0800
Message-ID: <20160602091522.GA16160@gondor.apana.org.au>
References: <1464702936-27627-1-git-send-email-giovanni.cabiddu@intel.com>
 <1464702936-27627-5-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33361 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbcFBJPZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:15:25 -0400
Content-Disposition: inline
In-Reply-To: <1464702936-27627-5-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 02:55:30PM +0100, Giovanni Cabiddu wrote:
> This patch introduces qdecomp, an asynchronous decompression api.
> qdecomp is a front-end for acomp and scomp algorithms which do not
> not need additional vmalloc work space for decompression.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

I'm sorry to have to make you go through this again but we no
longer have a user for this (I believe they have switched over to
using a per-cpu buffer) so you can now get rid of any code that's
associated with qdecomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
