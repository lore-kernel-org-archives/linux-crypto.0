From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Sun, 14 Aug 2011 21:09:53 +0200
Message-ID: <CA+rthh8WQ1KxFj+gHJ=MzdNVmLsWPQjG_-Opfd5drjR8nvdhQw@mail.gmail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-3-git-send-email-minipli@googlemail.com>
	<20110804064436.GA16247@gondor.apana.org.au>
	<4E43EC49.1040803@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	linux-kernel@vger.kernel.org
To: Andy Lutomirski <luto@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43884 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1HNTJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Aug 2011 15:09:54 -0400
In-Reply-To: <4E43EC49.1040803@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 11, 2011 at 4:50 PM, Andy Lutomirski <luto@mit.edu> wrote:
> I have vague plans to clean up extended state handling and make
> kernel_fpu_begin work efficiently from any context. =A0(i.e. the firs=
t
> kernel_fpu_begin after a context switch could take up to ~60 ns on Sa=
ndy
> Bridge, but further calls to kernel_fpu_begin would be a single branc=
h.)
>
> The current code that handles context switches when user code is usin=
g
> extended state is terrible and will almost certainly become faster in=
 the
> near future.

Sounds good! This would not only improve the performance of sha1_ssse3
but of aesni as well.

> Hopefully I'll have patches for 3.2 or 3.3.
>
> IOW, please don't introduce another thing like the fpu crypto module =
quite
> yet unless there's a good reason. =A0I'm looking forward to deleting =
the fpu
> module entirely.

I've no intention to. So please go ahead and do so.


Mathias
