From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips
 with slow unaligned access
Date: Mon, 7 Nov 2016 11:25:05 -0800
Message-ID: <20161107192505.GB34388@google.com>
References: <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
 <20161103004934.GA30775@gondor.apana.org.au>
 <CAHmME9oL-pOWWXXFhJz1vSm5ftnSfmYrquGbH0acapgEL=c4Ew@mail.gmail.com>
 <20161103.130852.1456848512897088071.davem@davemloft.net>
 <CAHmME9pm4DHuBsE+hoFxnm1B5OWAZ+OyKXzeKDxHtisZpw4ebg@mail.gmail.com>
 <20161104173723.GB34176@google.com>
 <CAHmME9oejs+USiGJX2P0TgvnR6XRzV1HYZPrq=c-CjGzq59=NQ@mail.gmail.com>
 <20161107182646.GA34388@google.com>
 <CAHmME9rzBST8Lqapzykwf2rUyxLXuyOF0wX+Sy259Qtx9a4YSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
 WireGuard mailing list <wireguard@lists.zx2c4.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <wireguard-bounces@lists.zx2c4.com>
Content-Disposition: inline
In-Reply-To: <CAHmME9rzBST8Lqapzykwf2rUyxLXuyOF0wX+Sy259Qtx9a4YSg@mail.gmail.com>
List-Unsubscribe: <http://lists.zx2c4.com/mailman/options/wireguard>,
 <mailto:wireguard-request@lists.zx2c4.com?subject=unsubscribe>
List-Archive: <http://lists.zx2c4.com/pipermail/wireguard/>
List-Post: <mailto:wireguard@lists.zx2c4.com>
List-Help: <mailto:wireguard-request@lists.zx2c4.com?subject=help>
List-Subscribe: <http://lists.zx2c4.com/mailman/listinfo/wireguard>,
 <mailto:wireguard-request@lists.zx2c4.com?subject=subscribe>
Errors-To: wireguard-bounces@lists.zx2c4.com
Sender: "WireGuard" <wireguard-bounces@lists.zx2c4.com>
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 07, 2016 at 08:02:35PM +0100, Jason A. Donenfeld wrote:
> On Mon, Nov 7, 2016 at 7:26 PM, Eric Biggers <ebiggers@google.com> wrote:
> >
> > I was not referring to any users in particular, only what users could do.  As an
> > example, if you did crypto_shash_update() with 32, 15, then 17 bytes, and the
> > underlying algorithm is poly1305-generic, the last block would end up
> > misaligned.  This doesn't appear possible with your pseudocode because it only
> > passes in multiples of the block size until the very end.  However I don't see
> > it claimed anywhere that shash API users have to do that.
> 
> Actually it appears that crypto/poly1305_generic.c already buffers
> incoming blocks to a buffer that definitely looks aligned, to prevent
> this condition!
> 

No it does *not* buffer all incoming blocks, which is why the source pointer can
fall out of alignment.  Yes, I actually tested this.  In fact this situation is
even hit, in both possible places, in the self-tests.

Eric
