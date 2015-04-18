From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ensure backlog is initialised
Date: Sat, 18 Apr 2015 19:00:01 +0800
Message-ID: <20150418110001.GA5590@gondor.apana.org.au>
References: <1429030289-4070-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48923 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbDRLAK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 07:00:10 -0400
Content-Disposition: inline
In-Reply-To: <1429030289-4070-1-git-send-email-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 14, 2015 at 11:51:29AM -0500, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> backlog is not initialised so in the case where
> cpg->eng_st != ENGINE_IDLE it is never initialised and
> hence which could lead to an illegal memory dereference
> in the statement:
> 
>   backlog->complete(backlog, -EINPROGRESS);
> 
> Discovered with cppcheck static analsys:
> [drivers/crypto/mv_cesa.c:616]:
>    (error) Uninitialized variable: backlog
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
