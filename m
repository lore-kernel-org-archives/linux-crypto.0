From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Add RSA CRT mode to qat driver
Date: Tue, 5 Jul 2016 23:16:00 +0800
Message-ID: <20160705151600.GF8117@gondor.apana.org.au>
References: <1467649300-8951-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35998 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbcGEPQE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 11:16:04 -0400
Content-Disposition: inline
In-Reply-To: <1467649300-8951-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 05:21:37PM +0100, Salvatore Benedetto wrote:
> Hi Herbert,
> 
> this patchset add CRT mode to qat driver.
> First patch extend the parsing of the private key so that all required CRT
> fields are saved. Second patch add a 4K test key. Third patch extend qat
> to use CRT. This latest patch is based on my patch that drop asn1 from qat
> driver.
> 
> Salvatore Benedetto (3):
>   crypto: rsa - Store rest of the private key components
>   crypto: testmgr - Add 4K private key to RSA testvector
>   crypto: qat - Add RSA CRT mode

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
