From: David Miller <davem@davemloft.net>
Subject: Re: [Crypto v4 01/12] tls: tls_device struct to register TLS
 drivers
Date: Mon, 12 Feb 2018 14:45:16 -0500 (EST)
Message-ID: <20180212.144516.999297130875943550.davem@davemloft.net>
References: <1518437028-14250-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davejwatson@fb.com, herbert@gondor.apana.org.au,
        sd@queasysnail.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, ganeshgr@chelsio.com
To: atul.gupta@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57192 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeBLTpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 14:45:19 -0500
In-Reply-To: <1518437028-14250-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Mon, 12 Feb 2018 17:33:48 +0530

> +	/* When calling get_netdev, the HW vendor's driver should return the
> +	 * net device of device @device at port @port_num or NULL if such
> +	 * a net device doesn't exist
> +	 */
> +	struct net_device *(*netdev)(struct tls_device *device,
> +				     struct net_device *netdev);

I do not see a "port_num" parameter or structure member anywhere.

Please update this comment to match reality.

Thank you.
