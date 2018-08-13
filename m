From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 08:40:11 -0700
Message-ID: <1534174811.7872.3.camel@HansenPartnership.com>
References: <20180731191102.2434-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731191102.2434-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Ample information, including documentation, installation
> instructions,
> and project details, is available at:
> 
>   * https://www.wireguard.com/
>   * https://www.wireguard.com/papers/wireguard.pdf

In your paper you say this:

> Finally, WireGuard is cryptographically opinionated. It intentionally
> lacks cipher and protocol agility. If
> holes are found in the underlying primitives, all endpoints will be
> required to update.

The only thing that's certain (beyond death and taxes) is that your
crypto choice will one day need updating; either in response to an
urgent CVE because an algorithm is compromised or in response to a less
urgent one because it is deprecated.  Assuming wireguard is reasonably
successful we'll have a large ecosystem dependent on it.  On this day,
we're going to have the choice of either breaking the entire ecosystem
by rolling out a change that can't connect to lower protocol versions
or trying to wedge version agility into wireguard in a hurry.  The
former is too awful to contemplate because of the almost universal
ecosystem breakage it would cause and the latter is going to lead to
additional bugs because people in a hurry aren't as careful as they
should be.

Could we please build planning for this crypto failure day into
wireguard now rather than have to do it later?  It doesn't need to be
full cipher agility, it just needs to be the ability to handle multiple
protocol versions ... two should do it because that gives a template to
follow (and test version to try to find bugs in the implementation). 
It looks like the protocol could simply be updated to put the version
into one (or more) of the three reserved bytes in the handshake
headers, so perhaps doing this before they get used for something else
would be a good first step?

James
