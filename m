From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: crc32-pclmul - Use gas macro for pclmulqdq
Date: Wed, 3 Apr 2013 09:54:50 +0800
Message-ID: <20130403015410.GF20205@gondor.apana.org.au>
References: <1364515544-96421-1-git-send-email-sandyw@twitter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-crypto@vger.kernel.org
To: Sandy Wu <sandyw@twitter.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:56673 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757573Ab3DCBzI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Apr 2013 21:55:08 -0400
Content-Disposition: inline
In-Reply-To: <1364515544-96421-1-git-send-email-sandyw@twitter.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 28, 2013 at 05:05:44PM -0700, Sandy Wu wrote:
> Occurs when CONFIG_CRYPTO_CRC32C_INTEL=y and CONFIG_CRYPTO_CRC32C_INTEL=y.
> Older versions of bintuils do not support the pclmulqdq instruction. The
> PCLMULQDQ gas macro is used instead.
> 
> Signed-off-by: Sandy Wu <sandyw@twitter.com>
> Cc: stable@vger.kernel.org # 3.8+

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
