From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix bar discovery for c62x
Date: Fri, 30 Dec 2016 20:19:19 +0800
Message-ID: <20161230121919.GD15832@gondor.apana.org.au>
References: <20161222150012.6040-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59737 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753820AbcL3MTZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:19:25 -0500
Content-Disposition: inline
In-Reply-To: <20161222150012.6040-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 22, 2016 at 03:00:12PM +0000, Giovanni Cabiddu wrote:
> Some accelerators of the c62x series have only two bars.
> This patch skips BAR0 if the accelerator does not have it.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
