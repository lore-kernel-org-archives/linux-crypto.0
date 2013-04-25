From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/6] Add AVX2 accelerated implementations for
 Blowfish, Twofish, Serpent and Camellia
Date: Thu, 25 Apr 2013 22:18:37 +0800
Message-ID: <20130425141837.GB29501@gondor.apana.org.au>
References: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55611 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932256Ab3DYOSo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Apr 2013 10:18:44 -0400
Content-Disposition: inline
In-Reply-To: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 13, 2013 at 01:46:29PM +0300, Jussi Kivilinna wrote:
> The following series implements four block ciphers - Blowfish, Twofish, Serpent
> and Camellia - using AVX2 instruction set. This work on AVX2 implementations
> started over year ago and have been available at
> 	https://github.com/jkivilin/crypto-avx2

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
