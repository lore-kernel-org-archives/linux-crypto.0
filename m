From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: print cra driver name in tcrypt tests output
Date: Thu, 3 Jul 2014 21:43:01 +0800
Message-ID: <20140703134300.GB14291@gondor.apana.org.au>
References: <1403762262-14417-1-git-send-email-luca.clementi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Luca Clementi <luca.clementi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47839 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbaGCNnF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 09:43:05 -0400
Content-Disposition: inline
In-Reply-To: <1403762262-14417-1-git-send-email-luca.clementi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 25, 2014 at 10:57:42PM -0700, Luca Clementi wrote:
> Print the driver name that is being tested. The driver name can be
> inferred parsing /proc/crypto but having it in the output is
> clearer
> 
> Signed-off-by: Luca Clementi <luca.clementi@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
