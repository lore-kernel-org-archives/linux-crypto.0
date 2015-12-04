From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rockchip/crypto - fix possible deadlock
Date: Fri, 4 Dec 2015 22:41:08 +0800
Message-ID: <20151204144108.GB17703@gondor.apana.org.au>
References: <4447448.4Xqd6iKNVk@diego>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Zain Wang <zain.wang@rock-chips.com>,
	linux-crypto@vger.kernel.org, linux-rockchip@lists.infradead.org
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35292 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbbLDOlT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:41:19 -0500
Content-Disposition: inline
In-Reply-To: <4447448.4Xqd6iKNVk@diego>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 28, 2015 at 01:27:48PM +0100, Heiko St=FCbner wrote:
> Lockdep warns about a possible deadlock resulting from the use of reg=
ular
> spin_locks:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 4.4.0-rc2+ #2724 Not tainted
> ---------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> ksoftirqd/0/3 [HC0[0]:SC1[1]:HE1:SE0] takes:
> (&(&crypto_info->lock)->rlock){+.?...}, at: [<bf14a65c>] rk_crypto_ta=
sklet_cb+0x24/0xb4 [rk_crypto]
> {SOFTIRQ-ON-W} state was registered at:
>   [<c007f4ac>] lock_acquire+0x178/0x218
>   [<c0759bac>] _raw_spin_lock+0x54/0x64
>   [<bf14af88>] rk_handle_req+0x7c/0xbc [rk_crypto]
>   [<bf14b040>] rk_des_ecb_encrypt+0x2c/0x30 [rk_crypto]
>   [<bf14b05c>] rk_aes_ecb_encrypt+0x18/0x1c [rk_crypto]
>   [<c028c820>] skcipher_encrypt_ablkcipher+0x64/0x68
>   [<c0290770>] __test_skcipher+0x2a8/0x8dc
>   [<c0292e94>] test_skcipher+0x38/0xc4
>   [<c0292fb0>] alg_test_skcipher+0x90/0xb0
>   [<c0292158>] alg_test+0x1e8/0x280
>   [<c028f6f4>] cryptomgr_test+0x34/0x54
>   [<c004bbe8>] kthread+0xf4/0x10c
>   [<c0010010>] ret_from_fork+0x14/0x24
> irq event stamp: 10672
> hardirqs last  enabled at (10672): [<c002fac8>] tasklet_action+0x48/0=
x104
> hardirqs last disabled at (10671): [<c002faa0>] tasklet_action+0x20/0=
x104
> softirqs last  enabled at (10658): [<c002ef84>] __do_softirq+0x358/0x=
49c
> softirqs last disabled at (10669): [<c002f108>] run_ksoftirqd+0x40/0x=
80
>=20
> other info that might help us debug this:
> Possible unsafe locking scenario:
>=20
>     CPU0
>     ----
>   lock(&(&crypto_info->lock)->rlock);
>   <Interrupt>
>     lock(&(&crypto_info->lock)->rlock);
>=20
>  *** DEADLOCK ***
>=20
> Fix this by moving to irq-disabling spinlocks.
>=20
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> changes in v2:
> - don't use irqsave spinlock in the irq-handler itself

Patch applied.  Thanks.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
