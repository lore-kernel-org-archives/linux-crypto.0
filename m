From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: des3_ede: permit weak keys unless
	REQ_WEAK_KEY set
Date: Sun, 7 Dec 2008 19:38:28 +0800
Message-ID: <20081207113828.GD13736@gondor.apana.org.au>
References: <200812041557.49601.jarod@redhat.com> <493942D9.6030807@redhat.com> <20081205152427.GA32475@gondor.apana.org.au> <493A101A.1080500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51213 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502AbYLGLie (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 06:38:34 -0500
Content-Disposition: inline
In-Reply-To: <493A101A.1080500@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 06, 2008 at 12:39:38AM -0500, Jarod Wilson wrote:
>
> v3: set more appropriate RES flag, also per Herbert.

BTW, please maintain the patch description as you would in the
first submission.  This makes it much easier for me to apply the
patch.  Feel free to summarise changes elsewhere in the email.

> Signed-off-by: Jarod Wilson <jarod@redhat.com>

I tried to apply it but I get

$ git apply ~/p
fatal: corrupt patch at line 29
$ patch -s -p1 < ~/p
patch: **** malformed patch at line 29: u8 *key,

$ 

Please fix it up and resubmit.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
