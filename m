From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography
 library
Date: Tue, 25 Sep 2018 13:05:06 -0700
Message-ID: <748429eee2fc77afd01630c24bd2cf66a545aec5.camel@perches.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
         <20180925145622.29959-3-Jason@zx2c4.com>
         <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
         <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com>
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
In-Reply-To: <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-09-25 at 21:43 +0200, Jason A. Donenfeld wrote:
> On Tue, Sep 25, 2018 at 8:33 PM Joe Perches <joe@perches.com> wrote:
> > I think the -Dpr_fmt is especially odd and not
> > really acceptable as it not used anywhere else
> > in the kernel.
> 
> There are about 2000 cases in the kernel of the same '#define
> pr_fmt...' being pasted into the top of the file, which seems a bit
> cumbersome. Rather than having to paste that into each and every file
> that I pr_err from,

As far as I can tell, zinc doesn't use pr_err, just
pr_info in all the selftest blocks which are only
used when DEBUG is #defined.

Perhaps all the pr_info uses should use pr_debug
instead as well as dynamic debugging which already
optionally adds KBUILD_MODINFO.

>  why can't I just do this from the makefile, since
> I want that same pr_fmt to copy the whole directory?

Ideally all of those

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

uses will be removed one day soon and the default
will change.

https://lore.kernel.org/patchwork/cover/904507/

This slightly odd use might complicate that.
