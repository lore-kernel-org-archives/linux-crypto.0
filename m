From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: make lib/842 decompress functions static
Date: Wed, 13 May 2015 11:19:57 +0800
Message-ID: <20150513031957.GB24980@gondor.apana.org.au>
References: <1431343355-32005-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52094 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbbEMDUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 23:20:06 -0400
Content-Disposition: inline
In-Reply-To: <1431343355-32005-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 07:22:35AM -0400, Dan Streetman wrote:
> Make the do_index and do_op functions static.
> 
> They are used only internally by the 842 decompression function,
> and should be static.
> 
> Reported-By: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
