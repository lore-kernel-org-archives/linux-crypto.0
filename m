From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/4] crypto: akcipher: add akcipher declarations
 useful for templates.
Date: Tue, 24 Nov 2015 17:54:08 +0800
Message-ID: <20151124095408.GA315@gondor.apana.org.au>
References: <1447989215-523-3-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33034 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbKXJyP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Nov 2015 04:54:15 -0500
Content-Disposition: inline
In-Reply-To: <1447989215-523-3-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
> Expose crypto_akcipher_type like other crypto types are exposed to be
> used from outside akcipher.c.  Add a struct akcipher_instance similar to
> aead_instance with just the right size for an akcipher template
> instance, and two macros for converting to/from crypto_instance.

You're still doing some things in the old way.  With new templates,
you shouldn't need to export the crypto type at all.  Please look
at how AEAD does it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
