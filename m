From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Fri, 2 Oct 2015 11:20:00 +0800
Message-ID: <20151002032000.GA32754@gondor.apana.org.au>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44916 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbbJBDUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 23:20:06 -0400
Content-Disposition: inline
In-Reply-To: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 01:28:45PM -0700, Tadeusz Struk wrote:
>
> Changes in v4:
> - add back src_len and dst_len

So why do you still use sg_len? The length of the SG list is
irrelevant now that you have src_len/dst_len.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
