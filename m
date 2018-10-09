From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v7 25/28] crypto: port Poly1305 to Zinc
Date: Tue, 9 Oct 2018 02:02:32 +0200
Message-ID: <CAHmME9qo+8JKL_J10UghiJjxQABA5meOg=TqgpfvbV=nPJx7Tg@mail.gmail.com>
References: <20181006025709.4019-1-Jason@zx2c4.com> <20181006025709.4019-26-Jason@zx2c4.com>
 <20181008232059.GA164708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008232059.GA164708@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Tue, Oct 9, 2018 at 1:21 AM Eric Biggers <ebiggers@kernel.org> wrote:
> This crashes on very short inputs.  crypto_poly1305_final() is missing:
>
>         if (dctx->rem_key_bytes)
>                 return -ENOKEY;

Good catch, thanks. Queued for v8.

Jason
