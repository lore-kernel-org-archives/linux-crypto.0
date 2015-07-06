From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 10/10] crypto: tcrypt: Added speed tests for Async AEAD
 crypto alogrithms
Date: Mon, 6 Jul 2015 16:49:31 +0800
Message-ID: <20150706084931.GA20992@gondor.apana.org.au>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-11-git-send-email-lokeshvutla@ti.com>
 <20150706074403.GE20192@gondor.apana.org.au>
 <559A4012.8070407@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559A4012.8070407@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 06, 2015 at 02:15:06PM +0530, Lokesh Vutla wrote:
>
> The existing AEAD test case does not do a wait_for_completion(), when
> the return value is EINPROGRESS or EBUSY like it is done for acipher_speed tests.

Please fix them to do the wait.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
