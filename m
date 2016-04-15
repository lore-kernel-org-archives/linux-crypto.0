From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha1-mb - use corrcet pointer while completing
 jobs
Date: Fri, 15 Apr 2016 22:34:41 +0800
Message-ID: <20160415143441.GF733@gondor.apana.org.au>
References: <1460454351-43534-1-git-send-email-xiaodong.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	megha.dey@linux.intel.com
To: Xiaodong Liu <xiaodong.liu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34601 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbcDOOeo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 10:34:44 -0400
Content-Disposition: inline
In-Reply-To: <1460454351-43534-1-git-send-email-xiaodong.liu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 12, 2016 at 09:45:51AM +0000, Xiaodong Liu wrote:
> In sha_complete_job, incorrect mcryptd_hash_request_ctx pointer is used
> when check and complete other jobs. If the memory of first completed req
> is freed, while still completing other jobs in the func, kernel will
> crash since NULL pointer is assigned to RIP.
> 
> Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
