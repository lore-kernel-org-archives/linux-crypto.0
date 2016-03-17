From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - fix lock acquisition code
Date: Thu, 17 Mar 2016 19:12:46 +0800
Message-ID: <20160317111246.GA5658@gondor.apana.org.au>
References: <20160316140226.28262.97717.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36460 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338AbcCQLMx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Mar 2016 07:12:53 -0400
Content-Disposition: inline
In-Reply-To: <20160316140226.28262.97717.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 16, 2016 at 09:02:26AM -0500, Gary R Hook wrote:
> This patch simplifies an unneeded read-write lock.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
