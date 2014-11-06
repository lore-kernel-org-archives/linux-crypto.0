From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Wed, 05 Nov 2014 18:15:12 -0800
Message-ID: <545AD9B0.4090009@gmail.com>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de> <4163724.RCMDlx8dmE@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57436 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKFCRv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Nov 2014 21:17:51 -0500
In-Reply-To: <4163724.RCMDlx8dmE@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 11/02/2014 12:35 PM, Stephan Mueller wrote:
> +	* type:
> +		- blkcipher for symmetric block ciphers

blkcipher for synchronous block ciphers

> +		- ablkcipher for asymmetric block ciphers

ablkcipher for asynchronous block ciphers

> +		- cipher for single block ciphers that may be used with an
> +		  additional template
> +		- shash for symmetric message digest

shash for synchronous message digest

> +		- ahash for asymmetric message digest

ahash for asynchronous message digest

T.
