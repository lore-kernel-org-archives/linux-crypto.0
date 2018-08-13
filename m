From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 17:53:58 +0200
Message-ID: <20180813155358.GK14633@1wt.eu>
References: <20180731191102.2434-1-Jason@zx2c4.com>
 <1534174811.7872.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534174811.7872.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 13, 2018 at 08:40:11AM -0700, James Bottomley wrote:
> Could we please build planning for this crypto failure day into
> wireguard now rather than have to do it later?  It doesn't need to be
> full cipher agility, it just needs to be the ability to handle multiple
> protocol versions ... two should do it because that gives a template to
> follow (and test version to try to find bugs in the implementation). 

It's also what provides a *real* upgrade path to future versions :
before deploying you need something which works, and the only way to
get something working at a large scale is to have early adopters. Those
willing to deploy a beta version will not do it if it requires to lose
all their users and possibly to make rollbacks impossible. At least for
this it's important to support an optionnal new version on top of the
existing one (i.e. prod + beta together).

Cheers,
Willy
