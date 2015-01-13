From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Fix for qat_aes_cbc_hmac_sha512
Date: Wed, 14 Jan 2015 09:47:56 +1100
Message-ID: <20150113224756.GA12432@gondor.apana.org.au>
References: <20150113202753.32216.26250.stgit@tstruk-mobl1>
 <20150113212515.GA11562@gondor.apana.org.au>
 <54B59A86.10803@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59816 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbAMWsD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 17:48:03 -0500
Content-Disposition: inline
In-Reply-To: <54B59A86.10803@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 13, 2015 at 02:21:58PM -0800, Tadeusz Struk wrote:
> 
> Yes, it looks strange, but the issue is we don't really zero the whole
> auth_state. Because struct qat_auth_state is no packed on my system
> 
> sizeof(MAX_AUTH_STATE_SIZE + 64) = 244
> 
> and sizeof(struct qat_auth_state) = 256

That's seriously wrong.  What if the compiler decided to not add
that padding? You will be scribbling all over the stack.

Why are you allocating this qat_auth_state anyway? Just do
ipad/opad[block_size] and be done with it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
