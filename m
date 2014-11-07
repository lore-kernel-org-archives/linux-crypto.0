From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for
 userspace
Date: Fri, 7 Nov 2014 13:31:05 +0800
Message-ID: <20141107053105.GA17825@gondor.apana.org.au>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
 <20141106195953.13328.77022.stgit@tstruk-mobl1>
 <20141107025607.GA9474@gondor.apana.org.au>
 <545C3FDB.4010106@intel.com>
 <20141107040531.GA9865@gondor.apana.org.au>
 <545C5786.4030205@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36446 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKGFbJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2014 00:31:09 -0500
Content-Disposition: inline
In-Reply-To: <545C5786.4030205@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 06, 2014 at 09:24:22PM -0800, Tadeusz Struk wrote:
>
> What about aead? Using my algif_qat I can build a single request to HW
> that preforms both encryption and authentication in one go, ever for
> things like aes-cbc-hmac-sha1. This allows me to get great performance
> of authenticated encryption from user space.

aead is simpler as it's already part of the API so we just need to
add algif_aead.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
