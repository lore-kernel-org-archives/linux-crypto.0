From: Dave Watson <davejwatson@fb.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Wed, 31 Jan 2018 08:43:47 -0800
Message-ID: <20180131164347.GA34501@davejwatson-mba>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <20180130171144.GA42146@davejwatson-mba>
 <9e81c5b4-f319-8b33-5dec-dad19582bde4@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: "sd@queasysnail.net" <sd@queasysnail.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ganeshgr@chelsio.co" <ganeshgr@chelsio.co>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932099AbeAaQoL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 11:44:11 -0500
Content-Disposition: inline
In-Reply-To: <9e81c5b4-f319-8b33-5dec-dad19582bde4@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/31/18 04:14 PM, Atul Gupta wrote:
> 
> 
> On Tuesday 30 January 2018 10:41 PM, Dave Watson wrote:
> > On 01/30/18 06:51 AM, Atul Gupta wrote:
> > 
> > > What I was referring is that passing "tls" ulp type in setsockopt
> > > may be insufficient to make the decision when multi HW assist Inline
> > > TLS solution exists.
> > Setting the ULP doesn't choose HW or SW implementation, I think that
> > should be done later when setting up crypto with
> > 
> > setsockopt(SOL_TLS, TLS_TX, struct crypto_info).
> setsockpot [mentioned above] is quite late for driver to enable HW
> implementation, we require something as early as tls_init [setsockopt(sock,
> SOL_TCP, TCP_ULP, "tls", sizeof("tls"))], for driver to set HW prot and
> offload connection beside Inline Tx/Rx.
> > 
> > Any reason we can't use ethtool to choose HW vs SW implementation, if
> > available on the device?
> Thought about it,  the interface index is not available to fetch netdev and
> caps check to set HW prot eg. bind [prot.hash] --> tls_hash to program HW.

Perhaps this is the part I don't follow - why do you need to override
hash and check for LISTEN?  I briefly looked through the patch named
"CPL handler definition", this looks like it is a full TCP offload?
