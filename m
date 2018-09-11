From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v3 05/17] zinc: ChaCha20 x86_64 implementation
Date: Tue, 11 Sep 2018 10:22:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809111021250.5110@nanos.tec.linutronix.de>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-6-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Andy Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911010838.8818-6-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 10 Sep 2018, Jason A. Donenfeld wrote:
>  lib/zinc/Makefile                        |    4 +
>  lib/zinc/chacha20/chacha20-x86_64-glue.h |  102 +
>  lib/zinc/chacha20/chacha20-x86_64.S      | 2632 ++++++++++++++++++++++

Just a stupid question. What's the rationale of putting that into lib/zinc
instead of having it in arch/x86/crypto?

Thanks,

	tglx
