From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: bfin_crc: Fix possible NULL pointer dereference
Date: Sun, 10 Mar 2013 18:15:13 +0800
Message-ID: <20130310101512.GD10910@gondor.apana.org.au>
References: <1361744859-28310-1-git-send-email-s.syam@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:60647 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750Ab3CJKPO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 06:15:14 -0400
Content-Disposition: inline
In-Reply-To: <1361744859-28310-1-git-send-email-s.syam@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 25, 2013 at 03:57:39AM +0530, Syam Sidhardhan wrote:
> If we define dev_dbg(), then there is a possible NULL pointer
> dereference.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
