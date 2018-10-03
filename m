From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v6 11/23] zinc: import Andy Polyakov's Poly1305
 ARM and ARM64 implementations
Date: Tue, 2 Oct 2018 23:12:37 -0700
Message-ID: <20181003061236.GB745@sol.localdomain>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-12-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Andy Polyakov <appro@openssl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-12-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 25, 2018 at 04:56:10PM +0200, Jason A. Donenfeld wrote:
> These NEON and non-NEON implementations come from Andy Polyakov's
> implementation, and are included here in raw form without modification,
> so that subsequent commits that fix these up for the kernel can see how
> it has changed. This awkward commit splitting has been requested for the
> ARM[64] implementations in particular.
> 
> While this is CRYPTOGAMS code, the originating code for this happens to
> be the same as OpenSSL's commit 5bb1cd2292b388263a0cc05392bb99141212aa53

Sorry to ruin the fun, but actually there are no Poly1305 implementations in
CRYPTOGAMS (https://github.com/dot-asm/cryptogams).  Nor are there any ChaCha20
implementations.

Andy P., can you please add your Poly1305 and ChaCha20 implementations to the
CRYPTOGAMS repository, so that they have a clear kernel-compatible license?

It would be great if you'd include a kernel-compatible license directly in the
versions in the OpenSSL tree too...

Thanks!

- Eric
