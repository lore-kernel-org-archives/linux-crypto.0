From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v5 04/20] zinc: ChaCha20 x86_64 implementation
Date: Wed, 19 Sep 2018 00:29:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809190017050.1468@nanos.tec.linutronix.de>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-5-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-5-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason,

On Tue, 18 Sep 2018, Jason A. Donenfeld wrote:

> This provides SSSE3, AVX-2, AVX-512F, and AVX-512VL implementations for
> ChaCha20. The AVX-512F implementation is disabled on Skylake, due to
> throttling, and the VL ymm implementation is used instead. These come
> from Andy Polyakov's implementation, with the following modifications
> from Samuel Neves:
...
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>

I'm a bit confused by this SOB chain. So above you write that it's from
Andy Polakovs implementation and Samuel did the changes. But here it seems
you are the main author. If Samuel just did some modifications then you
want to use the Co-developed-by tag along with his SOB.

Also I'd recommend to add a Originally-by or Based-on-code-from: Andy
Polyakov tag. Both are not formal tags but widely in use for attributions.

> +++ b/lib/zinc/chacha20/chacha20-x86_64-glue.h
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: MIT

Please put that into a separate one liner comment. Also this should be
'GPL-2.0[+] or MIT' I think.

> +++ b/lib/zinc/chacha20/chacha20-x86_64.S
> @@ -0,0 +1,2632 @@
> +/* SPDX-License-Identifier: BSD-3-Clause

See above. That applies to all the others as well.

Thanks,

	tglx
