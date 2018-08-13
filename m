From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 10:37:10 -0700
Message-ID: <1534181830.7872.10.camel@HansenPartnership.com>
References: <20180731191102.2434-1-Jason@zx2c4.com>
         <1534174811.7872.3.camel@HansenPartnership.com>
         <CAHmME9raa81A_hH_Zykp2r8zOk0ySroFEsk+8384vnVOCuSa=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9raa81A_hH_Zykp2r8zOk0ySroFEsk+8384vnVOCuSa=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2018-08-13 at 10:02 -0700, Jason A. Donenfeld wrote:
> > Could we please build planning for this crypto failure day into
> > wireguard now rather than have to do it later?  It doesn't need to
> > be full cipher agility, it just needs to be the ability to handle
> > multiple protocol versions ... two should do it because that gives
> > a template to follow (and test version to try to find bugs in the
> > implementation). It looks like the protocol could simply be updated
> > to put the version into one (or more) of the three reserved bytes
> > in the handshake headers, so perhaps doing this before they get
> > used for something else would be a good first step?
> > 
> > James
> > 
> > 
> 
> Indeed the answer is in fact along the lines of what you've suggested
> in your question: the protocol is very strictly versioned. This means
> that while there intentionally isn't negotiation of ciphers --
> something historically very bug-prone -- there is ample room for
> updating the protocol. This is enabled via 4 aspects of the protocol:
> 
> - An explicit "identifier" string is hashed in as part of the first
> step of cryptographic operations, containing a "v1" as well as the
> protocol designer's email.
> - An explicit "construction" string is hashed in as part of the first
> step of cryptographic operations, containing the Noise handshake
> pattern and a list of the cryptographic primitives used.

Any hash involving other parameters allows you to check for a version
mismatch, but it's very hard for a flow classifier because you have to
do the hash at the point you classify.  If we're running concurrent
versions we need an easy way to separate them.

> - A type field at the beginning of each message. Newer message types
> (corresponding with newer versions) can easily be introduced via this
> field, and they can even coexist with older ones need be.
> - Three unused reserved fields ready to be utilised in the event
> they're needed.

Either of these will work for easy classification.

> In other words, there's ample room for such contingency measures
> within the protocol.

I have a preference for explicit versioning, having dealt with some
protocol issues before.  However, I'm much less concerned with *how*
it's done than that it *be* done in the kernel patch so we can test out
 rolling the version number to change the algorithms in a backward
compatible way, so lets pick one of the above and try it out.

Regards,

James
