From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb
Date: Thu, 23 Jun 2016 18:45:16 +0800
Message-ID: <20160623104516.GD10350@gondor.apana.org.au>
References: <1466558506-3189-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51428 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbcFWKpV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 06:45:21 -0400
Content-Disposition: inline
In-Reply-To: <1466558506-3189-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 21, 2016 at 06:21:46PM -0700, Megha Dey wrote:
> From: Megha Dey <megha.dey@linux.intel.com>
> 
> Herbert wants the sha1-mb algorithm to have an async implementation:
> https://lkml.org/lkml/2016/4/5/286.
> Currently, sha1-mb uses an async interface for the outer algorithm
> and a sync interface for the inner algorithm. This patch introduces
> a async interface for even the inner algorithm.
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
