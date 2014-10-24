From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev PATCH] qat: fix bad unlock balance
Date: Fri, 24 Oct 2014 22:54:50 +0800
Message-ID: <20141024145449.GC21055@gondor.apana.org.au>
References: <20141015183315.23860.89921.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	davem@davemloft.net, qat-linux@intel.com
To: Bruce Allan <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36465 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaJXOyw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:54:52 -0400
Content-Disposition: inline
In-Reply-To: <20141015183315.23860.89921.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 15, 2014 at 11:33:15AM -0700, Bruce Allan wrote:
> The mutex table_lock is unlocked in two functions without first being locked.
> Fix the functions to properly protect the accel_table with the table_lock.
> 
> Also, fix a spelling error in one of the function's header comment.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
