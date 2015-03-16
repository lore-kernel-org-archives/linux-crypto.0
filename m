From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] arm: crypto: Add NEON optimized SHA-256
Date: Mon, 16 Mar 2015 16:23:04 +0000
Message-ID: <20150316162304.GA35408@google.com>
References: <20150316154835.GA31336@google.com>
 <CAKv+Gu8+oQ13j61X6x70baJXOpEiM2L+vK=KgK1JG12sy5KMsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Polyakov <appro@openssl.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:32878 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbbCPQXI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 12:23:08 -0400
Received: by weop45 with SMTP id p45so16849176weo.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2015 09:23:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8+oQ13j61X6x70baJXOpEiM2L+vK=KgK1JG12sy5KMsg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 16, 2015 at 05:08:03PM +0100, Ard Biesheuvel wrote:
> Have you tested this code with the tcrypt.ko module?

I have not, but I can look into it.

> Did you talk to Andy about the license? I don't think this is
> permissible for the kernel as-is.

Unless I have misunderstood something, the license at the Cryptogams
website includes an option to license the code under the GNU GPL.

However, I can certainly contact Andy to clarify his intentions.

> This is broken on thumb-2, use adr instead

> You can also implement SHA-224 using the same core transform, it's
> just some trivial glue code.

> Could you please rebase this onto Herbert's cryptodev tree and move
> this to arch/arm/crypto/Kconfig?

Thanks for the comments, I will submit a second version once we have
a clarification on the license.

Sami
