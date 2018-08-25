From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Sat, 25 Aug 2018 19:26:52 +0200
Message-ID: <20180825172652.GA23992@lunn.ch>
References: <20180824213849.23647-1-Jason@zx2c4.com>
 <20180824213849.23647-3-Jason@zx2c4.com>
 <20180825062951.GC726@sol.localdomain>
 <20180825164005.GA7748@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180825164005.GA7748@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 25, 2018 at 10:40:06AM -0600, Jason A. Donenfeld wrote:
> Hey Eric,
> 
> On Fri, Aug 24, 2018 at 11:29:52PM -0700, Eric Biggers wrote:
> > I thought you were going to wrap lines at 80 characters?  It's hard to read the
> > extremely long lines, and they encourage deep nesting.
> 
> I somehow noted this for the WireGuard side of things but assumed I
> didn't need to do so for Zinc. Hah, such wishful thinking. I'll have
> this wrapped at 80 for v3.

Hi Jason

The coding style document applies to all code in the tree. Plus some
out of tree stuff, like iproute2 if, you need user space patches for
that.

I've been running checkpatch on just the network parts. But i expect
at some point, somebody will run it on the crypto stuff as well, and
ask you to fix up some of the errors and warning.

There is also a general trend that you won't get in detail human
reviews until the automated review tools indicate the code is O.K.,

	Andrew
