From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: caam - authenc fixes
Date: Tue, 9 Aug 2016 00:06:46 +0800
Message-ID: <20160808160646.GB32116@gondor.apana.org.au>
References: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38743 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbcHHQGu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 12:06:50 -0400
Content-Disposition: inline
In-Reply-To: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 04, 2016 at 08:02:45PM +0300, Horia Geantă wrote:
> The first patch fixes a few typos in the encrypt shared descriptor
> used by echainiv(authenc) algorithms.
> 
> Second patch fixes the case when .setkey is called before .setauthsize,
> avoiding creating authenc descriptors with zero authsize.
> 
> Both patches are also being sent to -stable for v4.3+ kernels.

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
