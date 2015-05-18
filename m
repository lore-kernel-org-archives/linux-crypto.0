From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Tue, 19 May 2015 06:58:07 +0800
Message-ID: <20150518225807.GA25931@gondor.apana.org.au>
References: <477328243.LmeEDk1ili@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51951 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbbERW6S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 18:58:18 -0400
Content-Disposition: inline
In-Reply-To: <477328243.LmeEDk1ili@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
>
> I hear more and more discussions about recommendations to use AES 256 and not 
> AES 128.
> 
> These kind of recommendations will eventually also affect the entropy 
> requirements for noise sources. This is my motivation for the patch: allowing 
> different user groups to set the minimum bar for the nonblocking pool to 
> *higher* levels (the examples for 80 to 112 bits or 100 to 125 bits shall just 
> show that there are active revisions of entropy requirements).

Does anyone need to raise this from 128 today? If not then this
patch is pointless.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
