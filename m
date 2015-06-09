From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Set max request size
Date: Tue, 9 Jun 2015 22:34:41 +0800
Message-ID: <20150609143441.GA14442@gondor.apana.org.au>
References: <20150605225118.4911.47264.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tianliang.wang@intel.com, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32849 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbFIOes (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20150605225118.4911.47264.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2015 at 03:51:18PM -0700, Tadeusz Struk wrote:
> The device doensn't support the default value and will change it to 256, which
> will cause performace degradation for biger packets.
> Add an explicit write to set it to 1024.
> 
> Reported-by: Tianliang Wang <tianliang.wang@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
