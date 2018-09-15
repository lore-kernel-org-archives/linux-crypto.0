From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 18/20] crypto: port ChaCha20 to Zinc
Date: Sun, 16 Sep 2018 01:21:48 +0200
Message-ID: <CAHmME9qGDvSDmxAjz767fbV82Q9a1MLL1rWxqRhqQzwhCbAi_A@mail.gmail.com>
References: <20180914162240.7925-19-Jason@zx2c4.com> <201809160711.HzjdJedZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201809160711.HzjdJedZ%fengguang.wu@intel.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Mr. Ro Bot,

On Sun, Sep 16, 2018 at 1:14 AM kbuild test robot <lkp@intel.com> wrote:
>    crypto/chacha20_zinc.o: In function `crypto_chacha20_crypt':
> >> crypto/chacha20_zinc.c:55: undefined reference to `chacha20'

Looks like my Kconfig change didn't get squashed in as intended. Fixed for v5.

Thanks,
Jason
