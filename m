From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH RFC 0/3] API for 128-bit IO access
Date: Wed, 24 Jan 2018 11:38:42 -0500
Message-ID: <CAH8yC8nvD-CWt9eZ_CumwtVB0xAKKD1uosftAKGvxrhJhcneNw@mail.gmail.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
        Will Deacon <will.deacon@arm.com>
To: Yury Norov <ynorov@caviumnetworks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 24, 2018 at 4:05 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
>
> ...
> With all that, this example code:
>
> static int __init 128bit_test(void)
> {
>         __uint128_t v;
>         __uint128_t addr;
>         __uint128_t val = (__uint128_t) 0x1234567890abc;
> ...

In case it matters, you can check for GCC support of the 128-bit types
in userland with:

#if (__SIZEOF_INT128__ >= 16)
   ...
#endif

Also see https://gcc.gnu.org/ml/gcc-help/2015-08/msg00185.html .

Jeff
