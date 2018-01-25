From: Dave Watson <davejwatson@fb.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Thu, 25 Jan 2018 13:08:50 -0800
Message-ID: <20180125210850.GA69117@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <ganeshgr@chelsio.co>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, Boris Pismenny <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

<1513769897-26945-1-git-send-email-atul.gupta@chelsio.com>

On 12/20/17 05:08 PM, Atul Gupta wrote:
> +static void __init chtls_init_ulp_ops(void)
> +{
> +	chtls_base_prot			= tcp_prot;
> +	chtls_base_prot.hash		= chtls_hash;
> +	chtls_base_prot.unhash		= chtls_unhash;
> +	chtls_base_prot.close		= chtls_lsk_close;
> +
> +	chtls_cpl_prot			= chtls_base_prot;
> +	chtls_init_rsk_ops(&chtls_cpl_prot, &chtls_rsk_ops,
> +			   &tcp_prot, PF_INET);
> +	chtls_cpl_prot.close		= chtls_close;
> +	chtls_cpl_prot.disconnect	= chtls_disconnect;
> +	chtls_cpl_prot.destroy		= chtls_destroy_sock;
> +	chtls_cpl_prot.shutdown		= chtls_shutdown;
> +	chtls_cpl_prot.sendmsg		= chtls_sendmsg;
> +	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
> +	chtls_cpl_prot.sendpage		= chtls_sendpage;
> +	chtls_cpl_prot.setsockopt	= chtls_setsockopt;
> +	chtls_cpl_prot.getsockopt	= chtls_getsockopt;
> +}

Much of this file should go in tls_main.c, reusing as much as
possible. For example it doesn't look like the get/set sockopts have
changed at all for chtls.

> +
> +static int __init chtls_register(void)
> +{
> +	chtls_init_ulp_ops();
> +	register_listen_notifier(&listen_notifier);
> +	cxgb4_register_uld(CXGB4_ULD_TLS, &chtls_uld_info);
> +	tcp_register_ulp(&tcp_chtls_ulp_ops);
> +	return 0;
> +}
> +
> +static void __exit chtls_unregister(void)
> +{
> +	unregister_listen_notifier(&listen_notifier);
> +	tcp_unregister_ulp(&tcp_chtls_ulp_ops);
> +	chtls_free_all_uld();
> +	cxgb4_unregister_uld(CXGB4_ULD_TLS);
> +}

The idea with ULP is that there is one ULP hook per protocol, 
not per driver.  
