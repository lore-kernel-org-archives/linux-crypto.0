From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Thu, 27 Sep 2018 19:06:50 +0200
Message-ID: <CAHmME9oXBin5NyVTKfV2efSzztW4Snno+sZoWJr-ieDLNVgVGQ@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
 <CAKv+Gu8w74dUSEAGxxh=C6To6F=bSm8DjiExUPmh_LUyhoDLhg@mail.gmail.com>
 <CAHmME9pbRabkGjNh-65S9qBNNS1GLJSwZ_tTM507S_Ezr1=QLg@mail.gmail.com>
 <CAHmME9ru=kJO8QiW+uNNgt5NgFVZzRsQ4tNSgo+f+KfHs3fAKQ@mail.gmail.com>
 <CAKv+Gu-WDt8f9qVjLDRPHL7THS0BjtKHThw2RMfHbWBT8Hs8aQ@mail.gmail.com>
 <CAHmME9qNn5aRgtbV3bAsz3xW1A49a7RMMkOzGruBUPzLVUxVNg@mail.gmail.com>
 <CAHmME9rN3-7Mj5JQqt2EFPauG9vjkN5pQn3tPiJY4fPiwksaDA@mail.gmail.com>
 <CAHmME9pBRu4hC5=Ef62R_nWOi3jTegxvxNrR8qDM+VfO=2t8Tg@mail.gmail.com> <BB2CD8D5-E7FF-4D25-8C83-F64960253248@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BB2CD8D5-E7FF-4D25-8C83-F64960253248@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 27, 2018 at 6:27 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
> I would add another consideration: if you can get better latency with neg=
ligible overhead (0.1%? 0.05%), then that might make sense too. For example=
, it seems plausible that checking need_resched() every few blocks adds bas=
ically no overhead, and the SIMD helpers could do this themselves or perhap=
s only ever do a block at a time.
>
> need_resched() costs a cacheline access, but it=E2=80=99s usually a hot c=
acheline, and the actual check is just whether a certain bit in memory is s=
et.

Yes you're right, I do plan to check quite often, rather than seldom,
for this reason. I've been toying with the idea of instead processing
65k (maximum size of a UDP packet) at a time before checking
need_resched(), but armed with the 20=C2=B5s figure, this isn't remotely
possible on most hardware. So I'll stick with the original
conservative plan of checking very often, and not making things
different from the aspects worked out by the present crypto API in
this regard.
