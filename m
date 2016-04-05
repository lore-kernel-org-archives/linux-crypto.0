From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: n2 - Remove return statement from void function
Date: Tue, 5 Apr 2016 20:46:05 +0800
Message-ID: <20160405124605.GE13048@gondor.apana.org.au>
References: <20160318133848.GA25643@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35417 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbcDEMqL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:46:11 -0400
Content-Disposition: inline
In-Reply-To: <20160318133848.GA25643@amitoj-Inspiron-3542>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 18, 2016 at 07:08:48PM +0530, Amitoj Kaur Chawla wrote:
> Return statement at the end of a void function is useless.
> 
> The Coccinelle semantic patch used to make this change is as follows:
> //<smpl>
> @@
> identifier f;
> expression e;
> @@
> void f(...) {
> <...
> - return
>   e;
> ...>
> }
> //</smpl>
> 
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
