From: Willy Tarreau <w@1wt.eu>
Subject: Re: crypto_memneq not backported to 3.10
Date: Mon, 1 May 2017 16:48:35 +0200
Message-ID: <20170501144835.GA20339@1wt.eu>
References: <CAHmME9qjWeskvkVJCNnY1Xm7uAu4=gnuSsxX5KMf3kt6kqF9ow@mail.gmail.com>
 <20170409132514.GA3970@1wt.eu>
 <CAHmME9r9Jj=WtQxhxqtwWHFxwJV6KzMWO7qdsvhfG8R3B1qbJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        security@kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9r9Jj=WtQxhxqtwWHFxwJV6KzMWO7qdsvhfG8R3B1qbJw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

On Mon, May 01, 2017 at 04:30:01PM +0200, Jason A. Donenfeld wrote:
> > I'll check if the 3.12 patches above can be safely backported, and I'll
> > have to re-apply the missing part of the one that was trimmed down
> > (commit 620c411 ("crypto: more robust crypto_memneq")).
> 
> I'm vaguely wondering if you ever decided on backporting this. After I
> reported the issue to Ubiquiti -- a random vendor doing ipsec with
> 3.10 -- they actually released a backport of these functions in a
> security update for their stuff. So I imagine others might want this
> sort of thing too.

I'll do it. It just happens that I've been quite busy lately so
no new 3.10 was released since you reported this ~1 month ago. I'll
get back to this ASAP.

Thanks for the heads up,
Willy
