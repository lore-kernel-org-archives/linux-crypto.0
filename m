From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography library
Date: Tue, 25 Sep 2018 22:12:54 +0200
Message-ID: <CAHmME9peVqXDq7hmFZ+4cus+Y97NHS-TyBKF9GkdLvixdmq6hw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-3-Jason@zx2c4.com>
 <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
 <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com> <748429eee2fc77afd01630c24bd2cf66a545aec5.camel@perches.com>
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
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <748429eee2fc77afd01630c24bd2cf66a545aec5.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Joe,

On Tue, Sep 25, 2018 at 10:05 PM Joe Perches <joe@perches.com> wrote:
> As far as I can tell, zinc doesn't use pr_err, just
> pr_info

Yes, pr_info, not pr_err. Apologies for my imprecision. But the
distinction does not matter at all, since they both use pr_fmt in
exactly the same way, which is sufficient for the purposes of this
discussion.

> >  why can't I just do this from the makefile, since
> > I want that same pr_fmt to copy the whole directory?
>
> Ideally all of those
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> uses will be removed one day soon and the default
> will change.
>
> https://lore.kernel.org/patchwork/cover/904507/
>
> This slightly odd use might complicate that.

Oh, that's good to see. In this case, I'm prefixing all of them with
zinc: instead of zinc_chacha20: (the modname), but I wouldn't object
to that changing to KBUILD_MODNAME if your patch lands. IOW, once your
patch lands, I'm happy to revisit this discussion and fall back to
using the sane defaults you're in the process of setting up for
everyone.

Jason
