From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips
 with slow unaligned access
Date: Mon, 7 Nov 2016 19:08:22 +0100
Message-ID: <CAHmME9oejs+USiGJX2P0TgvnR6XRzV1HYZPrq=c-CjGzq59=NQ@mail.gmail.com>
References: <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
 <20161103004934.GA30775@gondor.apana.org.au>
 <CAHmME9oL-pOWWXXFhJz1vSm5ftnSfmYrquGbH0acapgEL=c4Ew@mail.gmail.com>
 <20161103.130852.1456848512897088071.davem@davemloft.net>
 <CAHmME9pm4DHuBsE+hoFxnm1B5OWAZ+OyKXzeKDxHtisZpw4ebg@mail.gmail.com>
 <20161104173723.GB34176@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
 WireGuard mailing list <wireguard@lists.zx2c4.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <wireguard-bounces@lists.zx2c4.com>
In-Reply-To: <20161104173723.GB34176@google.com>
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

Hi Eric,

On Fri, Nov 4, 2016 at 6:37 PM, Eric Biggers <ebiggers@google.com> wrote:
> I agree, and the current code is wrong; but do note that this proposal is
> correct for poly1305_setrkey() but not for poly1305_setskey() and
> poly1305_blocks().  In the latter two cases, 4-byte alignment of the source
> buffer is *not* guaranteed.  Although crypto_poly1305_update() will be called
> with a 4-byte aligned buffer due to the alignmask set on poly1305_alg, the
> algorithm operates on 16-byte blocks and therefore has to buffer partial blocks.
> If some number of bytes that is not 0 mod 4 is buffered, then the buffer will
> fall out of alignment on the next update call.  Hence, get_unaligned_le32() is
> actually needed on all the loads, since the buffer will, in general, be of
> unknown alignment.

Hmm... The general data flow that strikes me as most pertinent is
something like:

struct sk_buff *skb = get_it_from_somewhere();
skb = skb_share_check(skb, GFP_ATOMIC);
num_frags = skb_cow_data(skb, ..., ...);
struct scatterlist sg[num_frags];
sg_init_table(sg, num_frags);
skb_to_sgvec(skb, sg, ..., ...);
blkcipher_walk_init(&walk, sg, sg, len);
blkcipher_walk_virt_block(&desc, &walk, BLOCK_SIZE);
while (walk.nbytes >= BLOCK_SIZE) {
    size_t chunk_len = rounddown(walk.nbytes, BLOCK_SIZE);
    poly1305_update(&poly1305_state, walk.src.virt.addr, chunk_len);
    blkcipher_walk_done(&desc, &walk, walk.nbytes % BLOCK_SIZE);
}
if (walk.nbytes) {
    poly1305_update(&poly1305_state, walk.src.virt.addr, walk.nbytes);
    blkcipher_walk_done(&desc, &walk, 0);
}

Is your suggestion that that in the final if block, walk.src.virt.addr
might be unaligned? Like in the case of the last fragment being 67
bytes long?

If so, what a hassle. I hope the performance overhead isn't too
awful... I'll resubmit taking into account your suggestions.

By the way -- offlist benchmarks sent to me concluded that using the
unaligned load helpers like David suggested is just as fast as that
handrolled bit magic in the v1.

Regards,
Jason
