From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [Crypto v5 03/12] support for inline tls
Date: Thu, 15 Feb 2018 16:10:41 +0000
Message-ID: <MWHPR1201MB0238985353DFF78FE95108FF97F40@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
 <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
 <20180215155157.GA32691@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ganesh GR <ganeshgr@chelsio.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0113.outbound.protection.outlook.com ([104.47.34.113]:23168
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1425397AbeBOQKn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 11:10:43 -0500
In-Reply-To: <20180215155157.GA32691@davejwatson-mba>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Dave Watson [mailto:davejwatson@fb.com]=20
Sent: Thursday, February 15, 2018 9:22 PM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: davem@davemloft.net; herbert@gondor.apana.org.au; sd@queasysnail.net; l=
inux-crypto@vger.kernel.org; netdev@vger.kernel.org; Ganesh GR <ganeshgr@ch=
elsio.com>
Subject: Re: [Crypto v5 03/12] support for inline tls

On 02/15/18 12:24 PM, Atul Gupta wrote:
> @@ -401,6 +430,15 @@ static int do_tls_setsockopt_tx(struct sock *sk, cha=
r __user *optval,
>  		goto out;
>  	}
> =20
> +	rc =3D get_tls_offload_dev(sk);
> +	if (rc) {
> +		goto out;
> +	} else {
> +		/* Retain HW unhash for cleanup and move to SW Tx */
> +		sk->sk_prot[TLS_BASE_TX].unhash =3D
> +			sk->sk_prot[TLS_FULL_HW].unhash;

Isn't sk->sk_prot a pointer to a global shared struct here still?  It looks=
 like this would actually modify the global struct, and not just for this s=
k.
Yes, its global. It require add on check to modify only when tls_offload de=
v list has an entry. I will revisit and correct. Can you look through other=
 changes please?

Thanks
Atul
