From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [Crypto v5 03/12] support for inline tls
Date: Thu, 15 Feb 2018 16:31:34 +0000
Message-ID: <MWHPR1201MB02388A5E288110BAF52C4EE297F40@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
 <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
 <20180215155157.GA32691@davejwatson-mba>
 <MWHPR1201MB0238985353DFF78FE95108FF97F40@MWHPR1201MB0238.namprd12.prod.outlook.com>
 <20180215162615.GA38304@davejwatson-mba>
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
Received: from mail-sn1nam01on0128.outbound.protection.outlook.com ([104.47.32.128]:23008
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1424185AbeBOQbh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 11:31:37 -0500
In-Reply-To: <20180215162615.GA38304@davejwatson-mba>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> > > @@ -401,6 +430,15 @@ static int do_tls_setsockopt_tx(struct sock *sk,=
 char __user *optval,
> > >  		goto out;
> > >  	}
> > > =20
> > > +	rc =3D get_tls_offload_dev(sk);
> > > +	if (rc) {
> > > +		goto out;
> > > +	} else {
> > > +		/* Retain HW unhash for cleanup and move to SW Tx */
> > > +		sk->sk_prot[TLS_BASE_TX].unhash =3D
> > > +			sk->sk_prot[TLS_FULL_HW].unhash;
> >=20
> > Isn't sk->sk_prot a pointer to a global shared struct here still?  It l=
ooks like this would actually modify the global struct, and not just for th=
is sk.
> Yes, its global. It require add on check to modify only when tls_offload =
dev list has an entry. I will revisit and correct.=20
>=20
> Can you look through other changes please?

I looked through 1,2,3,11 (the tls-related ones) and don't have any other c=
ode comments.  Patch 11 commit message still mentions ULP, could use updati=
ng / clarification.

Thank you, I will collate and clean for v6.
