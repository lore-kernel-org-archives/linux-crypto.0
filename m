From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 3/3] tcp: use monotonic timestamps for PAWS
Date: Mon, 18 Jun 2018 17:22:15 +0200
Message-ID: <20180618152242.1566661-3-arnd@arndb.de>
References: <20180618152242.1566661-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, Michael Werner <werner@chelsio.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Ivan Delalande <colona@arista.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618152242.1566661-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Using get_seconds() for timestamps is deprecated since it can lead
to overflows on 32-bit systems. While the interface generally doesn't
overflow until year 2106, the specific implementation of the TCP PAWS
algorithm breaks in 2038 when the intermediate signed 32-bit timestamps
overflow.

A related problem is that the local timestamps in CLOCK_REALTIME form
lead to unexpected behavior when settimeofday is called to set the system
clock backwards or forwards by more than 24 days.

While the first problem could be solved by using an overflow-safe method
of comparing the timestamps, a nicer solution is to use a monotonic
clocksource with ktime_get_seconds() that simply doesn't overflow (at
least not until 136 years after boot) and that doesn't change during
settimeofday().

To make 32-bit and 64-bit architectures behave the same way here, and
also save a few bytes in the tcp_options_received structure, I'm changing
the type to a 32-bit integer, which is now safe on all architectures.

Finally, the ts_recent_stamp field also (confusingly) gets used to store
a jiffies value in tcp_synq_overflow()/tcp_synq_no_recent_overflow().
This is currently safe, but changing the type to 32-bit requires
some small changes there to keep it working.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |  2 +-
 include/linux/tcp.h                     |  4 ++--
 include/net/tcp.h                       | 15 ++++++++-------
 net/ipv4/tcp_input.c                    |  2 +-
 net/ipv4/tcp_ipv4.c                     |  2 +-
 net/ipv4/tcp_minisocks.c                |  8 ++++----
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 2bb6f0380758..0997e166ea57 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1673,7 +1673,7 @@ static void chtls_timewait(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	tp->rcv_nxt++;
-	tp->rx_opt.ts_recent_stamp = get_seconds();
+	tp->rx_opt.ts_recent_stamp = ktime_get_seconds();
 	tp->srtt_us = 0;
 	tcp_time_wait(sk, TCP_TIME_WAIT, 0);
 }
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 72705eaf4b84..f911b9b09b16 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -89,7 +89,7 @@ struct tcp_sack_block {
 
 struct tcp_options_received {
 /*	PAWS/RTTM data	*/
-	long	ts_recent_stamp;/* Time we stored ts_recent (for aging) */
+	int	ts_recent_stamp;/* Time we stored ts_recent (for aging) */
 	u32	ts_recent;	/* Time stamp to echo next		*/
 	u32	rcv_tsval;	/* Time stamp value             	*/
 	u32	rcv_tsecr;	/* Time stamp echo reply        	*/
@@ -425,7 +425,7 @@ struct tcp_timewait_sock {
 	/* The time we sent the last out-of-window ACK: */
 	u32			  tw_last_oow_ack_time;
 
-	long			  tw_ts_recent_stamp;
+	int			  tw_ts_recent_stamp;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	  *tw_md5_key;
 #endif
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0448e7c5d2b4..f8c32dc36ea1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -471,19 +471,20 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
  */
 static inline void tcp_synq_overflow(const struct sock *sk)
 {
-	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
-	unsigned long now = jiffies;
+	unsigned int last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned int now = jiffies;
 
-	if (time_after(now, last_overflow + HZ))
+	if (time_after32(now, last_overflow + HZ))
 		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
 }
 
 /* syncookies: no recent synqueue overflow on this listening socket? */
 static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
 {
-	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned int last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned int now = jiffies;
 
-	return time_after(jiffies, last_overflow + TCP_SYNCOOKIE_VALID);
+	return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
 }
 
 static inline u32 tcp_cookie_time(void)
@@ -1361,7 +1362,7 @@ static inline bool tcp_paws_check(const struct tcp_options_received *rx_opt,
 {
 	if ((s32)(rx_opt->ts_recent - rx_opt->rcv_tsval) <= paws_win)
 		return true;
-	if (unlikely(get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS))
+	if (unlikely(ktime_get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS))
 		return true;
 	/*
 	 * Some OSes send SYN and SYNACK messages with tsval=0 tsecr=0,
@@ -1391,7 +1392,7 @@ static inline bool tcp_paws_reject(const struct tcp_options_received *rx_opt,
 
 	   However, we can relax time bounds for RST segments to MSL.
 	 */
-	if (rst && get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_MSL)
+	if (rst && ktime_get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_MSL)
 		return false;
 	return true;
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 355d3dffd021..0eb314774aec 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3449,7 +3449,7 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 static void tcp_store_ts_recent(struct tcp_sock *tp)
 {
 	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
-	tp->rx_opt.ts_recent_stamp = get_seconds();
+	tp->rx_opt.ts_recent_stamp = ktime_get_seconds();
 }
 
 static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bea17f1e8302..41d03153c5bf 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -155,7 +155,7 @@ int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 	   and use initial timestamp retrieved from peer table.
 	 */
 	if (tcptw->tw_ts_recent_stamp &&
-	    (!twp || (reuse && get_seconds() - tcptw->tw_ts_recent_stamp > 1))) {
+	    (!twp || (reuse && ktime_get_seconds() - tcptw->tw_ts_recent_stamp > 1))) {
 		tp->write_seq = tcptw->tw_snd_nxt + 65535 + 2;
 		if (tp->write_seq == 0)
 			tp->write_seq = 1;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 1dda1341a223..1f652beb79ca 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -144,7 +144,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 		tw->tw_substate	  = TCP_TIME_WAIT;
 		tcptw->tw_rcv_nxt = TCP_SKB_CB(skb)->end_seq;
 		if (tmp_opt.saw_tstamp) {
-			tcptw->tw_ts_recent_stamp = get_seconds();
+			tcptw->tw_ts_recent_stamp = ktime_get_seconds();
 			tcptw->tw_ts_recent	  = tmp_opt.rcv_tsval;
 		}
 
@@ -189,7 +189,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 
 		if (tmp_opt.saw_tstamp) {
 			tcptw->tw_ts_recent	  = tmp_opt.rcv_tsval;
-			tcptw->tw_ts_recent_stamp = get_seconds();
+			tcptw->tw_ts_recent_stamp = ktime_get_seconds();
 		}
 
 		inet_twsk_put(tw);
@@ -534,7 +534,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 
 		if (newtp->rx_opt.tstamp_ok) {
 			newtp->rx_opt.ts_recent = req->ts_recent;
-			newtp->rx_opt.ts_recent_stamp = get_seconds();
+			newtp->rx_opt.ts_recent_stamp = ktime_get_seconds();
 			newtp->tcp_header_len = sizeof(struct tcphdr) + TCPOLEN_TSTAMP_ALIGNED;
 		} else {
 			newtp->rx_opt.ts_recent_stamp = 0;
@@ -600,7 +600,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
-- 
2.9.0
