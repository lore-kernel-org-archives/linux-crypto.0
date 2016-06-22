From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 22:02:25 +0800
Message-ID: <20160622140225.GA315@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51555 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcFVOCe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:02:34 -0400
Content-Disposition: inline
In-Reply-To: <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 03:20:51PM +0200, Andrzej Zaborowski wrote:
>
> We use pkcs1pad with AF_ALG to implement lightweight TLS.  TLS
> versions < 1.2 use a non-standard hash so we'd have to move the PKCS#1
> padding back to userspace if this is changed.

When this is submitted for upstream inclusion we can add support
for it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
