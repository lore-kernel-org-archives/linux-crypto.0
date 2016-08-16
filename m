From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix ctx pointer and digest copy in sha256-mb
Date: Tue, 16 Aug 2016 17:52:52 +0800
Message-ID: <20160816095252.GD27042@gondor.apana.org.au>
References: <1470997482-118327-1-git-send-email-xiaodong.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
	megha.dey@intel.com, linux-kernel@vger.kernel.org
To: Xiaodong Liu <xiaodong.liu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59533 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbcHPJxE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:53:04 -0400
Content-Disposition: inline
In-Reply-To: <1470997482-118327-1-git-send-email-xiaodong.liu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 12, 2016 at 06:24:42AM -0400, Xiaodong Liu wrote:
> 1. fix ctx pointer
> Use req_ctx which is the ctx for the next job that have
> been completed in the lanes instead of the first
> completed job rctx, whose completion could have been
> called and released.
> 2. fix digest copy
> Use XMM register to copy another 16 bytes sha256 digest
> instead of a regular register.
> 
> Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
