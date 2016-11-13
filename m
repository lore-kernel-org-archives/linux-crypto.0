From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dh - Consistenly return negative error codes
Date: Sun, 13 Nov 2016 19:29:43 +0800
Message-ID: <20161113112943.GE7399@gondor.apana.org.au>
References: <20161108234822.29320-1-mathew.j.martineau@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, salvatore.benedetto@intel.com
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44643 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935117AbcKMLaE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:30:04 -0500
Content-Disposition: inline
In-Reply-To: <20161108234822.29320-1-mathew.j.martineau@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 08, 2016 at 03:48:22PM -0800, Mat Martineau wrote:
> Fix the single instance where a positive EINVAL was returned.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
