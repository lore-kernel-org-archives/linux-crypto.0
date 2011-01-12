From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Why are there multiple defines of scatter_walk?
Date: Wed, 12 Jan 2011 15:21:01 +1100
Message-ID: <20110112042101.GA15048@gondor.apana.org.au>
References: <Pine.GSO.4.64.1101111118140.25632@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54058 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEVE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Jan 2011 23:21:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1101111118140.25632@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
> 
> I notice two defines of struct scatter_walk; one at line 20 of 
> include/crypto/scatterwalk.h and the other at line 74 of 
> include/crypto/algapi.h
> 
> They are not the same. Why?
> 
> Which one does a driver supposed to include?

In my copy of scatterwalk.h there is no such struct definition.

What version of Linux are you looking at?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
