From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [Crypto v4 03/12] support for inline tls
Date: Tue, 13 Feb 2018 18:20:00 +0000
Message-ID: <MWHPR1201MB0238D7D725C4621B6772A09597F60@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1518437068-14338-1-git-send-email-atul.gupta@chelsio.com>
 <20180212.144835.1319578385440687217.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "davejwatson@fb.com" <davejwatson@fb.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ganesh GR <ganeshgr@chelsio.com>
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0096.outbound.protection.outlook.com ([104.47.36.96]:62592
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965378AbeBMSUD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 13:20:03 -0500
In-Reply-To: <20180212.144835.1319578385440687217.davem@davemloft.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: David Miller [mailto:davem@davemloft.net]=20
Sent: Tuesday, February 13, 2018 1:19 AM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: davejwatson@fb.com; herbert@gondor.apana.org.au; sd@queasysnail.net; li=
nux-crypto@vger.kernel.org; netdev@vger.kernel.org; Ganesh GR <ganeshgr@che=
lsio.com>
Subject: Re: [Crypto v4 03/12] support for inline tls

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Mon, 12 Feb 2018 17:34:28 +0530

> +static int get_tls_prot(struct sock *sk) {
> +	struct tls_context *ctx =3D tls_get_ctx(sk);
> +	struct net_device *netdev;
> +	struct tls_device *dev;
> +
> +	/* Device bound to specific IP */
> +	if (inet_sk(sk)->inet_rcv_saddr) {
> +		netdev =3D find_netdev(sk);
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
> +		ctx->tx_conf =3D TLS_FULL_HW;
> +		if (dev->prot)
> +			dev->prot(dev, sk);

What if the same IP address is configured on multiple interfaces?

Thanks, I overlooked this point.
The checks above were based on the premise that device chosen is indeed the=
 one with Inline TLS enabled, net_device corresponding to specific IP addre=
ss, feature configured for device from ethtool and net_device corresponds t=
o Inline TLS driver registered with net tls.

Case with same IP configured on multiple interface looks similar to INADDR_=
ANY below.=20

The TLS_FULL_HW and modified hash routines handles devices with/without Inl=
ine TLS support. The first Inline TLS capable device updates sk_prot for TL=
S_FULL_HW. The tls_hw_hash listens on all interfaces and process device spe=
cific routine, the listen however succeeds for device on which connect is i=
nitiated and may not have the Inline TLS capability, such connection contin=
ues in TLS_BASE_TX or non-tls-offload mode. On the other hand, if Inline TL=
S capable device were to establish connection it updates the prot as requir=
ed for offload mode to continue.

> +	} else { /* src address not known or INADDR_ANY */
> +		mutex_lock(&device_mutex);
> +		list_for_each_entry(dev, &device_list, dev_list) {
> +			if (dev->feature && dev->feature(dev)) {
> +				ctx->tx_conf =3D TLS_FULL_HW;
> +				break;
> +			}
> +		}
> +		mutex_unlock(&device_mutex);
> +		update_sk_prot(sk, ctx);

And I think this is even more of a stretch.  Just because you find an inlin=
e TLS device on the global list doesn't mean traffic will necessarily flow =
through it once the connection is fully established and therefore be able t=
o provide inline TLS offloading.
