From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: KEYS: convert public key and digsig asym to
 the akcipher api
Date: Wed, 23 Dec 2015 22:51:30 +0800
Message-ID: <20151223145130.GA2598@gondor.apana.org.au>
References: <20151223143352.5035.85876.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54099 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbLWOvi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 09:51:38 -0500
Content-Disposition: inline
In-Reply-To: <20151223143352.5035.85876.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 23, 2015 at 06:33:53AM -0800, Tadeusz Struk wrote:
>
> Changes in v4:
> - Flatten both patches into one to avoid bisect compilation problems.

Why is this necessary?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
