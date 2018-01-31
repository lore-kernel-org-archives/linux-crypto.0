From: Dave Watson <davejwatson@fb.com>
Subject: Re: [PATCHv2] tls: Add support for encryption using async offload
 accelerator
Date: Wed, 31 Jan 2018 09:34:44 -0800
Message-ID: <20180131173444.GA41553@davejwatson-mba>
References: <20180131160437.6583-1-vakul.garg@nxp.com>
 <20180131152228.GA24247@davejwatson-mba>
 <HE1PR04MB30827E0097BB30E4E2EE51648BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ilyal@mellanox.com" <ilyal@mellanox.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Vakul Garg <vakul.garg@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45452 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753158AbeAaRiI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 12:38:08 -0500
Content-Disposition: inline
In-Reply-To: <HE1PR04MB30827E0097BB30E4E2EE51648BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/31/18 05:22 PM, Vakul Garg wrote:
> > > On second though in stable we should probably just disable async tfm
> > > allocations.
> > > It's simpler. But this approach is still good for -next
> > >
> > >
> > > Gilad
> > 
> > I agree with Gilad, just disable async for now.
> > 
> 
> How to do it? Can you help with the api name?

*aead = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);

https://github.com/ktls/net_next_ktls/commit/f3b9b402e755e4b0623fa83f88137173fc249f2d

> > If the flag MSG_DONTWAIT is set, we should be returning -EINPROGRESS and
> > not wait for a response.  I had started working on a patch for that, but it's
> > pretty tricky to get right.
> 
> Can you point me to your WIP code branch for this?

https://github.com/ktls/net_next_ktls/commit/9cc839aa551ed972d148ecebf353b25ee93543b9

> If MSG_DONTWAIT is not used, will it be sane if enqueue the crypto request to 
> accelerator and return to user space back so that user space can send more plaintext data while 
> crypto accelerator is working in parallel?

Right, that's roughly what the above does.  I believe the tricky
unfinished part was getting poll() to work correctly if there is an
async crypto request outstanding.  Currently the tls poll() just
relies on backpressure from do_tcp_sendpages.
