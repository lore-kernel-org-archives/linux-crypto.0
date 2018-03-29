From: Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [PATCH v14 net-next 09/12] crypto: chtls - Inline TLS record Tx
Date: Fri, 30 Mar 2018 00:54:09 +0530
Message-ID: <52183607-b227-dc53-4a94-9408c5a4ecaf@chelsio.com>
References: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
 <1522339074-4681-10-git-send-email-atul.gupta@chelsio.com>
 <20180329162611.GA9517@bistromath.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180329162611.GA9517@bistromath.localdomain>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 3/29/2018 9:56 PM, Sabrina Dubroca wrote:
> 2018-03-29, 21:27:51 +0530, Atul Gupta wrote:
>> TLS handler for record transmit.
>> Create Inline TLS work request and post to FW.
>> Create Inline TLS record CPLs for hardware
>>
>> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
>> Signed-off-by: Michael Werner <werner@chelsio.com>
>> ---
> ...
>> +int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>> +{
>> +	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
>> +	struct chtls_dev *cdev = csk->cdev;
>> +	struct tcp_sock *tp = tcp_sk(sk);
>> +	struct sk_buff *skb;
>> +	int mss, flags, err;
>> +	int recordsz = 0;
>> +	int copied = 0;
>> +	int hdrlen = 0;
>> +	long timeo;
>> +
>> +	lock_sock(sk);
>> +	flags = msg->msg_flags;
>> +	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
>> +
>> +	if (!sk_in_state(sk, TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
>> +		err = sk_stream_wait_connect(sk, &timeo);
>> +		if (err)
>> +			goto out_err;
>> +	}
>> +
>> +	if (sk->sk_prot->sendmsg != chtls_sendmsg) {
> Can that actually happen? If so, how? AFAICT, this function is only
> called when sk->sk_prot has been set to be chtls_cpl_prot.
this is relevant for the tunneling of the active-open path and can be removed for now
>
>> +		release_sock(sk);
>> +		if (sk->sk_prot->sendmsg)
>> +			return sk->sk_prot->sendmsg(sk, msg, size);
>> +		else
>> +			return sk->sk_socket->ops->sendmsg(sk->sk_socket,
>> +							   msg, size);
>> +	}
