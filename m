From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 01/11] crypto: xcbc: Remove VLA usage
Date: Mon, 25 Jun 2018 14:38:43 -0700
Message-ID: <14ea0f2845d9f826c8b2117badfa346423e0f1cf.camel@perches.com>
References: <20180625211026.15819-1-keescook@chromium.org>
         <20180625211026.15819-2-keescook@chromium.org>
         <4d9f90abbf87539d3588f88117806f76c6826030.camel@perches.com>
         <CAGXu5jLbRdZVFqqzKEndogOktfTecBDxyUPvb-=+mgTmQ65v0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLbRdZVFqqzKEndogOktfTecBDxyUPvb-=+mgTmQ65v0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2018-06-25 at 14:32 -0700, Kees Cook wrote:
> On Mon, Jun 25, 2018 at 2:23 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2018-06-25 at 14:10 -0700, Kees Cook wrote:
> > > In the quest to remove all stack VLA usage from the kernel[1], this uses
> > > the maximum blocksize and adds a sanity check. For xcbc, the blocksize
> > > must always be 16, so use that, since it's already being enforced during
> > > instantiation.
> > 
> > Is it time yet to change this warning from 'make W=3' to W=1?
[]
> I was going to skip the churn since I intend to make the default build
> use -Wvla for the next merge window (assuming we've killed all the
> VLAs by then).

Good.

Even if not all VLAs are removed, making the
warning default on is fine by me.

Getting others to do some of the work you've
been doing would be good too.

> After crypto, only fs/ntfs remains, and I have that
> half done already. There are a couple more still under some
> development back-and-forth.
> 
> I'm not _opposed_ to this change, but I'd rather just make it the
> default. And then the next cycle, I'd want it to be -Werror=vla, but I
> may get shouted down. ;)

Yup, you should get shouted down there.
I think -Werror=<anything> is poor form.
