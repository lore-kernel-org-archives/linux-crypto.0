From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Reduced reqsize in qat_algs
Date: Mon, 25 Jan 2016 22:49:15 +0800
Message-ID: <20160125144915.GJ8840@gondor.apana.org.au>
References: <1453224844-426-1-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48084 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbcAYOtR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:49:17 -0500
Content-Disposition: inline
In-Reply-To: <1453224844-426-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 19, 2016 at 05:34:04PM +0000, Giovanni Cabiddu wrote:
> From: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>
> 
> req_alloc functions already take into account the request data structure
> when allocating memory.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
