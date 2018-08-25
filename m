From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Sat, 25 Aug 2018 18:16:24 +0200
Message-ID: <20180825161624.GB22750@lunn.ch>
References: <20180824213849.23647-1-Jason@zx2c4.com>
 <20180824213849.23647-3-Jason@zx2c4.com>
 <20180825062951.GC726@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180825062951.GC726@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> It seems you still don't explicitly clarify anywhere in the source itself that
> the copyright holders of the code from OpenSSL have relicensed it under GPLv2.
> I only see a GPLv2 license slapped on the files, yet no such license is presence
> in the OpenSSL originals, at least in the one I checked.  If you did receive
> explicit permission, then you should include an explicit clarification in each
> file like the one in arch/arm/crypto/sha1-armv4-large.S.

Better yet, get the copyright holders to publicly send a
signed-off-by: or acked-by: so it is clear they agree to this.

	       Andrew
