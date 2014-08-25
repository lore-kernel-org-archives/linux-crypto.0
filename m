From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr.c: remove unused function argument
Date: Mon, 25 Aug 2014 20:41:21 +0800
Message-ID: <20140825124121.GD28815@gondor.apana.org.au>
References: <1407490204-1438-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60046 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbaHYMlY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 08:41:24 -0400
Content-Disposition: inline
In-Reply-To: <1407490204-1438-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 08, 2014 at 12:30:04PM +0300, Cristian Stoica wrote:
> The argument "req" of do_one_async_hash_op is not used by the
> function. This patch removes this argument and renames the
> function to match more closely its purpose.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
