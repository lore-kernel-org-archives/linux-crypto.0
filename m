From: Dave Watson <davejwatson@fb.com>
Subject: Re: [Crypto v5 03/12] support for inline tls
Date: Thu, 15 Feb 2018 07:51:57 -0800
Message-ID: <20180215155157.GA32691@davejwatson-mba>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
 <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <sd@queasysnail.net>, <linux-crypto@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ganeshgr@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1424319AbeBOPwK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 10:52:10 -0500
Content-Disposition: inline
In-Reply-To: <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/15/18 12:24 PM, Atul Gupta wrote:
> @@ -401,6 +430,15 @@ static int do_tls_setsockopt_tx(struct sock *sk, char __user *optval,
>  		goto out;
>  	}
>  
> +	rc = get_tls_offload_dev(sk);
> +	if (rc) {
> +		goto out;
> +	} else {
> +		/* Retain HW unhash for cleanup and move to SW Tx */
> +		sk->sk_prot[TLS_BASE_TX].unhash =
> +			sk->sk_prot[TLS_FULL_HW].unhash;

Isn't sk->sk_prot a pointer to a global shared struct here still?  It
looks like this would actually modify the global struct, and not just
for this sk.
