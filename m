Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:39133 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbeJUG7O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 02:59:14 -0400
Date: Sun, 21 Oct 2018 00:47:06 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v8 28/28] net: WireGuard secure network tunnel
Message-ID: <20181020224706.GC14816@lunn.ch>
References: <20181018145712.7538-1-Jason@zx2c4.com>
 <20181018145712.7538-29-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018145712.7538-29-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> +#define choose_node(parent, key)                                               \
> +	parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]

Hi Jason

This should be a function, not a macro.

> +
> +static void node_free_rcu(struct rcu_head *rcu)
> +{
> +	kfree(container_of(rcu, struct allowedips_node, rcu));
> +}
> +
> +#define push_rcu(stack, p, len) ({                                             \
> +		if (rcu_access_pointer(p)) {                                   \
> +			WARN_ON(IS_ENABLED(DEBUG) && (len) >= 128);            \
> +			stack[(len)++] = rcu_dereference_raw(p);               \
> +		}                                                              \
> +		true;                                                          \
> +	})

This also looks like it could be a function.

> +static void root_free_rcu(struct rcu_head *rcu)
> +{
> +	struct allowedips_node *node, *stack[128] = {
> +		container_of(rcu, struct allowedips_node, rcu) };
> +	unsigned int len = 1;
> +
> +	while (len > 0 && (node = stack[--len]) &&
> +	       push_rcu(stack, node->bit[0], len) &&
> +	       push_rcu(stack, node->bit[1], len))
> +		kfree(node);
> +}
> +
> +#define ref(p) rcu_access_pointer(p)
> +#define deref(p) rcu_dereference_protected(*(p), lockdep_is_held(lock))

Macros should be uppercase, or better still, functions.

> +#define push(p) ({                                                             \
> +		WARN_ON(IS_ENABLED(DEBUG) && len >= 128);                      \
> +		stack[len++] = p;                                              \
> +	})

This one definitely should be upper case, to warn readers it has
unexpected side effects.

> +
> +static void walk_remove_by_peer(struct allowedips_node __rcu **top,
> +				struct wg_peer *peer, struct mutex *lock)
> +{
> +	struct allowedips_node __rcu **stack[128], **nptr;
> +	struct allowedips_node *node, *prev;
> +	unsigned int len;
> +
> +	if (unlikely(!peer || !ref(*top)))
> +		return;
> +
> +	for (prev = NULL, len = 0, push(top); len > 0; prev = node) {
> +		nptr = stack[len - 1];
> +		node = deref(nptr);
> +		if (!node) {
> +			--len;
> +			continue;
> +		}
> +		if (!prev || ref(prev->bit[0]) == node ||
> +		    ref(prev->bit[1]) == node) {
> +			if (ref(node->bit[0]))
> +				push(&node->bit[0]);
> +			else if (ref(node->bit[1]))
> +				push(&node->bit[1]);
> +		} else if (ref(node->bit[0]) == prev) {
> +			if (ref(node->bit[1]))
> +				push(&node->bit[1]);
> +		} else {
> +			if (rcu_dereference_protected(node->peer,
> +				lockdep_is_held(lock)) == peer) {
> +				RCU_INIT_POINTER(node->peer, NULL);
> +				if (!node->bit[0] || !node->bit[1]) {
> +					rcu_assign_pointer(*nptr,
> +					deref(&node->bit[!ref(node->bit[0])]));
> +					call_rcu_bh(&node->rcu, node_free_rcu);
> +					node = deref(nptr);
> +				}
> +			}
> +			--len;
> +		}
> +	}
> +}
> +
> +#undef ref
> +#undef deref
> +#undef push
> +
> +static __always_inline unsigned int fls128(u64 a, u64 b)
> +{
> +	return a ? fls64(a) + 64U : fls64(b);
> +}

Does the compiler actually get this wrong? Not inline it?  There was
an interesting LWN post about this recently:

https://lwn.net/Articles/767884/

But in general, inline of any form should be avoided in .c files.

> +
> +static __always_inline u8 common_bits(const struct allowedips_node *node,
> +				      const u8 *key, u8 bits)
> +{
> +	if (bits == 32)
> +		return 32U - fls(*(const u32 *)node->bits ^ *(const u32 *)key);
> +	else if (bits == 128)
> +		return 128U - fls128(
> +			*(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
> +			*(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
> +	return 0;
> +}
> +
> +/* This could be much faster if it actually just compared the common bits
> + * properly, by precomputing a mask bswap(~0 << (32 - cidr)), and the rest, but
> + * it turns out that common_bits is already super fast on modern processors,
> + * even taking into account the unfortunate bswap. So, we just inline it like
> + * this instead.
> + */
> +#define prefix_matches(node, key, bits)                                        \
> +	(common_bits(node, key, bits) >= (node)->cidr)

Could be a function.

> +
> +static __always_inline struct allowedips_node *
> +find_node(struct allowedips_node *trie, u8 bits, const u8 *key)
> +{
> +	struct allowedips_node *node = trie, *found = NULL;
> +
> +	while (node && prefix_matches(node, key, bits)) {
> +		if (rcu_access_pointer(node->peer))
> +			found = node;
> +		if (node->cidr == bits)
> +			break;
> +		node = rcu_dereference_bh(choose_node(node, key));
> +	}
> +	return found;
> +}
> +
> +/* Returns a strong reference to a peer */
> +static __always_inline struct wg_peer *
> +lookup(struct allowedips_node __rcu *root, u8 bits, const void *be_ip)
> +{
> +	u8 ip[16] __aligned(__alignof(u64));

You virtually never see aligned stack variables. This needs some sort
of comment.

> +	struct allowedips_node *node;
> +	struct wg_peer *peer = NULL;
> +
> +	swap_endian(ip, be_ip, bits);
> +
> +	rcu_read_lock_bh();
> +retry:
> +	node = find_node(rcu_dereference_bh(root), bits, ip);
> +	if (node) {
> +		peer = wg_peer_get_maybe_zero(rcu_dereference_bh(node->peer));
> +		if (!peer)
> +			goto retry;
> +	}
> +	rcu_read_unlock_bh();
> +	return peer;
> +}
> +
> +__attribute__((nonnull(1))) static bool
> +node_placement(struct allowedips_node __rcu *trie, const u8 *key, u8 cidr,
> +	       u8 bits, struct allowedips_node **rnode, struct mutex *lock)
> +{
> +	struct allowedips_node *node = rcu_dereference_protected(trie,
> +						lockdep_is_held(lock));
> +	struct allowedips_node *parent = NULL;
> +	bool exact = false;

Should there be a WARN_ON(!key) here, since the attribute will only
detect problems at compile time, and maybe some runtime cases will get
passed it?

> +
> +	while (node && node->cidr <= cidr && prefix_matches(node, key, bits)) {
> +		parent = node;
> +		if (parent->cidr == cidr) {
> +			exact = true;
> +			break;
> +		}
> +		node = rcu_dereference_protected(choose_node(parent, key),
> +						 lockdep_is_held(lock));
> +	}
> +	*rnode = parent;
> +	return exact;
> +}
> +void wg_cookie_message_consume(struct message_handshake_cookie *src,
> +			       struct wg_device *wg)
> +{
> +	struct wg_peer *peer = NULL;
> +	u8 cookie[COOKIE_LEN];
> +	bool ret;
> +
> +	if (unlikely(!wg_index_hashtable_lookup(&wg->index_hashtable,
> +					     INDEX_HASHTABLE_HANDSHAKE |
> +					     INDEX_HASHTABLE_KEYPAIR,
> +					     src->receiver_index, &peer)))
> +		return;
> +
> +	down_read(&peer->latest_cookie.lock);
> +	if (unlikely(!peer->latest_cookie.have_sent_mac1)) {
> +		up_read(&peer->latest_cookie.lock);
> +		goto out;
> +	}
> +	ret = xchacha20poly1305_decrypt(
> +		cookie, src->encrypted_cookie, sizeof(src->encrypted_cookie),
> +		peer->latest_cookie.last_mac1_sent, COOKIE_LEN, src->nonce,
> +		peer->latest_cookie.cookie_decryption_key);
> +	up_read(&peer->latest_cookie.lock);
> +
> +	if (ret) {
> +		down_write(&peer->latest_cookie.lock);
> +		memcpy(peer->latest_cookie.cookie, cookie, COOKIE_LEN);
> +		peer->latest_cookie.birthdate = ktime_get_boot_fast_ns();
> +		peer->latest_cookie.is_valid = true;
> +		peer->latest_cookie.have_sent_mac1 = false;
> +		up_write(&peer->latest_cookie.lock);
> +	} else {
> +		net_dbg_ratelimited("%s: Could not decrypt invalid cookie response\n",
> +				    wg->dev->name);

It might be worth adding a netdev_dbg_ratelimited(), which takes a
netdev as its first parameter, just line netdev_dbg().

> +static int wg_open(struct net_device *dev)
> +{
> +	struct in_device *dev_v4 = __in_dev_get_rtnl(dev);
> +	struct inet6_dev *dev_v6 = __in6_dev_get(dev);
> +	struct wg_device *wg = netdev_priv(dev);
> +	struct wg_peer *peer;
> +	int ret;
> +
> +	if (dev_v4) {
> +		/* At some point we might put this check near the ip_rt_send_
> +		 * redirect call of ip_forward in net/ipv4/ip_forward.c, similar
> +		 * to the current secpath check.
> +		 */
> +		IN_DEV_CONF_SET(dev_v4, SEND_REDIRECTS, false);
> +		IPV4_DEVCONF_ALL(dev_net(dev), SEND_REDIRECTS) = false;
> +	}
> +	if (dev_v6)
> +		dev_v6->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_NONE;
> +
> +	ret = wg_socket_init(wg, wg->incoming_port);
> +	if (ret < 0)
> +		return ret;
> +	mutex_lock(&wg->device_update_lock);
> +	list_for_each_entry(peer, &wg->peer_list, peer_list) {
> +		wg_packet_send_staged_packets(peer);
> +		if (peer->persistent_keepalive_interval)
> +			wg_packet_send_keepalive(peer);
> +	}
> +	mutex_unlock(&wg->device_update_lock);
> +	return 0;
> +}
> +
> +#if defined(CONFIG_PM_SLEEP) && !defined(CONFIG_ANDROID)

I don't see any other code which uses this combination. Why is this
needed?

> +static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct wg_device *wg = netdev_priv(dev);
> +	struct sk_buff_head packets;
> +	struct wg_peer *peer;
> +	struct sk_buff *next;
> +	sa_family_t family;
> +	u32 mtu;
> +	int ret;
> +
> +	if (unlikely(wg_skb_examine_untrusted_ip_hdr(skb) != skb->protocol)) {
> +		ret = -EPROTONOSUPPORT;
> +		net_dbg_ratelimited("%s: Invalid IP packet\n", dev->name);
> +		goto err;
> +	}
> +
> +	peer = wg_allowedips_lookup_dst(&wg->peer_allowedips, skb);
> +	if (unlikely(!peer)) {
> +		ret = -ENOKEY;
> +		if (skb->protocol == htons(ETH_P_IP))
> +			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI4\n",
> +					    dev->name, &ip_hdr(skb)->daddr);
> +		else if (skb->protocol == htons(ETH_P_IPV6))
> +			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI6\n",
> +					    dev->name, &ipv6_hdr(skb)->daddr);
> +		goto err;
> +	}
> +
> +	family = READ_ONCE(peer->endpoint.addr.sa_family);
> +	if (unlikely(family != AF_INET && family != AF_INET6)) {
> +		ret = -EDESTADDRREQ;
> +		net_dbg_ratelimited("%s: No valid endpoint has been configured or discovered for peer %llu\n",
> +				    dev->name, peer->internal_id);
> +		goto err_peer;
> +	}
> +
> +	mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
> +
> +	__skb_queue_head_init(&packets);
> +	if (!skb_is_gso(skb)) {
> +		skb->next = NULL;
> +	} else {
> +		struct sk_buff *segs = skb_gso_segment(skb, 0);
> +
> +		if (unlikely(IS_ERR(segs))) {
> +			ret = PTR_ERR(segs);
> +			goto err_peer;
> +		}
> +		dev_kfree_skb(skb);
> +		skb = segs;
> +	}
> +	do {
> +		next = skb->next;
> +		skb->next = skb->prev = NULL;
> +
> +		skb = skb_share_check(skb, GFP_ATOMIC);
> +		if (unlikely(!skb))
> +			continue;
> +
> +		/* We only need to keep the original dst around for icmp,
> +		 * so at this point we're in a position to drop it.
> +		 */
> +		skb_dst_drop(skb);
> +
> +		PACKET_CB(skb)->mtu = mtu;
> +
> +		__skb_queue_tail(&packets, skb);
> +	} while ((skb = next) != NULL);
> +
> +	spin_lock_bh(&peer->staged_packet_queue.lock);
> +	/* If the queue is getting too big, we start removing the oldest packets
> +	 * until it's small again. We do this before adding the new packet, so
> +	 * we don't remove GSO segments that are in excess.
> +	 */
> +	while (skb_queue_len(&peer->staged_packet_queue) > MAX_STAGED_PACKETS)
> +		dev_kfree_skb(__skb_dequeue(&peer->staged_packet_queue));

It would be good to have some stats counters in here. Maybe the
standard interface statistics will cover it, otherwise ethtool -S.

You should also get this code looked at by some of the queueing
people. Rather than discarding, you might want to be applying back
pressure to slow down the sender application?

> +static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
> +		size_t first_len, size_t second_len, size_t third_len,
> +		size_t data_len, const u8 chaining_key[NOISE_HASH_LEN])
> +{
> +	u8 output[BLAKE2S_HASH_SIZE + 1];
> +	u8 secret[BLAKE2S_HASH_SIZE];
> +
> +	WARN_ON(IS_ENABLED(DEBUG) &&
> +		(first_len > BLAKE2S_HASH_SIZE ||
> +		 second_len > BLAKE2S_HASH_SIZE ||
> +		 third_len > BLAKE2S_HASH_SIZE ||
> +		 ((second_len || second_dst || third_len || third_dst) &&
> +		  (!first_len || !first_dst)) ||
> +		 ((third_len || third_dst) && (!second_len || !second_dst))));

Maybe split this up into a number of WARN_ON()s. At the moment, if it
fires, you have little idea why, there are so many comparisons. Also,
is this on the hot path? I guess not, since this is keys, not
packets. Do you need to care about DEBUG here?

	 Andrew
