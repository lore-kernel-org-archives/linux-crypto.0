From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 21/23] crypto: port ChaCha20 to Zinc
Date: Wed, 3 Oct 2018 16:01:06 +0200
Message-ID: <CAHmME9qxND1UR0SN6TLQb39f0wz0tiwJWfd7PKeQZ0-W+no39Q@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-22-Jason@zx2c4.com>
 <20181003055559.GA745@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003055559.GA745@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Wed, Oct 3, 2018 at 7:56 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Multiple threads may use the same tfm concurrently, so the tfm context must not
> be used to store per-request information such as the IV.

Thanks, fixed for v7.

Jason
