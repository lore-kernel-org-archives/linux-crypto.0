From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 11 Sep 2018 16:02:52 -0600
Message-ID: <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911145624.GA21635@kroah.com> <20180911214737.GA81235@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911214737.GA81235@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 3:47 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Of course, the real problem is that even after multiple revisions of this
> patchset, there's still no actual conversions of the existing crypto API
> algorithms over to use the new implementations.  "Zinc" is still completely
> separate from the existing crypto API.

No this is not, "the real problem [...] after multiple revisions"
because I've offered to do this and stated pretty clearly my intent to
do so. But, as I've mentioned before, I'd really prefer to land this
series through net-next, and then after we can turn our attention to
integrating this into the existing crypto API. This series is already
big enough and I would really prefer not to further complicate it.

So, what you want is going to happen. There isn't some kind of
fundamental problem here. This is more of a discussion on
scheduling/trees/mergecycles than anything else.
