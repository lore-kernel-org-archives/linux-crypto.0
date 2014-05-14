From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH resend 00/15] arm64 crypto roundup
Date: Wed, 14 May 2014 09:29:05 +0800
Message-ID: <20140514012905.GA28974@gondor.apana.org.au>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140507144554.GC17253@arm.com>
 <CAKv+Gu-sLaDJxFcvXwD93qdzyTuPCNL0DXbRp2BKb8U=8Q8c2A@mail.gmail.com>
 <760C2409-2C8F-45B7-8EC0-220545D0B51B@arm.com>
 <CAKv+Gu8iYzPUWfwLJJtPCGWKROV5EKSP-NA90F+PyVecorOL9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47436 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaENB3Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 21:29:16 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8iYzPUWfwLJJtPCGWKROV5EKSP-NA90F+PyVecorOL9g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 09, 2014 at 08:37:58AM +0200, Ard Biesheuvel wrote:
>
> @Herbert, Jussi: care to share your opinion on the SHAx, GHASH and AES
> patches above? Herbert has already acked the ccm patch, but Catalin is
> requesting for more review and/or acknowledgements before merging
> these patches for arm64.

They look fine to me.  You can add my Ack to them.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
