From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography
 library
Date: Tue, 25 Sep 2018 14:02:52 -0700
Message-ID: <102e1673681b4efb2079befa8d3fb532ed4e5285.camel@perches.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
         <20180925145622.29959-3-Jason@zx2c4.com>
         <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
         <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com>
         <748429eee2fc77afd01630c24bd2cf66a545aec5.camel@perches.com>
         <CAHmME9peVqXDq7hmFZ+4cus+Y97NHS-TyBKF9GkdLvixdmq6hw@mail.gmail.com>
         <abedae13e59e01200531931e530b46e937501c4a.camel@perches.com>
         <CAHmME9qp0_jQn5PeDHJc+Vs003vyqqMTdPmnchjBxxNMvHcJWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9qp0_jQn5PeDHJc+Vs003vyqqMTdPmnchjBxxNMvHcJWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-09-25 at 22:54 +0200, Jason A. Donenfeld wrote:
> Hi Joe,
> 
> On Tue, Sep 25, 2018 at 10:21 PM Joe Perches <joe@perches.com> wrote:
> > I'd still prefer as all these are effectively
> > debugging output that you convert the pr_info
> > uses pr_debug and so avoid using pr_fmt altogether.
> 
> I started to write back, "sure no problem, this will be in v7," but
> then I gave it a closer look, and I think actually I'll be changing
> these into pr_err/pr_info and not naming this "DEBUG" but rather
> "SELFTEST", since I think these are actually very good to have beyond
> mere debugging.

Then you should change the CONFIG_ZINC_DEBUG option too.

Dunno what you should do with the

#ifdef DEBUG
	BUG_ON(...);
#endif

uses though.
