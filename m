From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] whirlpool: count rounds from 0
Date: Fri, 21 Oct 2011 14:38:54 +0200
Message-ID: <20111021123854.GD17486@gondor.apana.org.au>
References: <20110927052624.GA15691@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38325 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JUMi5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 08:38:57 -0400
Content-Disposition: inline
In-Reply-To: <20110927052624.GA15691@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 27, 2011 at 08:26:24AM +0300, Alexey Dobriyan wrote:
> rc[0] is unused because rounds are counted from 1.
> Save an u64!
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
