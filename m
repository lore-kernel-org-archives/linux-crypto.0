From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [crypto 4/8] chtls: CPL handler definition
Date: Thu, 7 Dec 2017 17:42:53 +0100
Message-ID: <20171207174253.3b0c8841@elisabeth>
References: <1512474000-6681-1-git-send-email-atul.gupta@chelsio.com>
        <20171205161945.768db3b5@elisabeth>
        <MWHPR1201MB0238491AAE21EA436B966AC997330@MWHPR1201MB0238.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Ganesh GR <ganeshgr@chelsio.com>,
        "Harsh Jain" <Harsh@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <MWHPR1201MB0238491AAE21EA436B966AC997330@MWHPR1201MB0238.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Atul,

On Thu, 7 Dec 2017 14:50:37 +0000
Atul Gupta <atul.gupta@chelsio.com> wrote:

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Stefano Brivio
> Sent: Tuesday, December 5, 2017 8:54 PM
> To: Atul Gupta <atul.gupta@chelsio.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; netdev@vger.kernel.org; davem@davemloft.net; davejwatson@fb.com; Ganesh GR <ganeshgr@chelsio.com>; Harsh Jain <Harsh@chelsio.com>
> Subject: Re: [crypto 4/8] chtls: CPL handler definition

First off, it would help immensely if you used an e-mail client with
sane settings for line lengths limit and quoting as described by
RFC3676. Otherwise, this will get quite unreadable, quite soon.

> [...]
>
> > +void get_tcp_symbol(void)
> > +{
> > +	tcp_time_wait_p = (void *)kallsyms_lookup_name("tcp_time_wait");
> > +	if (!tcp_time_wait_p)
> > +		pr_info("could not locate tcp_time_wait");  
> 
> Probably not something that should be used here. Why do you need this?
> [Atul] using it to call tcp_time_wait, as used in tcp_rcv_state_process

Indeed, but why do you need to call tcp_time_wait() directly by looking
it up by symbol name, especially from a network driver? This is really
against any kind of accepted API practice or architecture consideration
whatsoever.

> [...]
>
> > +int chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
> > +{
> > +	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
> > +
> > +	if (unlikely(csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN) ||
> > +		     !csk->cdev)) {
> > +		if (sk->sk_state == TCP_SYN_RECV)
> > +			csk_set_flag(csk, CSK_RST_ABORTED);
> > +		goto out;
> > +	}
> > +
> > +	if (!csk_flag_nochk(csk, CSK_TX_DATA_SENT)) {
> > +		struct tcp_sock *tp = tcp_sk(sk);
> > +
> > +		if (send_tx_flowc_wr(sk, 0, tp->snd_nxt, tp->rcv_nxt) < 0)
> > +			WARN_ONCE(1, "send tx flowc error");
> > +		csk_set_flag(csk, CSK_TX_DATA_SENT);
> > +	}
> > +
> > +	csk_set_flag(csk, CSK_ABORT_RPL_PENDING);
> > +	chtls_purge_write_queue(sk);
> > +
> > +	csk_set_flag(csk, CSK_ABORT_SHUTDOWN);
> > +	if (sk->sk_state != TCP_SYN_RECV)
> > +		chtls_send_abort(sk, mode, skb);  
> 
> If sk->sk_state == TCP_SYN_RECV, aren't we leaking skb, coming e.g.
> from reset_listen_child()?
> [Atul] If (sk->sk_state == TCP_SYN_RECV) we free the skb, else we call the send abort where skb is freed on completion.

That will only happen if, additionally:

	csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN) || !csk->cdev

but otherwise, you can probably end up here with (sk->sk_state ==
TCP_SYN_RECV) and leak the skb.

> [...]
> > +int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
>
> [...]
>
> > +	if (cdev->lldi->enable_fw_ofld_conn) {
> > +		ret = cxgb4_create_server_filter(ndev, stid,
> > +						 inet_sk(sk)->inet_rcv_saddr,
> > +						 inet_sk(sk)->inet_sport, 0,
> > +						 cdev->lldi->rxq_ids[0], 0, 0);
> > +	} else {
> > +		ret = cxgb4_create_server(ndev, stid,
> > +					  inet_sk(sk)->inet_rcv_saddr,
> > +					  inet_sk(sk)->inet_sport, 0,
> > +					  cdev->lldi->rxq_ids[0]);
> > +	}
> > +	if (ret > 0)
> > +		ret = net_xmit_errno(ret);
> > +	if (ret)
> > +		goto del_hash;
> > +
> > +	if (!ret)  
> 
> Not needed I guess?
> [Atul] its required, cxgb4_create_server calls net_xmit_eval where ret can be NET_XMIT_SUCCESS/DROP/CN. 
> net_xmit_eval can return 0 or 1.
> If 1, net_xmit_errno is called which returns ENOBUF or 0. If ENOBUF goto del_hash else return 0

You are doing something like:

	if (x)
		goto y;
	if (!x)
		return 0;
y:

hence the if (!x) clause appears indeed to be quite useless, because
you will never reach that clause if 'x' is true, which voids the whole
purpose of checking whether it's false.

> [...]
> > +static struct sock *chtls_recv_sock(struct sock *lsk,
> > +				    struct request_sock *oreq,
> > +				    void *network_hdr,
> > +				    const struct cpl_pass_accept_req *req,
> > +				    struct chtls_dev *cdev)
> > +
> > +{
> > +	struct sock *newsk;
> > +	struct dst_entry *dst = NULL;
> > +	const struct tcphdr *tcph;
> > +	struct neighbour *n;
> > +	struct net_device *ndev;
> > +	struct chtls_sock *csk;
> > +	struct tcp_sock *tp;
> > +	struct inet_sock *newinet;
> > +	u16 port_id;
> > +	int step;
> > +	int rxq_idx;
> > +	const struct iphdr *iph = (const struct iphdr *)network_hdr;  
> 
> Reverse christmas tree format?
> [Atul] will take care in v2
> 
> > +
> > +	newsk = tcp_create_openreq_child(lsk, oreq, cdev->askb);
> > +	if (!newsk)
> > +		goto free_oreq;
> > +
> > +	dst = inet_csk_route_child_sock(lsk, newsk, oreq);
> > +	if (!dst)
> > +		goto free_sk;
> > +
> > +	tcph = (struct tcphdr *)(iph + 1);
> > +	n = dst_neigh_lookup(dst, &iph->saddr);
> > +	if (!n)
> > +		goto free_sk;
> > +
> > +	ndev = n->dev;
> > +	if (!ndev)
> > +		goto free_sk;
> > +	port_id = cxgb4_port_idx(ndev);
> > +
> > +	csk = chtls_sock_create(cdev);
> > +	if (!csk)
> > +		goto free_sk;
> > +
> > +	csk->l2t_entry = cxgb4_l2t_get(cdev->lldi->l2t, n, ndev, 0);
> > +	if (!csk->l2t_entry)
> > +		goto free_csk;
> > +
> > +	newsk->sk_user_data = csk;
> > +	newsk->sk_backlog_rcv = chtls_backlog_rcv;
> > +
> > +	tp = tcp_sk(newsk);
> > +	newinet = inet_sk(newsk);
> > +
> > +	newinet->inet_daddr = iph->saddr;
> > +	newinet->inet_rcv_saddr = iph->daddr;
> > +	newinet->inet_saddr = iph->daddr;
> > +
> > +	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
> > +	sk_setup_caps(newsk, dst);
> > +	csk->sk = newsk;
> > +	csk->passive_reap_next = oreq;
> > +	csk->tx_chan = cxgb4_port_chan(ndev);
> > +	csk->port_id = port_id;
> > +	csk->egress_dev = ndev;
> > +	csk->tos = PASS_OPEN_TOS_G(ntohl(req->tos_stid));
> > +	csk->ulp_mode = ULP_MODE_TLS;
> > +	step = cdev->lldi->nrxq / cdev->lldi->nchan;
> > +	csk->rss_qid = cdev->lldi->rxq_ids[port_id * step];
> > +	rxq_idx = port_id * step;
> > +	csk->txq_idx = (rxq_idx < cdev->lldi->ntxq) ? rxq_idx :
> > +			port_id * step;
> > +	csk->sndbuf = newsk->sk_sndbuf;
> > +	csk->smac_idx = cxgb4_tp_smt_idx(cdev->lldi->adapter_type,
> > +					 cxgb4_port_viid(ndev));
> > +	tp->rcv_wnd = select_rcv_wnd(csk);
> > +
> > +	neigh_release(n);
> > +	lsk->sk_prot->hash(newsk);
> > +	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
> > +	bh_unlock_sock(newsk);  
> 
> Where is this locked?
> [Atul] tcp_create_openreq_child ->sk_clone_lock

Doesn't this mean that if we hit an error after
tcp_create_openreq_child(), and, say, reach free_sk:

> > +
> > +	return newsk;
> > +free_csk:
> > +	chtls_sock_release(&csk->kref);
> > +free_sk:
> > +	dst_release(dst);
> > +free_oreq:
> > +	chtls_reqsk_free(oreq);
> > +	return NULL;
> > +}

the lock on newsk is never released?

> [...]
>
> > +	if (skb_queue_len(&csk->txq) && chtls_push_frames(csk, 0))
> > +		sk->sk_write_space(sk);
> > +		kfree_skb(skb);  
> 
> I guess you actually always want to kfree_skb(skb) here, right?
> [Atul] yes

Then please fix the indentation. :)

I would also suggest that, given the complexity of the changes, and the
fact that they appear in some parts to challenge the usual practices in
both implementation and structure of typical, existing Linux networking
components, you should mark this as RFC (request for comments) starting
from v2 and try to really split it down in smaller changes, if possible.

-- 
Stefano
