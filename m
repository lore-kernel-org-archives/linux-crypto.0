From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/9] crypto: shrink hash down to two types
Date: Tue, 7 Jun 2016 18:52:53 +0800
Message-ID: <20160607105253.GD520@gondor.apana.org.au>
References: <1464870543-5988-1-git-send-email-giovanni.cabiddu@intel.com>
 <1464870543-5988-2-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55506 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbcFGKw6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:52:58 -0400
Content-Disposition: inline
In-Reply-To: <1464870543-5988-2-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 01:28:55PM +0100, Giovanni Cabiddu wrote:
> Move hash to 0xe to free up the space for acomp/scomp
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
