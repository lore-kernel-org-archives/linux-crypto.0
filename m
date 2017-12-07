From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [crypto 4/8] chtls: CPL handler definition
Date: Thu, 7 Dec 2017 14:50:37 +0000
Message-ID: <MWHPR1201MB0238491AAE21EA436B966AC997330@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1512474000-6681-1-git-send-email-atul.gupta@chelsio.com>
 <20171205161945.768db3b5@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Ganesh GR <ganeshgr@chelsio.com>,
        "Harsh Jain" <Harsh@chelsio.com>
To: Stefano Brivio <sbrivio@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171205161945.768db3b5@elisabeth>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.ke=
rnel.org] On Behalf Of Stefano Brivio
Sent: Tuesday, December 5, 2017 8:54 PM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; netdev@vger.=
kernel.org; davem@davemloft.net; davejwatson@fb.com; Ganesh GR <ganeshgr@ch=
elsio.com>; Harsh Jain <Harsh@chelsio.com>
Subject: Re: [crypto 4/8] chtls: CPL handler definition

On Tue,  5 Dec 2017 17:10:00 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> CPL handlers for TLS session, record transmit and receive
>=20
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_cm.c | 2048 +++++++++++++++++++++++++=
++++++
>  1 file changed, 2048 insertions(+)
>  create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.c
>=20
> diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/che=
lsio/chtls/chtls_cm.c
> new file mode 100644
> index 0000000..ea1c301
> --- /dev/null
> +++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
> @@ -0,0 +1,2048 @@
> +/*
> + * Copyright (c) 2017 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Written by: Atul Gupta (atul.gupta@chelsio.com)
> + */
> +
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/workqueue.h>
> +#include <linux/skbuff.h>
> +#include <linux/timer.h>
> +#include <linux/notifier.h>
> +#include <linux/inetdevice.h>
> +#include <linux/ip.h>
> +#include <linux/tcp.h>
> +#include <linux/sched/signal.h>
> +#include <linux/kallsyms.h>
> +#include <linux/kprobes.h>
> +#include <linux/if_vlan.h>
> +#include <net/tcp.h>
> +#include <net/dst.h>
> +
> +#include "chtls.h"
> +#include "chtls_cm.h"
> +
> +extern struct request_sock_ops chtls_rsk_ops;
> +static void (*tcp_time_wait_p)(struct sock *sk, int state, int timeo);
> +
> +/*
> + * State transitions and actions for close.  Note that if we are in SYN_=
SENT
> + * we remain in that state as we cannot control a connection while it's =
in
> + * SYN_SENT; such connections are allowed to establish and are then abor=
ted.
> + */
> +static unsigned char new_state[16] =3D {
> +	/* current state:     new state:      action: */
> +	/* (Invalid)       */ TCP_CLOSE,
> +	/* TCP_ESTABLISHED */ TCP_FIN_WAIT1 | TCP_ACTION_FIN,
> +	/* TCP_SYN_SENT    */ TCP_SYN_SENT,
> +	/* TCP_SYN_RECV    */ TCP_FIN_WAIT1 | TCP_ACTION_FIN,
> +	/* TCP_FIN_WAIT1   */ TCP_FIN_WAIT1,
> +	/* TCP_FIN_WAIT2   */ TCP_FIN_WAIT2,
> +	/* TCP_TIME_WAIT   */ TCP_CLOSE,
> +	/* TCP_CLOSE       */ TCP_CLOSE,
> +	/* TCP_CLOSE_WAIT  */ TCP_LAST_ACK | TCP_ACTION_FIN,
> +	/* TCP_LAST_ACK    */ TCP_LAST_ACK,
> +	/* TCP_LISTEN      */ TCP_CLOSE,
> +	/* TCP_CLOSING     */ TCP_CLOSING,
> +};
> +
> +static struct chtls_sock *chtls_sock_create(struct chtls_dev *cdev)
> +{
> +	struct chtls_sock *csk =3D kzalloc(sizeof(*csk), GFP_NOIO);
> +
> +	if (!csk)
> +		return NULL;
> +
> +	csk->txdata_skb_cache =3D  alloc_skb(TXDATA_SKB_LEN, GFP_ATOMIC);

Excess whitespace.
[Atul] Will take care in v2

> +	if (!csk->txdata_skb_cache) {
> +		kfree(csk);
> +		return NULL;
> +	}
> +
> +	kref_init(&csk->kref);
> +	csk->cdev =3D cdev;
> +	skb_queue_head_init(&csk->txq);
> +	csk->wr_skb_head =3D NULL;
> +	csk->wr_skb_tail =3D NULL;
> +	csk->mss =3D MAX_MSS;
> +	csk->tlshws.ofld =3D 1;
> +	csk->tlshws.txkey =3D -1;
> +	csk->tlshws.rxkey =3D -1;
> +	csk->tlshws.mfs =3D TLS_MFS;
> +	skb_queue_head_init(&csk->tlshws.sk_recv_queue);
> +	return csk;
> +}
> +
> +void chtls_sock_release(struct kref *ref)
> +{
> +	struct chtls_sock *csk =3D
> +		container_of(ref, struct chtls_sock, kref);
> +
> +	kfree(csk);
> +}
> +
> +void get_tcp_symbol(void)
> +{
> +	tcp_time_wait_p =3D (void *)kallsyms_lookup_name("tcp_time_wait");
> +	if (!tcp_time_wait_p)
> +		pr_info("could not locate tcp_time_wait");

Probably not something that should be used here. Why do you need this?
[Atul] using it to call tcp_time_wait, as used in tcp_rcv_state_process
=20
> +}
> +
> +static struct net_device *chtls_ipv4_netdev(struct chtls_dev *cdev,
> +					    struct sock *sk)
> +{
> +	struct net_device *ndev =3D cdev->ports[0];
> +
> +	if (likely(!inet_sk(sk)->inet_rcv_saddr))
> +		return ndev;
> +
> +	ndev =3D ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
> +	if (!ndev)
> +		return NULL;
> +
> +	if (is_vlan_dev(ndev))
> +		return vlan_dev_real_dev(ndev);
> +	return ndev;
> +}
> +
> +static void assign_rxopt(struct sock *sk, unsigned int opt)
> +{
> +	const struct chtls_dev *cdev;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	cdev =3D csk->cdev;
> +	tp->tcp_header_len           =3D sizeof(struct tcphdr);
> +	tp->rx_opt.mss_clamp         =3D cdev->mtus[TCPOPT_MSS_G(opt)] - 40;
> +	tp->mss_cache                =3D tp->rx_opt.mss_clamp;
> +	tp->rx_opt.tstamp_ok         =3D TCPOPT_TSTAMP_G(opt);
> +	tp->rx_opt.snd_wscale        =3D TCPOPT_SACK_G(opt);
> +	tp->rx_opt.wscale_ok         =3D TCPOPT_WSCALE_OK_G(opt);
> +	SND_WSCALE(tp)               =3D TCPOPT_SND_WSCALE_G(opt);
> +	if (!tp->rx_opt.wscale_ok)
> +		tp->rx_opt.rcv_wscale =3D 0;
> +	if (tp->rx_opt.tstamp_ok) {
> +		tp->tcp_header_len +=3D TCPOLEN_TSTAMP_ALIGNED;
> +		tp->rx_opt.mss_clamp -=3D TCPOLEN_TSTAMP_ALIGNED;
> +	} else if (csk->opt2 & TSTAMPS_EN_F) {
> +		csk->opt2 &=3D ~TSTAMPS_EN_F;
> +		csk->mtu_idx =3D TCPOPT_MSS_G(opt);
> +	}
> +}
> +
> +static void chtls_purge_rcv_queue(struct sock *sk)
> +{
> +	struct sk_buff *skb;
> +
> +	while ((skb =3D __skb_dequeue(&sk->sk_receive_queue)) !=3D NULL) {
> +		skb_dst_set(skb, (void *)NULL);
> +		kfree_skb(skb);
> +	}
> +}
> +
> +static void chtls_purge_write_queue(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct sk_buff *skb;
> +
> +	while ((skb =3D __skb_dequeue(&csk->txq))) {
> +		sk->sk_wmem_queued -=3D skb->truesize;
> +		__kfree_skb(skb);
> +	}
> +}
> +
> +static void chtls_purge_receive_queue(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_hws *tlsk =3D &csk->tlshws;
> +	struct sk_buff *skb;
> +
> +	while ((skb =3D __skb_dequeue(&tlsk->sk_recv_queue)) !=3D NULL) {
> +		skb_dst_set(skb, NULL);
> +		kfree_skb(skb);
> +	}
> +}
> +
> +static void abort_arp_failure(void *handle, struct sk_buff *skb)
> +{
> +	struct cpl_abort_req *req =3D cplhdr(skb);
> +	struct chtls_dev *cdev =3D (struct chtls_dev *)handle;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	req->cmd =3D CPL_ABORT_NO_RST;
> +	cxgb4_ofld_send(cdev->lldi->ports[0], skb);
> +}
> +
> +struct sk_buff *alloc_ctrl_skb(struct sk_buff *skb, int len)
> +{
> +	if (likely(skb && !skb_shared(skb) && !skb_cloned(skb))) {
> +		__skb_trim(skb, 0);
> +		refcount_add(2, &skb->users);
> +	} else {
> +		skb =3D alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
> +	}
> +	return skb;
> +}
> +
> +static void chtls_send_abort(struct sock *sk, int mode, struct sk_buff *=
skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_abort_req *req;
> +
> +	if (!skb)
> +		skb =3D alloc_ctrl_skb(csk->txdata_skb_cache, sizeof(*req));

What if alloc_ctrl_skb() fails?
[Atul] alloc_ctrl_skb does alloc_skb with GFP_NOFAIL

> +	req =3D (struct cpl_abort_req *)skb_put(skb, sizeof(*req));
> +	INIT_TP_WR_CPL(req, CPL_ABORT_REQ, csk->tid);
> +	set_queue(skb, (csk->txq_idx << 1) | CPL_PRIORITY_DATA, sk);
> +	req->rsvd0 =3D htonl(tp->snd_nxt);
> +	req->rsvd1 =3D !csk_flag_nochk(csk, CSK_TX_DATA_SENT);
> +	req->cmd =3D mode;
> +	t4_set_arp_err_handler(skb, csk->cdev, abort_arp_failure);
> +	send_or_defer(sk, tp, skb, mode =3D=3D CPL_ABORT_SEND_RST);
> +}
> +
> +int chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +
> +	if (unlikely(csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN) ||
> +		     !csk->cdev)) {
> +		if (sk->sk_state =3D=3D TCP_SYN_RECV)
> +			csk_set_flag(csk, CSK_RST_ABORTED);
> +		goto out;
> +	}
> +
> +	if (!csk_flag_nochk(csk, CSK_TX_DATA_SENT)) {
> +		struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +		if (send_tx_flowc_wr(sk, 0, tp->snd_nxt, tp->rcv_nxt) < 0)
> +			WARN_ONCE(1, "send tx flowc error");
> +		csk_set_flag(csk, CSK_TX_DATA_SENT);
> +	}
> +
> +	csk_set_flag(csk, CSK_ABORT_RPL_PENDING);
> +	chtls_purge_write_queue(sk);
> +
> +	csk_set_flag(csk, CSK_ABORT_SHUTDOWN);
> +	if (sk->sk_state !=3D TCP_SYN_RECV)
> +		chtls_send_abort(sk, mode, skb);

If sk->sk_state =3D=3D TCP_SYN_RECV, aren't we leaking skb, coming e.g.
from reset_listen_child()?
[Atul] If (sk->sk_state =3D=3D TCP_SYN_RECV) we free the skb, else we call =
the send abort where skb is freed on completion.

> +
> +	return 0;
> +out:
> +	if (skb)
> +		kfree_skb(skb);
> +	return 1;
> +}
> +
> +static void release_tcp_port(struct sock *sk)
> +{
> +	if (inet_csk(sk)->icsk_bind_hash)
> +		inet_put_port(sk);
> +}
> +
> +static void tcp_uncork(struct sock *sk)
> +{
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +	if (tp->nonagle & TCP_NAGLE_CORK) {
> +		tp->nonagle &=3D ~TCP_NAGLE_CORK;
> +		chtls_tcp_push(sk, 0);
> +	}
> +}
> +
> +static void chtls_close_conn(struct sock *sk)
> +{
> +	struct sk_buff *skb;
> +	struct cpl_close_con_req *req;
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	unsigned int tid =3D csk->tid;
> +	unsigned int len =3D roundup(sizeof(struct cpl_close_con_req), 16);
> +
> +	skb =3D alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
> +	req =3D (struct cpl_close_con_req *)__skb_put(skb, len);
> +	memset(req, 0, len);
> +	req->wr.wr_hi =3D htonl(FW_WR_OP_V(FW_TP_WR) |
> +			      FW_WR_IMMDLEN_V(sizeof(*req) -
> +					      sizeof(req->wr)));
> +	req->wr.wr_mid =3D htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)) =
|
> +			       FW_WR_FLOWID_V(tid));
> +
> +	OPCODE_TID(req) =3D htonl(MK_OPCODE_TID(CPL_CLOSE_CON_REQ, tid));
> +
> +	tcp_uncork(sk);
> +	skb_entail(sk, skb, ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
> +	if (sk->sk_state !=3D TCP_SYN_SENT)
> +		chtls_push_frames(csk, 1);
> +}
> +
> +/*
> + * Perform a state transition during close and return the actions indica=
ted
> + * for the transition.  Do not make this function inline, the main reaso=
n
> + * it exists at all is to avoid multiple inlining of tcp_set_state.
> + */
> +static int make_close_transition(struct sock *sk)
> +{
> +	int next =3D (int)new_state[sk->sk_state];
> +
> +	tcp_set_state(sk, next & TCP_STATE_MASK);
> +	return next & TCP_ACTION_FIN;
> +}
> +
> +void chtls_close(struct sock *sk, long timeout)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	int data_lost, prev_state;
> +
> +	lock_sock(sk);
> +	if (sk->sk_prot->close !=3D chtls_close) {
> +		release_sock(sk);
> +		return sk->sk_prot->close(sk, timeout);
> +	}
> +
> +	sk->sk_shutdown |=3D SHUTDOWN_MASK;
> +
> +	data_lost =3D skb_queue_len(&sk->sk_receive_queue);
> +	data_lost |=3D skb_queue_len(&csk->tlshws.sk_recv_queue);
> +	chtls_purge_receive_queue(sk);
> +	chtls_purge_rcv_queue(sk);
> +
> +	if (sk->sk_state =3D=3D TCP_CLOSE) {
> +		goto wait;
> +	} else if (data_lost || sk->sk_state =3D=3D TCP_SYN_SENT) {
> +		chtls_send_reset(sk, CPL_ABORT_SEND_RST, NULL);
> +		release_tcp_port(sk);
> +		goto unlock;
> +	} else if (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime) {
> +		sk->sk_prot->disconnect(sk, 0);
> +	} else if (make_close_transition(sk)) {
> +		chtls_close_conn(sk);
> +	}
> +wait:
> +	if (timeout)
> +		sk_stream_wait_close(sk, timeout);
> +
> +unlock:
> +	prev_state =3D sk->sk_state;
> +	sock_hold(sk);
> +	sock_orphan(sk);
> +
> +	release_sock(sk);
> +
> +	local_bh_disable();
> +	bh_lock_sock(sk);
> +
> +	if (prev_state !=3D TCP_CLOSE && sk->sk_state =3D=3D TCP_CLOSE)
> +		goto out;
> +
> +	if (sk->sk_state =3D=3D TCP_FIN_WAIT2 && tcp_sk(sk)->linger2 < 0 &&
> +	    !csk_flag(sk, CSK_ABORT_SHUTDOWN)) {
> +		struct sk_buff *skb;
> +
> +		skb =3D alloc_skb(sizeof(struct cpl_abort_req), GFP_ATOMIC);
> +		if (skb)
> +			chtls_send_reset(sk, CPL_ABORT_SEND_RST, skb);
> +	}
> +
> +	if (sk->sk_state =3D=3D TCP_CLOSE)
> +		inet_csk_destroy_sock(sk);
> +
> +out:
> +	bh_unlock_sock(sk);
> +	local_bh_enable();
> +	sock_put(sk);
> +}
> +
> +/*
> + * Wait until a socket enters on of the given states.
> + */
> +static int wait_for_states(struct sock *sk, unsigned int states)
> +{
> +	struct socket_wq _sk_wq;
> +	long current_timeo =3D 200;
> +	DECLARE_WAITQUEUE(wait, current);
> +	int err =3D 0;
> +
> +	/*
> +	 * We want this to work even when there's no associated struct socket.
> +	 * In that case we provide a temporary wait_queue_head_t.
> +	 */
> +	if (!sk->sk_wq) {
> +		init_waitqueue_head(&_sk_wq.wait);
> +		_sk_wq.fasync_list =3D NULL;
> +		init_rcu_head_on_stack(&_sk_wq.rcu);
> +		sk->sk_wq =3D &_sk_wq;
> +	}
> +
> +	add_wait_queue(sk_sleep(sk), &wait);
> +	while (!sk_in_state(sk, states)) {
> +		if (!current_timeo) {
> +			err =3D -EBUSY;
> +			break;
> +		}
> +		if (signal_pending(current)) {
> +			err =3D sock_intr_errno(current_timeo);
> +			break;
> +		}
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		release_sock(sk);
> +		if (!sk_in_state(sk, states))
> +			current_timeo =3D schedule_timeout(current_timeo);
> +		__set_current_state(TASK_RUNNING);
> +		lock_sock(sk);
> +	}
> +	remove_wait_queue(sk_sleep(sk), &wait);
> +
> +	if (sk->sk_wq =3D=3D &_sk_wq)
> +		sk->sk_wq =3D NULL;
> +	return err;
> +}
> +
> +int chtls_disconnect(struct sock *sk, int flags)
> +{
> +	struct chtls_sock *csk;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	int err;
> +
> +	if (sk->sk_prot->disconnect !=3D chtls_disconnect)
> +		return sk->sk_prot->disconnect(sk, flags);
> +
> +	csk =3D rcu_dereference_sk_user_data(sk);
> +	chtls_purge_receive_queue(sk);
> +	chtls_purge_rcv_queue(sk);
> +	chtls_purge_write_queue(sk);
> +
> +	if (sk->sk_state !=3D TCP_CLOSE) {
> +		sk->sk_err =3D ECONNRESET;
> +		chtls_send_reset(sk, CPL_ABORT_SEND_RST, NULL);
> +		err =3D wait_for_states(sk, TCPF_CLOSE);
> +		if (err)
> +			return err;
> +	}
> +	if (sk->sk_prot->disconnect !=3D chtls_disconnect)
> +		return sk->sk_prot->disconnect(sk, flags);
> +
> +	chtls_purge_receive_queue(sk);
> +	chtls_purge_rcv_queue(sk);
> +	tp->max_window =3D 0xFFFF << (tp->rx_opt.snd_wscale);
> +	return tcp_disconnect(sk, flags);
> +}
> +
> +#define SHUTDOWN_ELIGIBLE_STATE (TCPF_ESTABLISHED | \
> +				 TCPF_SYN_RECV | TCPF_CLOSE_WAIT)
> +void chtls_shutdown(struct sock *sk, int how)
> +{
> +	if (sk->sk_prot->shutdown !=3D chtls_shutdown)
> +		return sk->sk_prot->shutdown(sk, how);
> +
> +	if ((how & SEND_SHUTDOWN) &&
> +	    sk_in_state(sk, SHUTDOWN_ELIGIBLE_STATE) &&
> +	    make_close_transition(sk))
> +		chtls_close_conn(sk);
> +}
> +
> +void chtls_destroy_sock(struct sock *sk)
> +{
> +	struct chtls_sock *csk;
> +
> +	if (sk->sk_prot->destroy !=3D chtls_destroy_sock)
> +		return sk->sk_prot->destroy(sk);
> +
> +	csk =3D rcu_dereference_sk_user_data(sk);
> +	chtls_purge_receive_queue(sk);
> +	csk->ulp_mode =3D ULP_MODE_NONE;
> +	chtls_purge_write_queue(sk);
> +	free_tls_keyid(sk);
> +	kref_put(&csk->kref, chtls_sock_release);
> +
> +	sk->sk_prot =3D &tcp_prot;
> +	sk->sk_prot->destroy(sk);
> +}
> +
> +static void reset_listen_child(struct sock *child)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(child);
> +	struct sk_buff *skb;
> +
> +	skb =3D alloc_ctrl_skb(csk->txdata_skb_cache,
> +			     sizeof(struct cpl_abort_req));
> +
> +	chtls_send_reset(child, CPL_ABORT_SEND_RST, skb);
> +	sock_orphan(child);
> +	INC_ORPHAN_COUNT(child);
> +	if (child->sk_state =3D=3D TCP_CLOSE)
> +		inet_csk_destroy_sock(child);
> +}
> +
> +void chtls_disconnect_acceptq(struct sock *listen_sk)
> +{
> +	struct request_sock **pprev;
> +
> +	pprev =3D ACCEPT_QUEUE(listen_sk);
> +	while (*pprev) {
> +		struct request_sock *req =3D *pprev;
> +
> +		if (req->rsk_ops =3D=3D &chtls_rsk_ops) {
> +			struct sock *child =3D req->sk;
> +
> +			*pprev =3D req->dl_next;
> +			sk_acceptq_removed(listen_sk);
> +			reqsk_put(req);
> +			sock_hold(child);
> +			local_bh_disable();
> +			bh_lock_sock(child);
> +			release_tcp_port(child);
> +			reset_listen_child(child);
> +			bh_unlock_sock(child);
> +			local_bh_enable();
> +			sock_put(child);
> +		} else {
> +			pprev =3D &req->dl_next;
> +		}
> +	}
> +}
> +
> +static int listen_hashfn(const struct sock *sk)
> +{
> +	return ((unsigned long)sk >> 10) & (LISTEN_INFO_HASH_SIZE - 1);
> +}
> +
> +static struct listen_info *listen_hash_add(struct chtls_dev *cdev,
> +					   struct sock *sk,
> +					   unsigned int stid)
> +{
> +	struct listen_info *p =3D kmalloc(sizeof(*p), GFP_KERNEL);
> +
> +	if (p) {
> +		int key =3D listen_hashfn(sk);
> +
> +		p->sk =3D sk;
> +		p->stid =3D stid;
> +		spin_lock(&cdev->listen_lock);
> +		p->next =3D cdev->listen_hash_tab[key];
> +		cdev->listen_hash_tab[key] =3D p;
> +		spin_unlock(&cdev->listen_lock);
> +	}
> +	return p;
> +}
> +
> +static int listen_hash_find(struct chtls_dev *cdev,
> +			    struct sock *sk)
> +{
> +	struct listen_info *p;
> +	int key =3D listen_hashfn(sk);
> +	int stid =3D -1;

Reverse christmas tree format?
[Atul] Will take care in v2

> +
> +	spin_lock(&cdev->listen_lock);
> +	for (p =3D cdev->listen_hash_tab[key]; p; p =3D p->next)
> +		if (p->sk =3D=3D sk) {
> +			stid =3D p->stid;
> +			break;
> +		}
> +	spin_unlock(&cdev->listen_lock);
> +	return stid;
> +}
> +
> +static int listen_hash_del(struct chtls_dev *cdev,
> +			   struct sock *sk)
> +{
> +	int key =3D listen_hashfn(sk);
> +	struct listen_info *p, **prev =3D &cdev->listen_hash_tab[key];
> +	int stid =3D -1;
> +
> +	spin_lock(&cdev->listen_lock);
> +	for (p =3D *prev; p; prev =3D &p->next, p =3D p->next)
> +		if (p->sk =3D=3D sk) {
> +			stid =3D p->stid;
> +			*prev =3D p->next;
> +			kfree(p);
> +			break;
> +		}
> +	spin_unlock(&cdev->listen_lock);
> +	return stid;
> +}
> +
> +int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
> +{
> +	struct net_device *ndev;
> +	struct port_info *pi;
> +	struct adapter *adap;
> +	struct listen_ctx *ctx;
> +	int stid;
> +	int ret;

Reverse christmas tree format?
[Atul] Will take care in v2

> +
> +	if (sk->sk_family !=3D PF_INET)
> +		return -EAGAIN;
> +
> +	rcu_read_lock();
> +	ndev =3D chtls_ipv4_netdev(cdev, sk);
> +	rcu_read_unlock();
> +	if (!ndev)
> +		return -EBADF;
> +
> +	pi =3D netdev_priv(ndev);
> +	adap =3D pi->adapter;
> +	if (!(adap->flags & FULL_INIT_DONE))
> +		return -EBADF;
> +
> +	if (listen_hash_find(cdev, sk) >=3D 0)   /* already have it */
> +		return -EADDRINUSE;
> +
> +	ctx =3D kmalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	__module_get(THIS_MODULE);
> +	ctx->lsk =3D sk;
> +	ctx->cdev =3D cdev;
> +	ctx->state =3D T4_LISTEN_START_PENDING;
> +
> +	if (cdev->lldi->enable_fw_ofld_conn &&
> +	    sk->sk_family =3D=3D PF_INET)
> +		stid =3D cxgb4_alloc_sftid(cdev->tids, sk->sk_family, ctx);
> +	else
> +		stid =3D cxgb4_alloc_stid(cdev->tids, sk->sk_family, ctx);
> +
> +	if (stid < 0)
> +		goto free_ctx;
> +
> +	sock_hold(sk);
> +	if (!listen_hash_add(cdev, sk, stid))
> +		goto free_stid;
> +
> +	if (cdev->lldi->enable_fw_ofld_conn) {
> +		ret =3D cxgb4_create_server_filter(ndev, stid,
> +						 inet_sk(sk)->inet_rcv_saddr,
> +						 inet_sk(sk)->inet_sport, 0,
> +						 cdev->lldi->rxq_ids[0], 0, 0);
> +	} else {
> +		ret =3D cxgb4_create_server(ndev, stid,
> +					  inet_sk(sk)->inet_rcv_saddr,
> +					  inet_sk(sk)->inet_sport, 0,
> +					  cdev->lldi->rxq_ids[0]);
> +	}
> +	if (ret > 0)
> +		ret =3D net_xmit_errno(ret);
> +	if (ret)
> +		goto del_hash;
> +
> +	if (!ret)

Not needed I guess?
[Atul] its required, cxgb4_create_server calls net_xmit_eval where ret can =
be NET_XMIT_SUCCESS/DROP/CN.=20
net_xmit_eval can return 0 or 1.
If 1, net_xmit_errno is called which returns ENOBUF or 0. If ENOBUF goto de=
l_hash else return 0

> +		return 0;
> +del_hash:
> +	listen_hash_del(cdev, sk);
> +free_stid:
> +	cxgb4_free_stid(cdev->tids, stid, sk->sk_family);
> +	sock_put(sk);
> +free_ctx:
> +	kfree(ctx);
> +	module_put(THIS_MODULE);
> +	return -EBADF;
> +}
> +
> +void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
> +{
> +	int stid;
> +
> +	stid =3D listen_hash_del(cdev, sk);
> +	if (stid < 0)
> +		return;
> +
> +	if (cdev->lldi->enable_fw_ofld_conn) {
> +		cxgb4_remove_server_filter(cdev->lldi->ports[0], stid,
> +					   cdev->lldi->rxq_ids[0], 0);
> +	} else {
> +		cxgb4_remove_server(cdev->lldi->ports[0], stid,
> +				    cdev->lldi->rxq_ids[0], 0);
> +	}
> +	chtls_disconnect_acceptq(sk);
> +}
> +
> +static int chtls_pass_open_rpl(struct chtls_dev *cdev, struct sk_buff *s=
kb)
> +{
> +	struct cpl_pass_open_rpl *rpl =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int stid =3D GET_TID(rpl);
> +	struct listen_ctx *listen_ctx;
> +
> +	listen_ctx =3D (struct listen_ctx *)lookup_stid(cdev->tids, stid);
> +	if (!listen_ctx)
> +		return 1;
> +
> +	if (listen_ctx->state =3D=3D T4_LISTEN_START_PENDING) {
> +		listen_ctx->state =3D T4_LISTEN_STARTED;
> +		return 1;
> +	}
> +
> +	if (rpl->status !=3D CPL_ERR_NONE) {
> +		pr_info("Unexpected PASS_OPEN_RPL status %u for STID %u\n",
> +			rpl->status, stid);

Why do we return 0? How is this error handled?
[Atul] Will take care in v2

> +	} else {
> +		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
> +		sock_put(listen_ctx->lsk);
> +		kfree(listen_ctx);
> +		module_put(THIS_MODULE);
> +	}
> +
> +	return 0;
> +}
> +
> +static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buf=
f *skb)
> +{
> +	struct cpl_close_listsvr_rpl *rpl =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int stid =3D GET_TID(rpl);
> +	void *data =3D lookup_stid(cdev->tids, stid);
> +
> +	if (rpl->status !=3D CPL_ERR_NONE) {
> +		pr_info("Unexpected CLOSE_LISTSRV_RPL status %u for STID %u\n",
> +			rpl->status, stid);
> +	} else {
> +		struct listen_ctx *listen_ctx =3D (struct listen_ctx *)data;
> +
> +		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
> +		sock_put(listen_ctx->lsk);
> +		kfree(listen_ctx);
> +		module_put(THIS_MODULE);
> +	}
> +
> +	return 0;
> +}
> +
> +static void conn_remove_handle(struct chtls_dev *cdev,
> +			       int tid)
> +{
> +	spin_lock_bh(&cdev->aidr_lock);
> +	idr_remove(&cdev->aidr, tid);
> +	spin_unlock_bh(&cdev->aidr_lock);
> +}
> +
> +void free_atid(struct chtls_sock *csk, struct chtls_dev *cdev,
> +	       unsigned int atid)
> +{
> +	struct tid_info *tids =3D cdev->tids;
> +
> +	conn_remove_handle(cdev, atid);
> +	cxgb4_free_atid(tids, atid);
> +	sock_put(csk->sk);
> +	kref_put(&csk->kref, chtls_sock_release);
> +}
> +
> +static void chtls_release_resources(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	struct tid_info *tids;
> +	unsigned int tid =3D csk->tid;
> +
> +	if (!cdev)
> +		return;
> +
> +	tids =3D cdev->tids;
> +	kfree_skb(csk->txdata_skb_cache);
> +	csk->txdata_skb_cache =3D NULL;
> +
> +	if (csk->l2t_entry) {
> +		cxgb4_l2t_release(csk->l2t_entry);
> +		csk->l2t_entry =3D NULL;
> +	}
> +
> +	if (sk->sk_state =3D=3D TCP_SYN_SENT) {
> +		free_atid(csk, cdev, tid);
> +		__skb_queue_purge(&csk->ooo_queue);
> +	} else {
> +		cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
> +		sock_put(sk);
> +	}
> +}
> +
> +static void cleanup_syn_rcv_conn(struct sock *child, struct sock *parent=
)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(child);
> +	struct request_sock *req =3D csk->passive_reap_next;
> +
> +	reqsk_queue_removed(&inet_csk(parent)->icsk_accept_queue, req);
> +	chtls_reqsk_free(req);
> +	csk->passive_reap_next =3D NULL;
> +}
> +
> +static void chtls_conn_done(struct sock *sk)
> +{
> +	if (sock_flag(sk, SOCK_DEAD))
> +		chtls_purge_rcv_queue(sk);
> +	sk_wakeup_sleepers(sk, 0);
> +	tcp_done(sk);
> +}
> +
> +static void do_abort_syn_rcv(struct sock *child, struct sock *parent)
> +{
> +	/*
> +	 * If the server is still open we clean up the child connection,
> +	 * otherwise the server already did the clean up as it was purging
> +	 * its SYN queue and the skb was just sitting in its backlog.
> +	 */
> +	if (likely(parent->sk_state =3D=3D TCP_LISTEN)) {
> +		cleanup_syn_rcv_conn(child, parent);
> +		/* Without the below call to sock_orphan,
> +		 * we leak the socket resource with syn_flood test
> +		 * as inet_csk_destroy_sock will not be called
> +		 * in tcp_done since SOCK_DEAD flag is not set.
> +		 * Kernel handles this differently where new socket is
> +		 * created only after 3 way handshake is done.
> +		 */
> +		sock_orphan(child);
> +		percpu_counter_inc((child)->sk_prot->orphan_count);
> +		chtls_release_resources(child);
> +		chtls_conn_done(child);
> +	} else {
> +		if (csk_flag(child, CSK_RST_ABORTED)) {
> +			chtls_release_resources(child);
> +			chtls_conn_done(child);
> +		}
> +	}
> +}
> +
> +static void pass_open_abort(struct sock *child, struct sock *parent,
> +			    struct sk_buff *skb)
> +{
> +	do_abort_syn_rcv(child, parent);
> +	kfree_skb(skb);
> +}
> +
> +static void bl_pass_open_abort(struct sock *lsk, struct sk_buff *skb)
> +{
> +	pass_open_abort(skb->sk, lsk, skb);
> +}
> +
> +static void chtls_pass_open_arp_failure(struct sock *sk,
> +					struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	struct sock *parent;
> +	const struct request_sock *oreq;
> +	void *data;
> +
> +	/*
> +	 * If the connection is being aborted due to the parent listening
> +	 * socket going away there's nothing to do, the ABORT_REQ will close
> +	 * the connection.
> +	 */
> +	if (csk_flag(sk, CSK_ABORT_RPL_PENDING)) {
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	oreq =3D csk->passive_reap_next;
> +	data =3D lookup_stid(cdev->tids, oreq->ts_recent);
> +	parent =3D ((struct listen_ctx *)data)->lsk;
> +
> +	bh_lock_sock(parent);
> +	if (!sock_owned_by_user(parent)) {
> +		pass_open_abort(sk, parent, skb);
> +	} else {
> +		BLOG_SKB_CB(skb)->backlog_rcv =3D bl_pass_open_abort;
> +		__sk_add_backlog(parent, skb);
> +	}
> +	bh_unlock_sock(parent);
> +}
> +
> +static void chtls_accept_rpl_arp_failure(void *handle,
> +					 struct sk_buff *skb)
> +{
> +	struct sock *sk =3D (struct sock *)handle;
> +
> +	sock_hold(sk);
> +	process_cpl_msg(chtls_pass_open_arp_failure, sk, skb);
> +	sock_put(sk);
> +}
> +
> +static unsigned int chtls_select_mss(const struct chtls_sock *csk,
> +				     unsigned int pmtu,
> +				     struct cpl_pass_accept_req *req)
> +{
> +	struct sock *sk =3D csk->sk;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct dst_entry *dst =3D __sk_dst_get(sk);
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	unsigned int iphdrsz;
> +	unsigned int tcpoptsz =3D 0;
> +	unsigned int mtu_idx;
> +	unsigned int mss =3D ntohs(req->tcpopt.mss);
> +
> +	iphdrsz =3D sizeof(struct iphdr) + sizeof(struct tcphdr);
> +	if (req->tcpopt.tstamp)
> +		tcpoptsz +=3D round_up(TCPOLEN_TIMESTAMP, 4);
> +
> +	tp->advmss =3D dst_metric_advmss(dst);
> +	if (USER_MSS(tp) && tp->advmss > USER_MSS(tp))
> +		tp->advmss =3D USER_MSS(tp);
> +	if (tp->advmss > pmtu - iphdrsz)
> +		tp->advmss =3D pmtu - iphdrsz;
> +	if (mss && tp->advmss > mss)
> +		tp->advmss =3D mss;
> +
> +	tp->advmss =3D cxgb4_best_aligned_mtu(cdev->lldi->mtus,
> +					    iphdrsz + tcpoptsz,
> +					    tp->advmss - tcpoptsz,
> +					    8, &mtu_idx);
> +	tp->advmss -=3D iphdrsz;
> +
> +	inet_csk(sk)->icsk_pmtu_cookie =3D pmtu;
> +	return mtu_idx;
> +}
> +
> +static unsigned int select_rcv_wnd(struct chtls_sock *csk)
> +{
> +	struct sock *sk =3D csk->sk;
> +	unsigned int wnd =3D tcp_full_space(sk);
> +	unsigned int rcvwnd;

Reverse christmas tree format?
[Atul] Will take care in v2

> +	if (wnd < MIN_RCV_WND)
> +		wnd =3D MIN_RCV_WND;
> +
> +	rcvwnd =3D MAX_RCV_WND;
> +
> +	csk_set_flag(csk, CSK_UPDATE_RCV_WND);
> +	return min(wnd, rcvwnd);
> +}
> +
> +static void chtls_pass_accept_rpl(struct sk_buff *skb,
> +				  struct cpl_pass_accept_req *req,
> +				  unsigned int tid)
> +
> +{
> +	struct sock *sk;
> +	struct chtls_sock *csk;
> +	const struct tcphdr *tcph;
> +	struct cxgb4_lld_info *lldi;
> +	struct cpl_t5_pass_accept_rpl *rpl5;
> +	unsigned int len =3D roundup(sizeof(*rpl5), 16);
> +	const struct tcp_sock *tp;
> +	u64 opt0;
> +	u32 opt2, hlen;

Reverse christmas tree format?
[Atul]  will take care in v2

> +
> +	sk =3D skb->sk;
> +	tp =3D tcp_sk(sk);
> +	csk =3D sk->sk_user_data;
> +	csk->tid =3D tid;
> +	lldi =3D csk->cdev->lldi;
> +
> +	rpl5 =3D __skb_put_zero(skb, len);
> +	INIT_TP_WR(rpl5, tid);
> +
> +	OPCODE_TID(rpl5) =3D cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
> +						     csk->tid));
> +	csk->mtu_idx =3D chtls_select_mss(csk, dst_mtu(__sk_dst_get(sk)),
> +					req);
> +	opt0 =3D  TCAM_BYPASS_F |

Excess whitespace.
[Atul] Will take care in v2

> +		WND_SCALE_V((tp)->rx_opt.rcv_wscale) |
> +		MSS_IDX_V(csk->mtu_idx) |
> +		L2T_IDX_V(csk->l2t_entry->idx) |
> +		NAGLE_V(!(tp->nonagle & TCP_NAGLE_OFF)) |
> +		TX_CHAN_V(csk->tx_chan) |
> +		SMAC_SEL_V(csk->smac_idx) |
> +		DSCP_V(csk->tos >> 2) |
> +		ULP_MODE_V(ULP_MODE_TLS) |
> +		RCV_BUFSIZ_V(min(tp->rcv_wnd >> 10, RCV_BUFSIZ_M));
> +
> +	opt2 =3D RX_CHANNEL_V(0) |
> +		RSS_QUEUE_VALID_F | RSS_QUEUE_V(csk->rss_qid);
> +
> +	if (!is_t5(lldi->adapter_type))
> +		opt2 |=3D RX_FC_DISABLE_F;
> +	if (req->tcpopt.tstamp)
> +		opt2 |=3D TSTAMPS_EN_F;
> +	if (req->tcpopt.sack)
> +		opt2 |=3D SACK_EN_F;
> +	hlen =3D ntohl(req->hdr_len);
> +
> +	tcph =3D (struct tcphdr *)((u8 *)(req + 1) +
> +			T6_ETH_HDR_LEN_G(hlen) + T6_IP_HDR_LEN_G(hlen));
> +	if (tcph->ece && tcph->cwr)
> +		opt2 |=3D CCTRL_ECN_V(1);
> +	opt2 |=3D CONG_CNTRL_V(CONG_ALG_NEWRENO);
> +	opt2 |=3D T5_ISS_F;
> +	opt2 |=3D T5_OPT_2_VALID_F;
> +	rpl5->opt0 =3D cpu_to_be64(opt0);
> +	rpl5->opt2 =3D cpu_to_be32(opt2);
> +	rpl5->iss =3D cpu_to_be32((prandom_u32() & ~7UL) - 1);
> +	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
> +	t4_set_arp_err_handler(skb, sk, chtls_accept_rpl_arp_failure);
> +	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
> +}
> +
> +static void inet_inherit_port(struct inet_hashinfo *hash_info,
> +			      struct sock *lsk, struct sock *newsk)
> +{
> +	local_bh_disable();
> +	__inet_inherit_port(lsk, newsk);
> +	local_bh_enable();
> +}
> +
> +static int chtls_backlog_rcv(struct sock *sk, struct sk_buff *skb)
> +{
> +	if (skb->protocol) {
> +		kfree_skb(skb);
> +		return 0;
> +	}
> +	BLOG_SKB_CB(skb)->backlog_rcv(sk, skb);
> +	return 0;
> +}
> +
> +static struct sock *chtls_recv_sock(struct sock *lsk,
> +				    struct request_sock *oreq,
> +				    void *network_hdr,
> +				    const struct cpl_pass_accept_req *req,
> +				    struct chtls_dev *cdev)
> +
> +{
> +	struct sock *newsk;
> +	struct dst_entry *dst =3D NULL;
> +	const struct tcphdr *tcph;
> +	struct neighbour *n;
> +	struct net_device *ndev;
> +	struct chtls_sock *csk;
> +	struct tcp_sock *tp;
> +	struct inet_sock *newinet;
> +	u16 port_id;
> +	int step;
> +	int rxq_idx;
> +	const struct iphdr *iph =3D (const struct iphdr *)network_hdr;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	newsk =3D tcp_create_openreq_child(lsk, oreq, cdev->askb);
> +	if (!newsk)
> +		goto free_oreq;
> +
> +	dst =3D inet_csk_route_child_sock(lsk, newsk, oreq);
> +	if (!dst)
> +		goto free_sk;
> +
> +	tcph =3D (struct tcphdr *)(iph + 1);
> +	n =3D dst_neigh_lookup(dst, &iph->saddr);
> +	if (!n)
> +		goto free_sk;
> +
> +	ndev =3D n->dev;
> +	if (!ndev)
> +		goto free_sk;
> +	port_id =3D cxgb4_port_idx(ndev);
> +
> +	csk =3D chtls_sock_create(cdev);
> +	if (!csk)
> +		goto free_sk;
> +
> +	csk->l2t_entry =3D cxgb4_l2t_get(cdev->lldi->l2t, n, ndev, 0);
> +	if (!csk->l2t_entry)
> +		goto free_csk;
> +
> +	newsk->sk_user_data =3D csk;
> +	newsk->sk_backlog_rcv =3D chtls_backlog_rcv;
> +
> +	tp =3D tcp_sk(newsk);
> +	newinet =3D inet_sk(newsk);
> +
> +	newinet->inet_daddr =3D iph->saddr;
> +	newinet->inet_rcv_saddr =3D iph->daddr;
> +	newinet->inet_saddr =3D iph->daddr;
> +
> +	oreq->ts_recent =3D PASS_OPEN_TID_G(ntohl(req->tos_stid));
> +	sk_setup_caps(newsk, dst);
> +	csk->sk =3D newsk;
> +	csk->passive_reap_next =3D oreq;
> +	csk->tx_chan =3D cxgb4_port_chan(ndev);
> +	csk->port_id =3D port_id;
> +	csk->egress_dev =3D ndev;
> +	csk->tos =3D PASS_OPEN_TOS_G(ntohl(req->tos_stid));
> +	csk->ulp_mode =3D ULP_MODE_TLS;
> +	step =3D cdev->lldi->nrxq / cdev->lldi->nchan;
> +	csk->rss_qid =3D cdev->lldi->rxq_ids[port_id * step];
> +	rxq_idx =3D port_id * step;
> +	csk->txq_idx =3D (rxq_idx < cdev->lldi->ntxq) ? rxq_idx :
> +			port_id * step;
> +	csk->sndbuf =3D newsk->sk_sndbuf;
> +	csk->smac_idx =3D cxgb4_tp_smt_idx(cdev->lldi->adapter_type,
> +					 cxgb4_port_viid(ndev));
> +	tp->rcv_wnd =3D select_rcv_wnd(csk);
> +
> +	neigh_release(n);
> +	lsk->sk_prot->hash(newsk);
> +	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
> +	bh_unlock_sock(newsk);

Where is this locked?
[Atul] tcp_create_openreq_child ->sk_clone_lock
> +
> +	return newsk;
> +free_csk:
> +	chtls_sock_release(&csk->kref);
> +free_sk:
> +	dst_release(dst);
> +free_oreq:
> +	chtls_reqsk_free(oreq);
> +	return NULL;
> +}
> +
> +/*
> + * Populate a TID_RELEASE WR.  The skb must be already propely sized.
> + */
> +static  void mk_tid_release(struct sk_buff *skb,
> +			    unsigned int chan, unsigned int tid)
> +{
> +	struct cpl_tid_release *req;
> +	unsigned int len =3D roundup(sizeof(struct cpl_tid_release), 16);

Reverse christmas tree format?
[Atul] will take care in v2

> +	req =3D (struct cpl_tid_release *)__skb_put(skb, len);
> +	memset(req, 0, len);
> +	set_wr_txq(skb, CPL_PRIORITY_SETUP, chan);
> +	INIT_TP_WR_CPL(req, CPL_TID_RELEASE, tid);
> +}
> +
> +static int chtls_get_module(struct sock *sk)
> +{
> +	struct inet_connection_sock *icsk =3D inet_csk(sk);
> +
> +	if (!try_module_get(icsk->icsk_ulp_ops->owner))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static void chtls_pass_accept_request(struct sock *sk,
> +				      struct sk_buff *skb)
> +{
> +	struct sock *newsk;
> +	struct sk_buff *reply_skb;
> +	struct cpl_t5_pass_accept_rpl *rpl;
> +	struct cpl_pass_accept_req *req =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int tid =3D GET_TID(req);
> +	struct ethhdr *eh;
> +	struct iphdr *iph;
> +	struct tcphdr *tcph;
> +	struct request_sock *oreq =3D NULL;
> +	void *network_hdr;
> +	unsigned int len =3D roundup(sizeof(*rpl), 16);
> +	struct chtls_dev *cdev =3D BLOG_SKB_CB(skb)->cdev;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	newsk =3D lookup_tid(cdev->tids, tid);
> +	if (newsk) {
> +		pr_info("tid (%d) already in use\n", tid);
> +		return;
> +	}
> +
> +	reply_skb =3D alloc_skb(len, GFP_ATOMIC);
> +	if (!reply_skb) {
> +		cxgb4_remove_tid(cdev->tids, 0, tid, sk->sk_family);
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	if (sk->sk_state !=3D TCP_LISTEN)
> +		goto reject;
> +
> +	if (inet_csk_reqsk_queue_is_full(sk))
> +		goto reject;
> +
> +	if (sk_acceptq_is_full(sk))
> +		goto reject;
> +
> +	oreq =3D inet_reqsk_alloc(&chtls_rsk_ops, sk, true);
> +	if (!oreq)
> +		goto reject;
> +
> +	oreq->rsk_rcv_wnd =3D 0;
> +	oreq->rsk_window_clamp =3D 0;
> +	oreq->cookie_ts =3D 0;
> +	oreq->mss =3D 0;
> +	oreq->ts_recent =3D 0;
> +
> +	eh =3D (struct ethhdr *)(req + 1);
> +	iph =3D (struct iphdr *)(eh + 1);
> +	if (iph->version !=3D 0x4)
> +		goto reject;
> +
> +	network_hdr =3D (void *)(eh + 1);
> +	tcph =3D (struct tcphdr *)(iph + 1);
> +
> +	tcp_rsk(oreq)->tfo_listener =3D false;
> +	tcp_rsk(oreq)->rcv_isn =3D ntohl(tcph->seq);
> +	chtls_set_req_port(oreq, tcph->source, tcph->dest);
> +	inet_rsk(oreq)->ecn_ok =3D 0;
> +	chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
> +	chtls_set_req_opt(oreq, NULL);
> +	if (req->tcpopt.wsf <=3D 14) {
> +		inet_rsk(oreq)->wscale_ok =3D 1;
> +		inet_rsk(oreq)->snd_wscale =3D req->tcpopt.wsf;
> +	}
> +	inet_rsk(oreq)->ir_iif =3D sk->sk_bound_dev_if;
> +
> +	newsk =3D chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
> +	if (!newsk)
> +		goto reject;
> +
> +	if (chtls_get_module(newsk))
> +		goto reject;
> +	inet_csk_reqsk_queue_added(sk);
> +	reply_skb->sk =3D newsk;
> +	chtls_install_cpl_ops(newsk);
> +	cxgb4_insert_tid(cdev->tids, newsk, tid, newsk->sk_family);
> +	chtls_pass_accept_rpl(reply_skb, req, tid);
> +	kfree_skb(skb);
> +	return;
> +
> +reject:

Is this leaking oreq from inet_reqsk_alloc() above?
[Atul] will take care in v2

> +	mk_tid_release(reply_skb, 0, tid);
> +	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
> +	kfree_skb(skb);
> +}
> +
> +/*
> + * Handle a CPL_PASS_ACCEPT_REQ message.
> + */
> +static int chtls_pass_accept_req(struct chtls_dev *cdev, struct sk_buff =
*skb)
> +{
> +	struct cpl_pass_accept_req *req =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int stid =3D PASS_OPEN_TID_G(ntohl(req->tos_stid));
> +	unsigned int tid =3D GET_TID(req);
> +	void *data;
> +	struct listen_ctx *ctx;
> +	struct sock *lsk;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	data =3D lookup_stid(cdev->tids, stid);
> +	if (!data)
> +		return 1;
> +
> +	ctx =3D (struct listen_ctx *)data;
> +	lsk =3D ctx->lsk;
> +
> +	if (unlikely(tid >=3D cdev->tids->ntids)) {
> +		pr_info("passive open TID %u too large\n", tid);
> +		return 1;
> +	}
> +
> +	BLOG_SKB_CB(skb)->cdev =3D cdev;
> +	process_cpl_msg(chtls_pass_accept_request, lsk, skb);
> +	return 0;
> +}
> +
> +/*
> + * Completes some final bits of initialization for just established conn=
ections
> + * and changes their state to TCP_ESTABLISHED.
> + *
> + * snd_isn here is the ISN after the SYN, i.e., the true ISN + 1.
> + */
> +static void make_established(struct sock *sk, u32 snd_isn, unsigned int =
opt)
> +{
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +	tp->pushed_seq =3D snd_isn;
> +	tp->write_seq =3D snd_isn;
> +	tp->snd_nxt =3D snd_isn;
> +	tp->snd_una =3D snd_isn;
> +	inet_sk(sk)->inet_id =3D tp->write_seq ^ jiffies;

What is the purpose of xor'ing this with jiffies?
[Atul] borrowed from tcp_v4_syn_recv_sock [inet->inet_id =3D tp->write_seq =
^ jiffies;]

> +	assign_rxopt(sk, opt);

Reverse christmas tree format?

> +
> +	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
> +		tp->rcv_wup -=3D tp->rcv_wnd - (RCV_BUFSIZ_M << 10);
> +
> +	dst_confirm(sk->sk_dst_cache);
> +
> +	smp_mb();
> +	tcp_set_state(sk, TCP_ESTABLISHED);
> +}
> +
> +static void chtls_abort_conn(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct sk_buff *abort_skb;
> +
> +	abort_skb =3D alloc_skb(sizeof(struct cpl_abort_req), GFP_ATOMIC);
> +	if (abort_skb)
> +		chtls_send_reset(sk, CPL_ABORT_SEND_RST, abort_skb);
> +}
> +
> +static struct sock *reap_list;
> +static DEFINE_SPINLOCK(reap_list_lock);
> +
> +/*
> + * Process the reap list.
> + */
> +DECLARE_TASK_FUNC(process_reap_list, task_param)
> +{
> +	spin_lock_bh(&reap_list_lock);
> +	while (reap_list) {
> +		struct sock *sk =3D reap_list;
> +		struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +
> +		reap_list =3D csk->passive_reap_next;
> +		csk->passive_reap_next =3D NULL;
> +		spin_unlock(&reap_list_lock);
> +		sock_hold(sk);
> +
> +		bh_lock_sock(sk);
> +		chtls_abort_conn(sk, NULL);
> +		sock_orphan(sk);
> +		if (sk->sk_state =3D=3D TCP_CLOSE)
> +			inet_csk_destroy_sock(sk);
> +		bh_unlock_sock(sk);
> +		sock_put(sk);
> +		spin_lock(&reap_list_lock);

Could it be that you are missing a spin_unlock() here?
[Atul] unlock is called in add_to_reap_list where reap task is called

> +	}
> +	spin_unlock_bh(&reap_list_lock);
> +}
> +
> +static DECLARE_WORK(reap_task, process_reap_list);
> +
> +static void add_to_reap_list(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D sk->sk_user_data;
> +
> +	local_bh_disable();
> +	bh_lock_sock(sk);
> +	release_tcp_port(sk); /* release the port immediately */
> +
> +	spin_lock(&reap_list_lock);
> +	csk->passive_reap_next =3D reap_list;
> +	reap_list =3D sk;
> +	if (!csk->passive_reap_next)
> +		schedule_work(&reap_task);
> +	spin_unlock(&reap_list_lock);
> +	bh_unlock_sock(sk);
> +	local_bh_enable();
> +}
> +
> +static void add_pass_open_to_parent(struct sock *child, struct sock *lsk=
,
> +				    struct chtls_dev *cdev)
> +{
> +	struct chtls_sock *csk =3D child->sk_user_data;
> +	struct request_sock *oreq;
> +
> +	if (lsk->sk_state !=3D TCP_LISTEN)
> +		return;
> +
> +	oreq =3D csk->passive_reap_next;
> +	csk->passive_reap_next =3D NULL;
> +
> +	reqsk_queue_removed(&inet_csk(lsk)->icsk_accept_queue, oreq);
> +
> +	if (sk_acceptq_is_full(lsk)) {
> +		chtls_reqsk_free(oreq);
> +		add_to_reap_list(child);
> +	} else {
> +		refcount_set(&oreq->rsk_refcnt, 1);
> +		inet_csk_reqsk_queue_add(lsk, oreq, child);
> +		lsk->sk_data_ready(lsk);
> +	}
> +}
> +
> +static void bl_add_pass_open_to_parent(struct sock *lsk, struct sk_buff =
*skb)
> +{
> +	struct sock *child =3D skb->sk;
> +
> +	skb->sk =3D NULL;
> +	add_pass_open_to_parent(child, lsk, BLOG_SKB_CB(skb)->cdev);
> +	kfree_skb(skb);
> +}
> +
> +static int chtls_pass_establish(struct chtls_dev *cdev, struct sk_buff *=
skb)
> +{
> +	struct cpl_pass_establish *req =3D cplhdr(skb) + RSS_HDR;
> +	struct chtls_sock *csk;
> +	struct sock *lsk, *sk;
> +	unsigned int hwtid =3D GET_TID(req);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	if (!sk)
> +		return 1;
> +
> +	bh_lock_sock(sk);
> +	if (unlikely(sock_owned_by_user(sk))) {
> +		kfree_skb(skb);
> +	} else {
> +		void *data;
> +		unsigned int stid;
> +
> +		csk =3D sk->sk_user_data;
> +		csk->wr_max_credits =3D 64;
> +		csk->wr_credits =3D 64;
> +		csk->wr_unacked =3D 0;
> +		make_established(sk, ntohl(req->snd_isn), ntohs(req->tcp_opt));
> +		stid =3D PASS_OPEN_TID_G(ntohl(req->tos_stid));
> +		sk->sk_state_change(sk);
> +		if (unlikely(sk->sk_socket))
> +			sk_wake_async(sk, 0, POLL_OUT);
> +
> +		data =3D lookup_stid(cdev->tids, stid);
> +		lsk =3D ((struct listen_ctx *)data)->lsk;
> +
> +		bh_lock_sock(lsk);
> +		if (likely(!sock_owned_by_user(lsk))) {
> +			kfree_skb(skb);
> +			add_pass_open_to_parent(sk, lsk, cdev);
> +		} else {
> +			skb->sk =3D sk;
> +			BLOG_SKB_CB(skb)->cdev =3D cdev;
> +			BLOG_SKB_CB(skb)->backlog_rcv =3D
> +				bl_add_pass_open_to_parent;
> +			__sk_add_backlog(lsk, skb);
> +		}
> +		bh_unlock_sock(lsk);
> +	}
> +	bh_unlock_sock(sk);
> +	return 0;
> +}
> +
> +/*
> + * Handle receipt of an urgent pointer.
> + */
> +static void handle_urg_ptr(struct sock *sk, u32 urg_seq)
> +{
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +	urg_seq--;
> +	if (tp->urg_data && !after(urg_seq, tp->urg_seq))
> +		return;	/* duplicate pointer */
> +
> +	sk_send_sigurg(sk);
> +	if (tp->urg_seq =3D=3D tp->copied_seq && tp->urg_data &&
> +	    !sock_flag(sk, SOCK_URGINLINE) &&
> +	    tp->copied_seq !=3D tp->rcv_nxt) {
> +		struct sk_buff *skb =3D skb_peek(&sk->sk_receive_queue);
> +
> +		tp->copied_seq++;
> +		if (skb && tp->copied_seq - ULP_SKB_CB(skb)->seq >=3D skb->len)
> +			chtls_free_skb(sk, skb);
> +	}
> +
> +	tp->urg_data =3D TCP_URG_NOTYET;
> +	tp->urg_seq =3D urg_seq;
> +}
> +
> +static void check_sk_callbacks(struct chtls_sock *csk)
> +{
> +	struct sock *sk =3D csk->sk;
> +
> +	if (unlikely(sk->sk_user_data &&
> +		     !csk_flag_nochk(csk, CSK_CALLBACKS_CHKD)))
> +		csk_set_flag(csk, CSK_CALLBACKS_CHKD);
> +}
> +
> +/*
> + * Handles Rx data that arrives in a state where the socket isn't accept=
ing
> + * new data.
> + */
> +static void handle_excess_rx(struct sock *sk, struct sk_buff *skb)
> +{
> +	if (!csk_flag(sk, CSK_ABORT_SHUTDOWN))
> +		chtls_abort_conn(sk, skb);
> +
> +	kfree_skb(skb);
> +}
> +
> +static void chtls_recv_data(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_rx_data *hdr =3D cplhdr(skb) + RSS_HDR;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	if (unlikely(sk->sk_shutdown & RCV_SHUTDOWN)) {
> +		handle_excess_rx(sk, skb);
> +		return;
> +	}
> +
> +	ULP_SKB_CB(skb)->seq =3D ntohl(hdr->seq);
> +	ULP_SKB_CB(skb)->psh =3D hdr->psh;
> +	skb_ulp_mode(skb) =3D ULP_MODE_NONE;
> +
> +	skb_reset_transport_header(skb);
> +	__skb_pull(skb, sizeof(*hdr) + RSS_HDR);
> +	if (!skb->data_len)
> +		__skb_trim(skb, ntohs(hdr->len));
> +
> +	if (unlikely(hdr->urg))
> +		handle_urg_ptr(sk, tp->rcv_nxt + ntohs(hdr->urg));
> +	if (unlikely(tp->urg_data =3D=3D TCP_URG_NOTYET &&
> +		     tp->urg_seq - tp->rcv_nxt < skb->len))
> +		tp->urg_data =3D TCP_URG_VALID |
> +			       skb->data[tp->urg_seq - tp->rcv_nxt];
> +
> +	if (unlikely(hdr->dack_mode !=3D csk->delack_mode)) {
> +		csk->delack_mode =3D hdr->dack_mode;
> +		csk->delack_seq =3D tp->rcv_nxt;
> +	}
> +
> +	tcp_hdr(skb)->fin =3D 0;
> +	tp->rcv_nxt +=3D skb->len;
> +
> +	__skb_queue_tail(&sk->sk_receive_queue, skb);
> +
> +	if (!sock_flag(sk, SOCK_DEAD)) {
> +		check_sk_callbacks(csk);
> +		sk->sk_data_ready(sk);
> +	}
> +}
> +
> +static int chtls_rx_data(struct chtls_dev *cdev, struct sk_buff *skb)
> +{
> +	struct sock *sk;
> +	struct cpl_rx_data *req =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int hwtid =3D GET_TID(req);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	skb_dst_set(skb, NULL);
> +	process_cpl_msg(chtls_recv_data, sk, skb);
> +	return 0;
> +}
> +
> +static void chtls_recv_pdu(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_hws *tlsk =3D &csk->tlshws;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_tls_data *hdr =3D cplhdr(skb);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	if (unlikely(sk->sk_shutdown & RCV_SHUTDOWN)) {
> +		handle_excess_rx(sk, skb);
> +		return;
> +	}
> +
> +	ULP_SKB_CB(skb)->seq =3D ntohl(hdr->seq);
> +	ULP_SKB_CB(skb)->flags =3D 0;
> +	skb_ulp_mode(skb) =3D ULP_MODE_TLS;
> +
> +	skb_reset_transport_header(skb);
> +	__skb_pull(skb, sizeof(*hdr));
> +	if (!skb->data_len)
> +		__skb_trim(skb,
> +			   CPL_TLS_DATA_LENGTH_G(ntohl(hdr->length_pkd)));
> +
> +	if (unlikely(tp->urg_data =3D=3D TCP_URG_NOTYET && tp->urg_seq -
> +		     tp->rcv_nxt < skb->len))
> +		tp->urg_data =3D TCP_URG_VALID |
> +			       skb->data[tp->urg_seq - tp->rcv_nxt];
> +
> +	tcp_hdr(skb)->fin =3D 0;
> +	tlsk->pldlen =3D CPL_TLS_DATA_LENGTH_G(ntohl(hdr->length_pkd));
> +	__skb_queue_tail(&tlsk->sk_recv_queue, skb);
> +}
> +
> +static int chtls_rx_pdu(struct chtls_dev *cdev, struct sk_buff *skb)
> +{
> +	struct sock *sk;
> +	struct cpl_tls_data *req =3D cplhdr(skb);
> +	unsigned int hwtid =3D GET_TID(req);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	skb_dst_set(skb, NULL);
> +	process_cpl_msg(chtls_recv_pdu, sk, skb);
> +	return 0;
> +}
> +
> +static void chtls_set_hdrlen(struct sk_buff *skb, unsigned int nlen)
> +{
> +	struct tlsrx_cmp_hdr *tls_cmp_hdr =3D cplhdr(skb);
> +
> +	skb->hdr_len =3D ntohs(tls_cmp_hdr->length);
> +	tls_cmp_hdr->length =3D ntohs(nlen);
> +}
> +
> +static void chtls_rx_hdr(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct chtls_hws *tlsk =3D &csk->tlshws;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_rx_tls_cmp *cmp_cpl =3D cplhdr(skb);
> +	struct sk_buff *skb_rec =3D NULL;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	ULP_SKB_CB(skb)->seq =3D ntohl(cmp_cpl->seq);
> +	ULP_SKB_CB(skb)->flags =3D 0;
> +
> +	skb_reset_transport_header(skb);
> +	__skb_pull(skb, sizeof(*cmp_cpl));
> +	if (!skb->data_len)
> +		__skb_trim(skb, CPL_RX_TLS_CMP_LENGTH_G
> +				(ntohl(cmp_cpl->pdulength_length)));
> +
> +	tp->rcv_nxt +=3D
> +		CPL_RX_TLS_CMP_PDULENGTH_G(ntohl(cmp_cpl->pdulength_length));
> +
> +	skb_rec =3D __skb_dequeue(&tlsk->sk_recv_queue);
> +	if (!skb_rec) {
> +		ULP_SKB_CB(skb)->flags |=3D ULPCB_FLAG_TLS_ND;
> +		__skb_queue_tail(&sk->sk_receive_queue, skb);
> +	} else {
> +		chtls_set_hdrlen(skb, tlsk->pldlen);
> +		tlsk->pldlen =3D 0;
> +		__skb_queue_tail(&sk->sk_receive_queue, skb);
> +		__skb_queue_tail(&sk->sk_receive_queue, skb_rec);
> +	}
> +
> +	if (!sock_flag(sk, SOCK_DEAD)) {
> +		check_sk_callbacks(csk);
> +		sk->sk_data_ready(sk);
> +	}
> +}
> +
> +static int chtls_rx_cmp(struct chtls_dev *cdev, struct sk_buff *skb)
> +{
> +	struct sock *sk;
> +	struct cpl_rx_tls_cmp *req =3D cplhdr(skb);
> +	unsigned int hwtid =3D GET_TID(req);
> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	skb_dst_set(skb, NULL);
> +	process_cpl_msg(chtls_rx_hdr, sk, skb);
> +
> +	return 0;
> +}
> +
> +static void chtls_timewait(struct sock *sk)
> +{
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +	tp->rcv_nxt++;
> +	tp->rx_opt.ts_recent_stamp =3D get_seconds();
> +	tp->srtt_us =3D 0;
> +	tcp_time_wait_p(sk, TCP_TIME_WAIT, 0);
> +}
> +
> +static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +
> +	sk->sk_shutdown |=3D RCV_SHUTDOWN;
> +	sock_set_flag(sk, SOCK_DONE);
> +
> +	switch (sk->sk_state) {
> +	case TCP_SYN_RECV:
> +	case TCP_ESTABLISHED:
> +		tcp_set_state(sk, TCP_CLOSE_WAIT);
> +		break;
> +	case TCP_FIN_WAIT1:
> +		tcp_set_state(sk, TCP_CLOSING);
> +		break;
> +	case TCP_FIN_WAIT2:
> +		chtls_release_resources(sk);
> +		if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
> +			chtls_conn_done(sk);
> +		else
> +			chtls_timewait(sk);
> +		break;
> +	default:
> +		pr_info("cpl_peer_close in bad state %d\n", sk->sk_state);
> +	}
> +
> +	if (!sock_flag(sk, SOCK_DEAD)) {
> +		sk->sk_state_change(sk);
> +		/* Do not send POLL_HUP for half duplex close. */
> +
> +		if ((sk->sk_shutdown & SEND_SHUTDOWN) ||
> +		    sk->sk_state =3D=3D TCP_CLOSE)
> +			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
> +		else
> +			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
> +	}
> +}
> +
> +static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_close_con_rpl *rpl =3D cplhdr(skb) + RSS_HDR;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	tp->snd_una =3D ntohl(rpl->snd_nxt) - 1;  /* exclude FIN */
> +
> +	switch (sk->sk_state) {
> +	case TCP_CLOSING:
> +		chtls_release_resources(sk);
> +		if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING))
> +			chtls_conn_done(sk);
> +		else
> +			chtls_timewait(sk);
> +		break;
> +	case TCP_LAST_ACK:
> +		chtls_release_resources(sk);
> +		chtls_conn_done(sk);
> +		break;
> +	case TCP_FIN_WAIT1:
> +		tcp_set_state(sk, TCP_FIN_WAIT2);
> +		sk->sk_shutdown |=3D SEND_SHUTDOWN;
> +		dst_confirm(sk->sk_dst_cache);
> +
> +		if (!sock_flag(sk, SOCK_DEAD))
> +			sk->sk_state_change(sk);
> +		else if (tcp_sk(sk)->linger2 < 0 &&
> +			 !csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN))
> +			chtls_abort_conn(sk, skb);
> +		break;
> +	default:
> +		pr_info("close_con_rpl in bad state %d\n", sk->sk_state);
> +	}
> +	kfree_skb(skb);
> +}
> +
> +static struct sk_buff *get_cpl_skb(struct sk_buff *skb,
> +				   size_t len, gfp_t gfp)
> +{
> +	if (likely(!skb_is_nonlinear(skb) && !skb_cloned(skb))) {
> +		WARN_ONCE(skb->len < len, "skb alloc error");
> +		__skb_trim(skb, len);
> +		skb_get(skb);
> +	} else {
> +		skb =3D alloc_skb(len, gfp);
> +		if (skb)
> +			__skb_put(skb, len);
> +	}
> +	return skb;
> +}
> +
> +static void set_abort_rpl_wr(struct sk_buff *skb, unsigned int tid,
> +			     int cmd)
> +{
> +	struct cpl_abort_rpl *rpl =3D cplhdr(skb);
> +
> +	INIT_TP_WR_CPL(rpl, CPL_ABORT_RPL, tid);
> +	rpl->cmd =3D cmd;
> +}
> +
> +static void send_defer_abort_rpl(struct chtls_dev *cdev, struct sk_buff =
*skb)
> +{
> +	struct sk_buff *reply_skb;
> +	struct cpl_abort_req_rss *req =3D cplhdr(skb);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	reply_skb =3D alloc_skb(sizeof(struct cpl_abort_rpl),
> +			      GFP_KERNEL | __GFP_NOFAIL);
> +	if (!reply_skb)
> +		return;
> +
> +	__skb_put(reply_skb, sizeof(struct cpl_abort_rpl));
> +	set_abort_rpl_wr(reply_skb, GET_TID(req),
> +			 (req->status & CPL_ABORT_NO_RST));
> +	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, req->status >> 1);
> +	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
> +	kfree_skb(skb);
> +}
> +
> +static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
> +			   struct chtls_dev *cdev, int status, int queue)
> +{
> +	struct sk_buff *reply_skb;
> +	struct cpl_abort_req_rss *req =3D cplhdr(skb);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	reply_skb =3D alloc_skb(sizeof(struct cpl_abort_rpl),
> +			      GFP_KERNEL);
> +
> +	if (!reply_skb) {
> +		req->status =3D (queue << 1);
> +		send_defer_abort_rpl(cdev, skb);
> +		return;
> +	}
> +
> +	set_abort_rpl_wr(reply_skb, GET_TID(req), status);
> +	kfree_skb(skb);
> +
> +	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
> +	if (sock_flag(sk, SOCK_INLINE)) {
> +		struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +		struct l2t_entry *e =3D csk->l2t_entry;
> +
> +		if (e && sk->sk_state !=3D TCP_SYN_RECV) {
> +			cxgb4_l2t_send(csk->egress_dev, reply_skb, e);
> +			return;
> +		}
> +	}
> +	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
> +}
> +
> +/*
> + * Add an skb to the deferred skb queue for processing from process cont=
ext.
> + */
> +void t4_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
> +		    defer_handler_t handler)
> +{
> +	DEFERRED_SKB_CB(skb)->handler =3D handler;
> +	spin_lock_bh(&cdev->deferq.lock);
> +	__skb_queue_tail(&cdev->deferq, skb);
> +	if (skb_queue_len(&cdev->deferq) =3D=3D 1)
> +		schedule_work(&cdev->deferq_task);
> +	spin_unlock_bh(&cdev->deferq.lock);
> +}
> +
> +static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
> +				 struct chtls_dev *cdev,
> +				 int status, int queue)
> +{
> +	struct sk_buff *reply_skb;
> +	struct cpl_abort_req_rss *req =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int tid =3D GET_TID(req);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	reply_skb =3D get_cpl_skb(skb, sizeof(struct cpl_abort_rpl), gfp_any())=
;
> +	if (!reply_skb) {
> +		req->status =3D (queue << 1) | status;
> +		t4_defer_reply(skb, cdev, send_defer_abort_rpl);
> +		return;
> +	}
> +
> +	set_abort_rpl_wr(reply_skb, tid, status);
> +	set_wr_txq(reply_skb, CPL_PRIORITY_DATA, queue);
> +	if (sock_flag(sk, SOCK_INLINE)) {
> +		struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +		struct l2t_entry *e =3D csk->l2t_entry;
> +
> +		if (e && sk->sk_state !=3D TCP_SYN_RECV) {
> +			cxgb4_l2t_send(csk->egress_dev, reply_skb, e);
> +			return;
> +		}
> +	}
> +	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
> +	kfree_skb(skb);
> +}
> +
> +/*
> + * This is run from a listener's backlog to abort a child connection in
> + * SYN_RCV state (i.e., one on the listener's SYN queue).
> + */
> +static void bl_abort_syn_rcv(struct sock *lsk, struct sk_buff *skb)
> +{
> +	struct sock *child =3D skb->sk;
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(child);
> +	int queue =3D csk->txq_idx;
> +
> +	skb->sk	=3D NULL;
> +	do_abort_syn_rcv(child, lsk);
> +	send_abort_rpl(child, skb, BLOG_SKB_CB(skb)->cdev,
> +		       CPL_ABORT_NO_RST, queue);
> +}
> +
> +static int abort_syn_rcv(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D sk->sk_user_data;
> +	struct chtls_dev *cdev =3D csk->cdev;
> +	const struct request_sock *oreq =3D csk->passive_reap_next;
> +	struct listen_ctx *listen_ctx;
> +	struct sock *psk;
> +	void *ctx;
> +
> +	if (!oreq)
> +		return -1;
> +
> +	ctx =3D lookup_stid(cdev->tids, oreq->ts_recent);
> +	if (!ctx)
> +		return -1;
> +
> +	listen_ctx =3D (struct listen_ctx *)ctx;
> +	psk =3D listen_ctx->lsk;
> +
> +	bh_lock_sock(psk);
> +	if (!sock_owned_by_user(psk)) {
> +		int queue =3D csk->txq_idx;
> +
> +		do_abort_syn_rcv(sk, psk);
> +		send_abort_rpl(sk, skb, cdev, CPL_ABORT_NO_RST, queue);
> +	} else {
> +		skb->sk =3D sk;
> +		BLOG_SKB_CB(skb)->backlog_rcv =3D bl_abort_syn_rcv;
> +		__sk_add_backlog(psk, skb);
> +	}
> +	bh_unlock_sock(psk);
> +	return 0;
> +}
> +
> +static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D sk->sk_user_data;
> +	const struct cpl_abort_req_rss *req =3D cplhdr(skb) + RSS_HDR;
> +	int queue =3D csk->txq_idx;
> +	int rst_status =3D CPL_ABORT_NO_RST;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	if (is_neg_adv(req->status)) {
> +		if (sk->sk_state =3D=3D TCP_SYN_RECV)
> +			chtls_set_tcb_tflag(sk, 0, 0);
> +
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	csk_reset_flag(csk, CSK_ABORT_REQ_RCVD);
> +
> +	if (!csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN) &&
> +	    !csk_flag_nochk(csk, CSK_TX_DATA_SENT)) {
> +		struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +		if (send_tx_flowc_wr(sk, 0, tp->snd_nxt, tp->rcv_nxt) < 0)
> +			WARN_ONCE(1, "send_tx_flowc error");
> +		csk_set_flag(csk, CSK_TX_DATA_SENT);
> +	}
> +
> +	csk_set_flag(csk, CSK_ABORT_SHUTDOWN);
> +
> +	if (!csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING)) {
> +		sk->sk_err =3D ETIMEDOUT;
> +
> +		if (!sock_flag(sk, SOCK_DEAD))
> +			sk->sk_error_report(sk);
> +
> +		if (sk->sk_state =3D=3D TCP_SYN_RECV && !abort_syn_rcv(sk, skb))
> +			return;
> +
> +		chtls_release_resources(sk);
> +		chtls_conn_done(sk);
> +	}
> +
> +	chtls_send_abort_rpl(sk, skb, csk->cdev, rst_status, queue);
> +}
> +
> +static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct cpl_abort_rpl_rss *rpl =3D cplhdr(skb) + RSS_HDR;
> +	struct chtls_dev *cdev =3D csk->cdev;
> +
> +	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING)) {
> +		csk_reset_flag(csk, CSK_ABORT_RPL_PENDING);
> +		if (!csk_flag_nochk(csk, CSK_ABORT_REQ_RCVD)) {
> +			if (sk->sk_state =3D=3D TCP_SYN_SENT) {
> +				cxgb4_remove_tid(cdev->tids,
> +						 csk->port_id,
> +						 GET_TID(rpl),
> +						 sk->sk_family);
> +				sock_put(sk);
> +			}
> +			chtls_release_resources(sk);
> +			chtls_conn_done(sk);
> +		}
> +	}
> +	kfree_skb(skb);
> +}
> +
> +static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
> +{
> +	struct sock *sk;
> +	struct cpl_peer_close *req =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int hwtid =3D GET_TID(req);
> +	void (*fn)(struct sock *sk, struct sk_buff *skb);
> +	u8 opcode =3D ((const struct rss_header *)cplhdr(skb))->opcode;

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	if (!sk)
> +		goto rel_skb;
> +
> +	switch (opcode) {
> +	case CPL_PEER_CLOSE:
> +		fn =3D chtls_peer_close;
> +		break;
> +	case CPL_CLOSE_CON_RPL:
> +		fn =3D chtls_close_con_rpl;
> +		break;
> +	case CPL_ABORT_REQ_RSS:
> +		fn =3D chtls_abort_req_rss;
> +		break;
> +	case CPL_ABORT_RPL_RSS:
> +		fn =3D chtls_abort_rpl_rss;
> +		break;
> +	default:
> +		goto rel_skb;
> +	}
> +
> +	process_cpl_msg(fn, sk, skb);
> +	return 0;
> +
> +rel_skb:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static struct sk_buff *dequeue_wr(struct sock *sk)
> +{
> +	struct chtls_sock *csk =3D rcu_dereference_sk_user_data(sk);
> +	struct sk_buff *skb =3D csk->wr_skb_head;
> +
> +	if (likely(skb)) {
> +	/* Don't bother clearing the tail */
> +		csk->wr_skb_head =3D WR_SKB_CB(skb)->next_wr;
> +		WR_SKB_CB(skb)->next_wr =3D NULL;
> +	}
> +	return skb;
> +}
> +
> +static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct chtls_sock *csk =3D sk->sk_user_data;
> +	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct cpl_fw4_ack *hdr =3D cplhdr(skb) + RSS_HDR;
> +	u8 credits =3D hdr->credits;
> +	u32 snd_una =3D ntohl(hdr->snd_una);

Reverse christmas tree format?
[Atul] will take care in v2

> +
> +	csk->wr_credits +=3D credits;
> +
> +	if (csk->wr_unacked > csk->wr_max_credits - csk->wr_credits)
> +		csk->wr_unacked =3D csk->wr_max_credits - csk->wr_credits;
> +
> +	while (credits) {
> +		struct sk_buff *pskb =3D csk->wr_skb_head;
> +
> +		if (unlikely(!pskb)) {
> +			if (csk->wr_nondata)
> +				csk->wr_nondata -=3D credits;
> +				break;
> +			}
> +		if (unlikely(credits < pskb->csum)) {
> +			pskb->csum -=3D credits;
> +			break;
> +		}
> +		dequeue_wr(sk);
> +		credits -=3D pskb->csum;
> +		kfree_skb(pskb);
> +	}
> +	if (hdr->seq_vld & CPL_FW4_ACK_FLAGS_SEQVAL) {
> +		if (unlikely(before(snd_una, tp->snd_una))) {
> +			kfree_skb(skb);
> +			return;
> +		}
> +
> +		if (tp->snd_una !=3D snd_una) {
> +			tp->snd_una =3D snd_una;
> +			dst_confirm(sk->sk_dst_cache);
> +			tp->rcv_tstamp =3D tcp_time_stamp(tp);
> +			if (tp->snd_una =3D=3D tp->snd_nxt &&
> +			    !csk_flag_nochk(csk, CSK_TX_FAILOVER))
> +				csk_reset_flag(csk, CSK_TX_WAIT_IDLE);
> +		}
> +	}
> +
> +	if (hdr->seq_vld & CPL_FW4_ACK_FLAGS_CH) {
> +		unsigned int fclen16 =3D roundup(failover_flowc_wr_len, 16);
> +
> +		csk->wr_credits -=3D fclen16;
> +		csk_reset_flag(csk, CSK_TX_WAIT_IDLE);
> +		csk_reset_flag(csk, CSK_TX_FAILOVER);
> +	}
> +	if (skb_queue_len(&csk->txq) && chtls_push_frames(csk, 0))
> +		sk->sk_write_space(sk);
> +		kfree_skb(skb);

I guess you actually always want to kfree_skb(skb) here, right?
[Atul] yes

> +}
> +
> +static int chtls_wr_ack(struct chtls_dev *cdev, struct sk_buff *skb)
> +{
> +	struct cpl_fw4_ack *rpl =3D cplhdr(skb) + RSS_HDR;
> +	unsigned int hwtid =3D GET_TID(rpl);
> +	struct sock *sk;
> +
> +	sk =3D lookup_tid(cdev->tids, hwtid);
> +	process_cpl_msg(chtls_rx_ack, sk, skb);
> +
> +	return 0;
> +}
> +
> +chtls_handler_func chtls_handlers[NUM_CPL_CMDS] =3D {
> +	[CPL_PASS_OPEN_RPL]     =3D chtls_pass_open_rpl,
> +	[CPL_CLOSE_LISTSRV_RPL] =3D chtls_close_listsrv_rpl,
> +	[CPL_PASS_ACCEPT_REQ]   =3D chtls_pass_accept_req,
> +	[CPL_PASS_ESTABLISH]    =3D chtls_pass_establish,
> +	[CPL_RX_DATA]           =3D chtls_rx_data,
> +	[CPL_TLS_DATA]          =3D chtls_rx_pdu,
> +	[CPL_RX_TLS_CMP]        =3D chtls_rx_cmp,
> +	[CPL_PEER_CLOSE]        =3D chtls_conn_cpl,
> +	[CPL_CLOSE_CON_RPL]     =3D chtls_conn_cpl,
> +	[CPL_ABORT_REQ_RSS]     =3D chtls_conn_cpl,
> +	[CPL_ABORT_RPL_RSS]     =3D chtls_conn_cpl,
> +	[CPL_FW4_ACK]           =3D chtls_wr_ack,
> +};

--=20
Stefano

Thanks
Atul
