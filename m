Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:47621 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbeJYXQj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 19:16:39 -0400
MIME-Version: 1.0
References: <20181018145712.7538-1-Jason@zx2c4.com> <20181018145712.7538-29-Jason@zx2c4.com>
 <20181020224706.GC14816@lunn.ch>
In-Reply-To: <20181020224706.GC14816@lunn.ch>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 25 Oct 2018 16:43:15 +0200
Message-ID: <CAHmME9qMf=n7mnE-bsx86SVFBs1LrvHoc+nWrpr12vtYAgze+g@mail.gmail.com>
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
To: Andrew Lunn <andrew@lunn.ch>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andrew,

Thanks for the review. Comments and fix links are inline below.

On Sun, Oct 21, 2018 at 12:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +#define choose_node(parent, key)                                               \
> > +     parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]
> This should be a function, not a macro.

That prevents it from being used as an lvalue, which is mostly where
it's used, with the rcu-protected structure, so this will remain a
macro. I'll make it upper-case though.

> > +
> > +static void node_free_rcu(struct rcu_head *rcu)
> > +{
> > +     kfree(container_of(rcu, struct allowedips_node, rcu));
> > +}
> > +
> > +#define push_rcu(stack, p, len) ({                                             \
> > +             if (rcu_access_pointer(p)) {                                   \
> > +                     WARN_ON(IS_ENABLED(DEBUG) && (len) >= 128);            \
> > +                     stack[(len)++] = rcu_dereference_raw(p);               \
> > +             }                                                              \
> > +             true;                                                          \
> > +     })
>
> This also looks like it could be a function.

You're right. I've changed this now. That produces slightly worse code
on gcc 8.2, but that's not really hot path anyway, so it doesn't
matter.

> > +static void root_free_rcu(struct rcu_head *rcu)
> > +{
> > +     struct allowedips_node *node, *stack[128] = {
> > +             container_of(rcu, struct allowedips_node, rcu) };
> > +     unsigned int len = 1;
> > +
> > +     while (len > 0 && (node = stack[--len]) &&
> > +            push_rcu(stack, node->bit[0], len) &&
> > +            push_rcu(stack, node->bit[1], len))
> > +             kfree(node);
> > +}
> > +
> > +#define ref(p) rcu_access_pointer(p)
> > +#define deref(p) rcu_dereference_protected(*(p), lockdep_is_held(lock))
>
> Macros should be uppercase, or better still, functions.
>
> > +#define push(p) ({                                                             \
> > +             WARN_ON(IS_ENABLED(DEBUG) && len >= 128);                      \
> > +             stack[len++] = p;                                              \
> > +     })
>
> This one definitely should be upper case, to warn readers it has
> unexpected side effects.

I've made these little helper macros uppercase.

>
> > +
> > +static void walk_remove_by_peer(struct allowedips_node __rcu **top,
> > +                             struct wg_peer *peer, struct mutex *lock)
> > +{
> > +     struct allowedips_node __rcu **stack[128], **nptr;
> > +     struct allowedips_node *node, *prev;
> > +     unsigned int len;
> > +
> > +     if (unlikely(!peer || !ref(*top)))
> > +             return;
> > +
> > +     for (prev = NULL, len = 0, push(top); len > 0; prev = node) {
> > +             nptr = stack[len - 1];
> > +             node = deref(nptr);
> > +             if (!node) {
> > +                     --len;
> > +                     continue;
> > +             }
> > +             if (!prev || ref(prev->bit[0]) == node ||
> > +                 ref(prev->bit[1]) == node) {
> > +                     if (ref(node->bit[0]))
> > +                             push(&node->bit[0]);
> > +                     else if (ref(node->bit[1]))
> > +                             push(&node->bit[1]);
> > +             } else if (ref(node->bit[0]) == prev) {
> > +                     if (ref(node->bit[1]))
> > +                             push(&node->bit[1]);
> > +             } else {
> > +                     if (rcu_dereference_protected(node->peer,
> > +                             lockdep_is_held(lock)) == peer) {
> > +                             RCU_INIT_POINTER(node->peer, NULL);
> > +                             if (!node->bit[0] || !node->bit[1]) {
> > +                                     rcu_assign_pointer(*nptr,
> > +                                     deref(&node->bit[!ref(node->bit[0])]));
> > +                                     call_rcu_bh(&node->rcu, node_free_rcu);
> > +                                     node = deref(nptr);
> > +                             }
> > +                     }
> > +                     --len;
> > +             }
> > +     }
> > +}
> > +
> > +#undef ref
> > +#undef deref
> > +#undef push
> > +
> > +static __always_inline unsigned int fls128(u64 a, u64 b)
> > +{
> > +     return a ? fls64(a) + 64U : fls64(b);
> > +}
>
> Does the compiler actually get this wrong? Not inline it?

Actually for this function (in contrast with all of the other ones
marked as such, which really must have the annotation), recent gcc
gets it right, so I've removed the annotation. Nice catch.

> > +
> > +static __always_inline u8 common_bits(const struct allowedips_node *node,
> > +                                   const u8 *key, u8 bits)
> > +{
> > +     if (bits == 32)
> > +             return 32U - fls(*(const u32 *)node->bits ^ *(const u32 *)key);
> > +     else if (bits == 128)
> > +             return 128U - fls128(
> > +                     *(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
> > +                     *(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
> > +     return 0;
> > +}
> > +
> > +/* This could be much faster if it actually just compared the common bits
> > + * properly, by precomputing a mask bswap(~0 << (32 - cidr)), and the rest, but
> > + * it turns out that common_bits is already super fast on modern processors,
> > + * even taking into account the unfortunate bswap. So, we just inline it like
> > + * this instead.
> > + */
> > +#define prefix_matches(node, key, bits)                                        \
> > +     (common_bits(node, key, bits) >= (node)->cidr)
>
> Could be a function.

I've made this a function now and confirmed codegen did not change
significantly.

> > +/* Returns a strong reference to a peer */
> > +static __always_inline struct wg_peer *
> > +lookup(struct allowedips_node __rcu *root, u8 bits, const void *be_ip)
> > +{
> > +     u8 ip[16] __aligned(__alignof(u64));
>
> You virtually never see aligned stack variables. This needs some sort
> of comment.

I've added a comment. The reason, if you're curious, is so that we can
pass it to fls64 on all platforms.

> > +__attribute__((nonnull(1))) static bool
> > +node_placement(struct allowedips_node __rcu *trie, const u8 *key, u8 cidr,
> > +            u8 bits, struct allowedips_node **rnode, struct mutex *lock)
> > +{
> > +     struct allowedips_node *node = rcu_dereference_protected(trie,
> > +                                             lockdep_is_held(lock));
> > +     struct allowedips_node *parent = NULL;
> > +     bool exact = false;
>
> Should there be a WARN_ON(!key) here, since the attribute will only
> detect problems at compile time, and maybe some runtime cases will get
> passed it?

Actually no, it's only used in one place, and that function is pretty
clear about checking beforehand, and even this function checks
implicitly. Looking at my commit log, I had added the annotation to
make clang-analyzer happy, because it couldn't (at the time) deduce
things correctly from rcu_access_pointer(p) checks. It looks like
recent clang-analyzer has fixed that, and besides I'm not sure the
kernel is in the business of adding annotations to work around
static-analyzer-bug-of-the-week. So I've gotten rid of the annotation.
Thanks for bringing my attention to it.

> > +             net_dbg_ratelimited("%s: Could not decrypt invalid cookie response\n",
> > +                                 wg->dev->name);
>
> It might be worth adding a netdev_dbg_ratelimited(), which takes a
> netdev as its first parameter, just line netdev_dbg().

That sounds like it could be useful. Though, I'm trying hard to make
the first patch submission _not_ need to touch any of the rest of the
networking stack. I've actually got a small list of interesting
networking stack changes that might be useful for WireGuard, but I
think I'd prefer to submit these after this is all merged, and each
one separately for a separate discussion, if that's okay with you.


> > +
> > +#if defined(CONFIG_PM_SLEEP) && !defined(CONFIG_ANDROID)
>
> I don't see any other code which uses this combination. Why is this
> needed?

WireGuard clears private key material before going to sleep, so that
ephemeral keys never live longer in ram than their expiration date.
This works well for mostly everything, except Android devices where
crazy out-of-tree wireless drivers (such as qcacld) will actually wake
and sleep the phone constantly, for a few milliseconds each wake, to
handle incoming packets. In this case, we must not zero out ephemeral
keys, so that these packets can actually be decrypted. There are no
other systems that have this characteristic, as far as I can tell, and
I'm certainly not willing to add a runtime configuration nob for that,
and it turns out that matching on CONFIG_ANDROID as such does the
right thing all of the time. If the landscape becomes more
complicated, we can visit it, probably in the form of passing reasons
through to pm_notification and related scaffolding. But in lieu of
this infrastructure someday existing, I prefer to do the
simple-and-always-works-anyway solution.

> > +     while (skb_queue_len(&peer->staged_packet_queue) > MAX_STAGED_PACKETS)
> > +             dev_kfree_skb(__skb_dequeue(&peer->staged_packet_queue));
>
> It would be good to have some stats counters in here. Maybe the
> standard interface statistics will cover it, otherwise ethtool -S.

Good point, I need to increment the drop counters there. I'll add
that; good catch.

Willy and I actually discussed around a year ago adding a series of
wireguard-specific error counters for all the various unusual things
that can happen. This is something I'll probably investigate in
earnest post-merge, as it's a bit of a "bell and whistle" thing, and
the existing counters now are already sufficient for most purposes.

> You should also get this code looked at by some of the queueing
> people. Rather than discarding, you might want to be applying back
> pressure to slow down the sender application?

Actually Toke, DaveT, and I have agonized quite a bit over the
queueing mechanisms in WireGuard, as well as two GSoC summers looking
at it with students. There's been lots of flent and rrul and tweaking
involved, and the entire queueing system has gone through probably 15
different revisions of trying things out and experimenting. At this
point, I think the way we're doing queueing and when we're dropping,
and those various factors, are taken care of pretty well. Future work
still involves considering shoehorning some fq_codel in a similar way
that wireless does, and a few other tweeks, but I think the current
system is good and stable and very much sufficient.

The particular instance you're pointing out though, with
staged_packet_queue, is not the relevant queue and isn't what you have
in mind with regards to backpressure. This is simply a very short
lived thing for dealing with packets before a handshake is made, and
for handling xmit being used from multiple cores, but it's not _the_
queueing system that's relevant in the actual buffering and latency
calculations.

A little bit of the queueing stuff is discussed in the paper I
presented at Netdev 2.2, if you're interested:
https://www.wireguard.com/papers/wireguard-netdev22.pdf Some of that
is outdated by now, but should give you some idea.

> > +static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
> > +             size_t first_len, size_t second_len, size_t third_len,
> > +             size_t data_len, const u8 chaining_key[NOISE_HASH_LEN])
> > +{
> > +     u8 output[BLAKE2S_HASH_SIZE + 1];
> > +     u8 secret[BLAKE2S_HASH_SIZE];
> > +
> > +     WARN_ON(IS_ENABLED(DEBUG) &&
> > +             (first_len > BLAKE2S_HASH_SIZE ||
> > +              second_len > BLAKE2S_HASH_SIZE ||
> > +              third_len > BLAKE2S_HASH_SIZE ||
> > +              ((second_len || second_dst || third_len || third_dst) &&
> > +               (!first_len || !first_dst)) ||
> > +              ((third_len || third_dst) && (!second_len || !second_dst))));
>
> Maybe split this up into a number of WARN_ON()s. At the moment, if it
> fires, you have little idea why, there are so many comparisons. Also,
> is this on the hot path? I guess not, since this is keys, not
> packets. Do you need to care about DEBUG here?

This is on the hot path, actually. Well, it's not on path of data
packets, but I do consider handshake packets to be fairly "warm". I'm
not especially keen on splitting that up into multiple warn_ons,
mostly because if that is ever hint, something is seriously wrong, and
the whole flow would likely then need auditing anyway.

Regards,
Jason
