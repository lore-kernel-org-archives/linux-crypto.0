From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] arm: crypto: Add NEON optimized SHA-256
Date: Tue, 17 Mar 2015 15:21:20 +0000
Message-ID: <20150317152120.GA31053@google.com>
References: <20150316154835.GA31336@google.com>
 <CAKv+Gu8+oQ13j61X6x70baJXOpEiM2L+vK=KgK1JG12sy5KMsg@mail.gmail.com>
 <20150316162304.GA35408@google.com>
 <CAKv+Gu8fmBYwfrMKRqhA5KhU1HNjMP1cLtpmgCmp78R4CUw3fg@mail.gmail.com>
 <550843B4.8080903@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Andy Polyakov <appro@openssl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33372 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbCQPVZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 11:21:25 -0400
Received: by wgbcc7 with SMTP id cc7so11337691wgb.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2015 08:21:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <550843B4.8080903@openssl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 17, 2015 at 04:09:40PM +0100, Andy Polyakov wrote:
> I have no problems with reusing assembly modules in kernel context.

Awesome, thank you for clarifying this.

> I'd prefer if it can be arranged in way similar to bsaes-armv7 module,
> i.e. we work together on shared copy of module that generates assembly
> that can be then compiled for OpenSSL or kernel. Is it sensible?

Sure, that sounds good to me.

> BTW, why stop at SHA256? There is SHA512 and NEON SHA1...

The kernel already has NEON SHA-1 and SHA-512, but for some reason is
lacking SHA-256. I have not tested how they compare to yours though.

Sami
