From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: race condition in crypto larval handling
Date: Wed, 11 Sep 2013 09:13:01 +1000
Message-ID: <20130910231301.GA28135@gondor.apana.org.au>
References: <522D2743.9060802@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49403 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227Ab3IJXNF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Sep 2013 19:13:05 -0400
Content-Disposition: inline
In-Reply-To: <522D2743.9060802@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please don't trim cc lists!

James Yonan <james@openvpn.net> wrote:
> 
> I tried this patch, but I still see an apparent module lookup/load race 
> if code on several CPUs calls crypto_alloc_aead at the same time, and an 
> external module such as aes needs to be loaded.
> 
> Seeing this in the log: "request_module: runaway loop modprobe gcm(aes)"
> 
> Shouldn't module lookup/load be bracketed by some sort of lock to 
> prevent this?

This sounds like a different problem.  Larvals are only used to
control the instantiation of templates.  The loading of modules
occur prior to that so you can certainly have multiple loads occur
if multiple threads are trying to allocate the same algorithm.

This should be harmless since gcm(aes) doesn't exist anyway so
regardless of whether we load the module the lookup will fail and
we will go through the larval code path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
