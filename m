From: David Miller <davem@davemloft.net>
Subject: Re: [Crypto v4 03/12] support for inline tls
Date: Mon, 12 Feb 2018 14:48:35 -0500 (EST)
Message-ID: <20180212.144835.1319578385440687217.davem@davemloft.net>
References: <1518437068-14338-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davejwatson@fb.com, herbert@gondor.apana.org.au,
        sd@queasysnail.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, ganeshgr@chelsio.com
To: atul.gupta@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbeBLTsi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 14:48:38 -0500
In-Reply-To: <1518437068-14338-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Mon, 12 Feb 2018 17:34:28 +0530

> +static int get_tls_prot(struct sock *sk)
> +{
> +	struct tls_context *ctx = tls_get_ctx(sk);
> +	struct net_device *netdev;
> +	struct tls_device *dev;
> +
> +	/* Device bound to specific IP */
> +	if (inet_sk(sk)->inet_rcv_saddr) {
> +		netdev = find_netdev(sk);
> +		if (!netdev)
> +			goto out;
> +
> +		/* Device supports Inline record processing */
> +		if (!(netdev->features & NETIF_F_HW_TLS_INLINE))
> +			goto out;
> +
> +		mutex_lock(&device_mutex);
> +		list_for_each_entry(dev, &device_list, dev_list) {
> +			if (dev->netdev && dev->netdev(dev, netdev))
> +				break;
> +		}
> +		mutex_unlock(&device_mutex);
> +
> +		ctx->tx_conf = TLS_FULL_HW;
> +		if (dev->prot)
> +			dev->prot(dev, sk);

What if the same IP address is configured on multiple interfaces?

> +	} else { /* src address not known or INADDR_ANY */
> +		mutex_lock(&device_mutex);
> +		list_for_each_entry(dev, &device_list, dev_list) {
> +			if (dev->feature && dev->feature(dev)) {
> +				ctx->tx_conf = TLS_FULL_HW;
> +				break;
> +			}
> +		}
> +		mutex_unlock(&device_mutex);
> +		update_sk_prot(sk, ctx);

And I think this is even more of a stretch.  Just because you find
an inline TLS device on the global list doesn't mean traffic will
necessarily flow through it once the connection is fully established
and therefore be able to provide inline TLS offloading.
