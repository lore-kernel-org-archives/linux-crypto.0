From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3] arm: crypto: Add optimized SHA-256/224
Date: Wed, 1 Apr 2015 20:43:25 +0800
Message-ID: <20150401124325.GA26623@gondor.apana.org.au>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
 <20150330083727.GA22406@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	ard.biesheuvel@linaro.org, davem@davemloft.net,
	Andy Polyakov <appro@openssl.org>
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41199 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbDAMno (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Apr 2015 08:43:44 -0400
Content-Disposition: inline
In-Reply-To: <20150330083727.GA22406@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 30, 2015 at 09:37:27AM +0100, Sami Tolvanen wrote:
> Add Andy Polyakov's optimized assembly and NEON implementations for
> SHA-256/224.
> 
> The sha256-armv4.pl script for generating the assembly code is from
> OpenSSL commit 51f8d095562f36cdaa6893597b5c609e943b0565.
> 
> Compared to sha256-generic these implementations have the following
> tcrypt speed improvements on Motorola Nexus 6 (Snapdragon 805):

I cannot merge this because none of your emails are making it
to the mailing list so nobody except those on the cc list can
see the patch.

Please refer to section 7 in Documentation/SubmittingPatches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
