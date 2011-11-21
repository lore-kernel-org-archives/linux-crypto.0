From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: mv_cesa - fix hashing of chunks > 1920 bytes
Date: Mon, 21 Nov 2011 16:23:32 +0800
Message-ID: <20111121082332.GB23208@gondor.apana.org.au>
References: <20111114155713.GA25105@kroah.com> <1321464481-22679-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@kernel.org,
	#3.1.x@gondor.apana.org.au
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37183 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1KUIXh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Nov 2011 03:23:37 -0500
Content-Disposition: inline
In-Reply-To: <1321464481-22679-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2011 at 06:28:01PM +0100, Phil Sutter wrote:
> This was broken by commit 7759995c75ae0cbd4c861582908449f6b6208e7a (yes,
> myself). The basic problem here is since the digest state is only saved
> after the last chunk, the state array is only valid when handling the
> first chunk of the next buffer. Broken since linux-3.0.
> 
> Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
> Cc: <stable@kernel.org> # 3.1.x

Patch applied.  Thanks Phil.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
