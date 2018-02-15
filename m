From: Dave Watson <davejwatson@fb.com>
Subject: Re: [Crypto v5 03/12] support for inline tls
Date: Thu, 15 Feb 2018 08:26:15 -0800
Message-ID: <20180215162615.GA38304@davejwatson-mba>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
 <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
 <20180215155157.GA32691@davejwatson-mba>
 <MWHPR1201MB0238985353DFF78FE95108FF97F40@MWHPR1201MB0238.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ganesh GR <ganeshgr@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR1201MB0238985353DFF78FE95108FF97F40@MWHPR1201MB0238.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/15/18 04:10 PM, Atul Gupta wrote:
> > -----Original Message-----
> > From: Dave Watson [mailto:davejwatson@fb.com] 
> > Sent: Thursday, February 15, 2018 9:22 PM
> > To: Atul Gupta <atul.gupta@chelsio.com>
> > Cc: davem@davemloft.net; herbert@gondor.apana.org.au; sd@queasysnail.net; linux-crypto@vger.kernel.org; netdev@vger.kernel.org; Ganesh GR <ganeshgr@chelsio.com>
> > Subject: Re: [Crypto v5 03/12] support for inline tls
> > 
> > On 02/15/18 12:24 PM, Atul Gupta wrote:
> > > @@ -401,6 +430,15 @@ static int do_tls_setsockopt_tx(struct sock *sk, char __user *optval,
> > >  		goto out;
> > >  	}
> > >  
> > > +	rc = get_tls_offload_dev(sk);
> > > +	if (rc) {
> > > +		goto out;
> > > +	} else {
> > > +		/* Retain HW unhash for cleanup and move to SW Tx */
> > > +		sk->sk_prot[TLS_BASE_TX].unhash =
> > > +			sk->sk_prot[TLS_FULL_HW].unhash;
> > 
> > Isn't sk->sk_prot a pointer to a global shared struct here still?  It looks like this would actually modify the global struct, and not just for this sk.
> Yes, its global. It require add on check to modify only when tls_offload dev list has an entry. I will revisit and correct. 
> 
> Can you look through other changes please?

I looked through 1,2,3,11 (the tls-related ones) and don't have any
other code comments.  Patch 11 commit message still mentions ULP,
could use updating / clarification.
