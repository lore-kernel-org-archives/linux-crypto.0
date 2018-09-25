From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next v6 02/23] zinc: introduce minimal cryptography
 library
Date: Tue, 25 Sep 2018 13:21:45 -0700
Message-ID: <abedae13e59e01200531931e530b46e937501c4a.camel@perches.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
         <20180925145622.29959-3-Jason@zx2c4.com>
         <2b5f2df2f1278c118a913259a44efdf589719293.camel@perches.com>
         <CAHmME9qLzFHPm2aaEKOmjBA95-c3CZuT+kQiuksLRRWQ_ad2sw@mail.gmail.com>
         <748429eee2fc77afd01630c24bd2cf66a545aec5.camel@perches.com>
         <CAHmME9peVqXDq7hmFZ+4cus+Y97NHS-TyBKF9GkdLvixdmq6hw@mail.gmail.com>
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
In-Reply-To: <CAHmME9peVqXDq7hmFZ+4cus+Y97NHS-TyBKF9GkdLvixdmq6hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-09-25 at 22:12 +0200, Jason A. Donenfeld wrote:
> Hi Joe,
> 
> On Tue, Sep 25, 2018 at 10:05 PM Joe Perches <joe@perches.com> wrote:
> > As far as I can tell, zinc doesn't use pr_err, just
> > pr_info
> 
> Yes, pr_info, not pr_err. Apologies for my imprecision. But the
> distinction does not matter at all, since they both use pr_fmt in
> exactly the same way, which is sufficient for the purposes of this
> discussion.
> 
> > >  why can't I just do this from the makefile, since
> > > I want that same pr_fmt to copy the whole directory?
> > 
> > Ideally all of those
> > 
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> > uses will be removed one day soon and the default
> > will change.
> > 
> > https://lore.kernel.org/patchwork/cover/904507/
> > 
> > This slightly odd use might complicate that.
> 
> Oh, that's good to see. In this case, I'm prefixing all of them with
> zinc: instead of zinc_chacha20: (the modname), but I wouldn't object
> to that changing to KBUILD_MODNAME if your patch lands. IOW, once your
> patch lands, I'm happy to revisit this discussion and fall back to
> using the sane defaults you're in the process of setting up for
> everyone.

I'd still prefer as all these are effectively
debugging output that you convert the pr_info
uses pr_debug and so avoid using pr_fmt altogether.
