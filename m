From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: avoid module request when lookup crypto larval
 of template
Date: Mon, 10 Mar 2014 19:57:21 +0800
Message-ID: <20140310115721.GA9657@gondor.apana.org.au>
References: <1394443371-12181-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33593 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaCJL5j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 07:57:39 -0400
Content-Disposition: inline
In-Reply-To: <1394443371-12181-1-git-send-email-jlee@suse.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 10, 2014 at 05:22:51PM +0800, Lee, Chun-Yi wrote:
> When allocate crypto algorithms, e.g. crypto_alloc_shash(), using
> template model will run into the path that call module_request().
> But there have no any module alias that match with the template name.

There aren't any but there could be.  For example, as it is
all direct implementations of cbc(aes) rely on the fact that
they also happen to provide aes to autoload themselves.

We may well have a case where it makes sense for a module to
provide just cbc(aes) for example, in which case it would need
such an alias for it to be loaded automatically.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
