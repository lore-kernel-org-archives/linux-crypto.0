From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-des - make local functions static
Date: Mon, 10 Mar 2014 20:21:46 +0800
Message-ID: <20140310122146.GE10556@gondor.apana.org.au>
References: <000701cf33af$e46a9f80$ad3fde80$%han@samsung.com>
 <530FDF84.6060705@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jingoo Han <jg1.han@samsung.com>,
	'David Miller' <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36920 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaCJMVw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:21:52 -0400
Content-Disposition: inline
In-Reply-To: <530FDF84.6060705@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 27, 2014 at 06:59:48PM -0600, Joel Fernandes wrote:
> On 02/27/2014 05:34 AM, Jingoo Han wrote:
> > Make omap_des_copy_needed(), omap_des_copy_sgs(), because these
> > functions are used only in this file.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Ok with me,
> Acked-by: Joel Fernandes <joelf@ti.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
