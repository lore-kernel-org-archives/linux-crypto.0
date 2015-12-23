From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: KEYS: convert public key and digsig asym to
 the akcipher api
Date: Thu, 24 Dec 2015 04:21:03 +0800
Message-ID: <20151223202103.GA4717@gondor.apana.org.au>
References: <20151223143352.5035.85876.stgit@tstruk-mobl1>
 <20151223145130.GA2598@gondor.apana.org.au>
 <567AB6AF.4040702@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53252 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbLWUVN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 15:21:13 -0500
Content-Disposition: inline
In-Reply-To: <567AB6AF.4040702@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 23, 2015 at 06:58:55AM -0800, Tadeusz Struk wrote:
> 
> Because the first patch modifies the struct public_key and removes the MPIs from it,
> which the code modified in the second patch still uses. If bisect only takes the first
> then the build will fail on the security/integrity/digsig_asymmetric.c as reported by
> kbuild test robot:

Why not just leave the MPIs in the structure and only remove them
by adding a third patch?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
