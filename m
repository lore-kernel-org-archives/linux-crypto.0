From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography library
Date: Tue, 25 Sep 2018 22:02:13 +0200
Message-ID: <CAHmME9paEYXKS176MK4VM+wobc0KfNGz3yuQUQhaVNtFBv2oRg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-3-Jason@zx2c4.com>
 <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
 <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com> <1BA7DB23-7BB6-46BA-A3E2-D65BC3CAF11C@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1BA7DB23-7BB6-46BA-A3E2-D65BC3CAF11C@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 25, 2018 at 10:00 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > On Sep 25, 2018, at 12:43 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> >> On Tue, Sep 25, 2018 at 8:33 PM Joe Perches <joe@perches.com> wrote:
> >> I think the -Dpr_fmt is especially odd and not
> >> really acceptable as it not used anywhere else
> >> in the kernel.
> >
> > There are about 2000 cases in the kernel of the same '#define
> > pr_fmt...' being pasted into the top of the file, which seems a bit
> > cumbersome. Rather than having to paste that into each and every file
> > that I pr_err from, why can't I just do this from the makefile, since
> > I want that same pr_fmt to copy the whole directory?
>
> Because people like to be able to just read the C file to figure out what it does. Or we could adopt the Makefile approach kernel-wide, since this use of it seems reasonable.

It would indeed be nice to see this done tree-wide. I can recall
various random bugs over the year where some dmesg messages are
missing a prefix because the author forgot to copy and paste the thing
to /yet another file/ in the same directory.
