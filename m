Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA291C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6502082E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfDLEb3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 00:31:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:22170 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfDLEb3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 00:31:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Apr 2019 21:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,340,1549958400"; 
   d="scan'208";a="148594113"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Apr 2019 21:31:27 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hEnqY-000DEZ-SY; Fri, 12 Apr 2019 12:31:26 +0800
Date:   Fri, 12 Apr 2019 12:30:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     kbuild-all@01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com, atul.gupta@chelsio.com
Subject: Re: [crypto 2/4] crypto/chelsio/chtls: hardware connect API
Message-ID: <201904121251.mCUeLNQa%lkp@intel.com>
References: <20190409152342.11200-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409152342.11200-1-atul.gupta@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Atul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on crypto/master]

url:    https://github.com/0day-ci/linux/commits/Atul-Gupta/Inline-TLS-client-and-v6-support/20190412-034407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/chelsio/chtls/chtls_cm.c:1254:42: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] atid_status @@    got e] atid_status @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1254:42:    expected restricted __be32 [usertype] atid_status
   drivers/crypto/chelsio/chtls/chtls_cm.c:1254:42:    got int
   drivers/crypto/chelsio/chtls/chtls_cm.c:1076:17: sparse: expression using sizeof(void)
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1272:40: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct socket_wq *wq @@    got struct socket_wq struct socket_wq *wq @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1272:40:    expected struct socket_wq *wq
   drivers/crypto/chelsio/chtls/chtls_cm.c:1272:40:    got struct socket_wq [noderef] <asn:4>*sk_wq
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1273:25: sparse: cast to restricted __poll_t
   drivers/crypto/chelsio/chtls/chtls_cm.c:1320:16: sparse: expression using sizeof(void)
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1470:60: sparse: Using plain integer as NULL pointer
   drivers/crypto/chelsio/chtls/chtls_cm.c:1573:22: sparse: context imbalance in 'chtls_recv_sock' - unexpected unlock

vim +1254 drivers/crypto/chelsio/chtls/chtls_cm.c

  1239	
  1240	static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb)
  1241	{
  1242		struct sock *sk = skb->sk;
  1243	
  1244		sock_hold(sk);
  1245		bh_lock_sock(sk);
  1246		if (sk->sk_state == TCP_SYN_SENT || sk->sk_state == TCP_SYN_RECV) {
  1247			if (!sock_owned_by_user(sk)) {
  1248				chtls_act_open_fail(sk, EHOSTUNREACH);
  1249				__kfree_skb(skb);
  1250			} else {
  1251				struct cpl_act_open_rpl *rpl = cplhdr(skb) + RSS_HDR;
  1252	
  1253				rpl->ot.opcode = CPL_ACT_OPEN_RPL;
> 1254				rpl->atid_status = CPL_ERR_ARP_MISS;
  1255				BLOG_SKB_CB(skb)->backlog_rcv = chtls_active_open_rpl;
  1256				__sk_add_backlog(sk, skb);
  1257			}
  1258		}
  1259		bh_unlock_sock(sk);
  1260		sock_put(sk);
  1261	}
  1262	
  1263	static void chtls_write_space(struct sock *sk)
  1264	{
  1265		struct socket *sock = sk->sk_socket;
  1266		struct socket_wq *wq;
  1267	
  1268		if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk) && sock) {
  1269			clear_bit(SOCK_NOSPACE, &sock->flags);
  1270			rcu_read_lock();
  1271			wq = rcu_dereference(sk->sk_wq);
> 1272			if (skwq_has_sleeper(sk->sk_wq))
> 1273				wake_up_interruptible_poll(&wq->wait, POLLOUT |
  1274							   POLLWRNORM |
  1275							   POLLWRBAND);
  1276			if (wq && wq->fasync_list && !(sk->sk_shutdown & SEND_SHUTDOWN))
  1277				sock_wake_async(wq, SOCK_WAKE_SPACE, POLL_OUT);
  1278			rcu_read_unlock();
  1279		}
  1280	}
  1281	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
