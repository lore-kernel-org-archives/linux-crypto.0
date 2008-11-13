From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ansi_cprng: avoid incorrect extra call to
	_get_more_prng_bytes
Date: Thu, 13 Nov 2008 22:01:51 +0800
Message-ID: <20081113140151.GB32012@gondor.apana.org.au>
References: <200811121452.59789.jarod@redhat.com> <200811121500.44044.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45405 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859AbYKMOB7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 09:01:59 -0500
Content-Disposition: inline
In-Reply-To: <200811121500.44044.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 12, 2008 at 03:00:43PM -0500, Jarod Wilson wrote:
>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
