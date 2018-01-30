From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Tue, 30 Jan 2018 06:51:46 +0000
Message-ID: <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ganeshgr@chelsio.co" <ganeshgr@chelsio.co>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Boris Pismenny" <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Dave Watson <davejwatson@fb.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0115.outbound.protection.outlook.com ([104.47.36.115]:27136
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751631AbeA3Gvt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 01:51:49 -0500
In-Reply-To: <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

@Dave Watson, Did you get chance to look at my response?

What I was referring is that passing "tls" ulp type in setsockopt may be in=
sufficient to make the decision when multi HW assist Inline TLS solution ex=
ists.
Some HW may go beyond defining sendmsg/sendpage of the prot and require add=
itional info to setup the env? Also, we need to keep vendor specific code o=
ut of tls_main.c i.e anything other than base/sw_tx prot perhaps go to hw d=
river.

Sabrina echoed similar concern early last week, can we discuss or have thou=
ghts how to address this?

Thanks
Atul

-----Original Message-----
From: Atul Gupta=20
Sent: Sunday, January 28, 2018 11:26 AM
To: 'Dave Watson' <davejwatson@fb.com>
Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; ganeshgr@che=
lsio.co; netdev@vger.kernel.org; davem@davemloft.net; Boris Pismenny <boris=
p@mellanox.com>; Ilya Lesokhin <ilyal@mellanox.com>
Subject: RE: [RFC crypto v3 8/9] chtls: Register the ULP



-----Original Message-----
From: Dave Watson [mailto:davejwatson@fb.com]=20
Sent: Friday, January 26, 2018 2:39 AM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; ganeshgr@che=
lsio.co; netdev@vger.kernel.org; davem@davemloft.net; Boris Pismenny <boris=
p@mellanox.com>; Ilya Lesokhin <ilyal@mellanox.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP

<1513769897-26945-1-git-send-email-atul.gupta@chelsio.com>

On 12/20/17 05:08 PM, Atul Gupta wrote:
> +static void __init chtls_init_ulp_ops(void) {
> +	chtls_base_prot			=3D tcp_prot;
> +	chtls_base_prot.hash		=3D chtls_hash;
> +	chtls_base_prot.unhash		=3D chtls_unhash;
> +	chtls_base_prot.close		=3D chtls_lsk_close;
> +
> +	chtls_cpl_prot			=3D chtls_base_prot;
> +	chtls_init_rsk_ops(&chtls_cpl_prot, &chtls_rsk_ops,
> +			   &tcp_prot, PF_INET);
> +	chtls_cpl_prot.close		=3D chtls_close;
> +	chtls_cpl_prot.disconnect	=3D chtls_disconnect;
> +	chtls_cpl_prot.destroy		=3D chtls_destroy_sock;
> +	chtls_cpl_prot.shutdown		=3D chtls_shutdown;
> +	chtls_cpl_prot.sendmsg		=3D chtls_sendmsg;
> +	chtls_cpl_prot.recvmsg		=3D chtls_recvmsg;
> +	chtls_cpl_prot.sendpage		=3D chtls_sendpage;
> +	chtls_cpl_prot.setsockopt	=3D chtls_setsockopt;
> +	chtls_cpl_prot.getsockopt	=3D chtls_getsockopt;
> +}

Much of this file should go in tls_main.c, reusing as much as possible. For=
 example it doesn't look like the get/set sockopts have changed at all for =
chtls.

Agree, should common code and anything other than TLS_BASE_TX/TLS_SW_TX pro=
t should go in vendor specific file/driver. Since, prot require redefinitio=
n for hardware the code is kept in chtls_main.c

> +
> +static int __init chtls_register(void) {
> +	chtls_init_ulp_ops();
> +	register_listen_notifier(&listen_notifier);
> +	cxgb4_register_uld(CXGB4_ULD_TLS, &chtls_uld_info);
> +	tcp_register_ulp(&tcp_chtls_ulp_ops);
> +	return 0;
> +}
> +
> +static void __exit chtls_unregister(void) {
> +	unregister_listen_notifier(&listen_notifier);
> +	tcp_unregister_ulp(&tcp_chtls_ulp_ops);
> +	chtls_free_all_uld();
> +	cxgb4_unregister_uld(CXGB4_ULD_TLS);
> +}

The idea with ULP is that there is one ULP hook per protocol, not per drive=
r. =20

One thought is that apps/lib calling setsockopt pass the required ulp type =
[tls or chtls or xtls], this enables any HW assist to define base_prot as r=
equired and keep common code [tls_main] independent of underlying HW.=20
If we are to have single TLS ULP hook [good from user point] then need a wa=
y to determine which Inline tls hw is used? System with multiple Inline TLS=
 capable hw and differing functionality would require checks in tls_main to=
 exercise that specific functionality/callback?
