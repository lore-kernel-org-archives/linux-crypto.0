From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto
 Extensions
Date: Tue, 25 Feb 2014 17:08:35 +0800
Message-ID: <20140225090835.GA11135@gondor.apana.org.au>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140225070252.GB9934@gondor.apana.org.au>
 <CAKv+Gu-HnTk5RCLRoCnae7-HH7C-Tq2YJF57Nc-hOEykdY52XA@mail.gmail.com>
 <20140225071626.GA10524@gondor.apana.org.au>
 <CAKv+Gu_A_04P=nOoPfxhJMC3bbEPTcpgZO0Ldw2H4BV7T_gTbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	Nicolas Pitre <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41260 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYJIl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 04:08:41 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_A_04P=nOoPfxhJMC3bbEPTcpgZO0Ldw2H4BV7T_gTbw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:21:22AM +0100, Ard Biesheuvel wrote:
> 
> For the authenticate-only data, this is manageable as you are only
> dealing with input, but when dealing with both in- and output, as in
> the core of CCM, it becomes very tedious.
> So instead, I have opted for an inner blkcipher instance which takes
> care of all of that. Could you suggest another approach that if
> preferable?

I don't think the walk helper actually needs the tfm apart from
getting a couple of parameters out of it, so perhaps we can just
change the helper to not depend on a tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
