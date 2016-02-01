From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 1/2] crypto: tcrypt - Add acipher bandwidth tests support
Date: Mon, 1 Feb 2016 22:21:59 +0800
Message-ID: <20160201142159.GA11292@gondor.apana.org.au>
References: <1454074387-8321-2-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto-owner@vger.kernel.org,
	horia.geanta@nxp.com, cristian.stoica@nxp.com,
	alexandru.porosanu@nxp.com, cata.vasile@nxp.com
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54715 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbcBAOWF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 09:22:05 -0500
Content-Disposition: inline
In-Reply-To: <1454074387-8321-2-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Catalin Vasile <cata.vasile@nxp.com> wrote:
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>

Please give a description of what your patch does here.

> +       case 600:
> +               band_acipher("ecb(aes)", ENCRYPT, sec, NULL, 0,
> +                                  speed_template_16_24_32);

Rather than creating new test modes, which you would have to do
for every asynchronous type going forward, how about making a new
parameter that toggled this on and off? For example,

modprobe tcrypt mode=601 band=1

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
