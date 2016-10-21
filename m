From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: CCP - change type of struct member lsb to signed
Date: Fri, 21 Oct 2016 11:16:34 +0800
Message-ID: <20161021031634.GK22979@gondor.apana.org.au>
References: <20161012134703.15296.24795.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44299 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcJUDQi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:16:38 -0400
Content-Disposition: inline
In-Reply-To: <20161012134703.15296.24795.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 12, 2016 at 08:47:03AM -0500, Gary R Hook wrote:
> The lsb field uses a value of -1 to indicate that it
> is unassigned. Therefore type must be a signed int.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
