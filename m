From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH RFC 0/3] API for 128-bit IO access
Date: Wed, 24 Jan 2018 17:48:03 +0200
Message-ID: <CAHp75VfWZOAMRaWTa-PZP68tDtXCydNYbGF+8y11L_yMWfP1iA@mail.gmail.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com> <CAK8P3a3TEV7Uyo_oBcMz_GYEYTB+V5AhDgbOgCEW-+X1h7sXEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Yury Norov <ynorov@caviumnetworks.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3TEV7Uyo_oBcMz_GYEYTB+V5AhDgbOgCEW-+X1h7sXEg@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 24, 2018 at 12:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Jan 24, 2018 at 10:05 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:

>> * For 128-bit read/write functions I take suffix 'o', which means read/write
>> the octet of bytes. Is this name OK?
>
> Can't think of anything better. It's not an octet though, but 16 bytes
> ('q' is for quadword, meaning four 16-bit words in Intel terminology).

It's apparently follows Intel's terminology by implying "word", so, "octetword".

-- 
With Best Regards,
Andy Shevchenko
