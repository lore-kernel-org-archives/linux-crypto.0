From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v5 20/20] net: WireGuard secure network tunnel
Date: Wed, 19 Sep 2018 01:34:11 +0200
Message-ID: <20180918233411.GB17466@lunn.ch>
References: <20180918161646.19105-1-Jason@zx2c4.com>
 <20180918161646.19105-21-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918161646.19105-21-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> +#define push_rcu(stack, p, len) ({                                             \
> +		if (rcu_access_pointer(p)) {                                   \
> +			BUG_ON(len >= 128);                                    \
> +			stack[len++] = rcu_dereference_raw(p);                 \
> +		}                                                              \
> +		true;                                                          \
> +	})
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

Hi Jason

I see this BUG_ON() is still here. It really needs to be removed. It
does not look like you need to crash the kernel here. Can you add in a
test of len >= 128, do a WARN and then return. I think you then leak
some memory, but i would much prefer that to a crashed machine.

     Andrew
