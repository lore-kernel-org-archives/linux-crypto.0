From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 0/3] WireGuard: Secure Network Tunnel
Date: Mon, 13 Aug 2018 10:02:32 -0700
Message-ID: <CAHmME9raa81A_hH_Zykp2r8zOk0ySroFEsk+8384vnVOCuSa=g@mail.gmail.com>
References: <20180731191102.2434-1-Jason@zx2c4.com> <1534174811.7872.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1534174811.7872.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

On 8/13/18, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
>> Ample information, including documentation, installation
>> instructions,
>> and project details, is available at:
>>
>>   * https://www.wireguard.com/
>>   * https://www.wireguard.com/papers/wireguard.pdf
>
> In your paper you say this:
>
>> Finally, WireGuard is cryptographically opinionated. It intentionally
>> lacks cipher and protocol agility. If
>> holes are found in the underlying primitives, all endpoints will be
>> required to update.
>
> The only thing that's certain (beyond death and taxes) is that your
> crypto choice will one day need updating; either in response to an
> urgent CVE because an algorithm is compromised or in response to a less
> urgent one because it is deprecated.  Assuming wireguard is reasonably
> successful we'll have a large ecosystem dependent on it.  On this day,
> we're going to have the choice of either breaking the entire ecosystem
> by rolling out a change that can't connect to lower protocol versions
> or trying to wedge version agility into wireguard in a hurry.  The
> former is too awful to contemplate because of the almost universal
> ecosystem breakage it would cause and the latter is going to lead to
> additional bugs because people in a hurry aren't as careful as they
> should be.
>
> Could we please build planning for this crypto failure day into
> wireguard now rather than have to do it later?  It doesn't need to be
> full cipher agility, it just needs to be the ability to handle multiple
> protocol versions ... two should do it because that gives a template to
> follow (and test version to try to find bugs in the implementation).
> It looks like the protocol could simply be updated to put the version
> into one (or more) of the three reserved bytes in the handshake
> headers, so perhaps doing this before they get used for something else
> would be a good first step?
>
> James
>
>

Indeed the answer is in fact along the lines of what you've suggested
in your question: the protocol is very strictly versioned. This means
that while there intentionally isn't negotiation of ciphers --
something historically very bug-prone -- there is ample room for
updating the protocol. This is enabled via 4 aspects of the protocol:

- An explicit "identifier" string is hashed in as part of the first
step of cryptographic operations, containing a "v1" as well as the
protocol designer's email.
- An explicit "construction" string is hashed in as part of the first
step of cryptographic operations, containing the Noise handshake
pattern and a list of the cryptographic primitives used.
- A type field at the beginning of each message. Newer message types
(corresponding with newer versions) can easily be introduced via this
field, and they can even coexist with older ones need be.
- Three unused reserved fields ready to be utilised in the event they're needed.

In other words, there's ample room for such contingency measures
within the protocol.

Jason
