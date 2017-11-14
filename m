From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Tue, 14 Nov 2017 16:34:21 +0200
Message-ID: <20171114143421.3jxn6fzvgp2xmyk6@linux.intel.com>
References: <20171031200503.GC18578@ziepe.ca>
 <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
 <20171106022704.GD26011@ziepe.ca>
 <CANc+2y6dx_2zOzFA5aFs7RpEV8aNqxpDghmx+q_+XyendYJoew@mail.gmail.com>
 <20171107160404.GG21466@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)"
        <linux-security-module@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        David Safford <safford@us.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13305 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755768AbdKNOeb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 09:34:31 -0500
Content-Disposition: inline
In-Reply-To: <20171107160404.GG21466@ziepe.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 09:04:04AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 07, 2017 at 08:50:44AM +0530, PrasannaKumar Muralidharan wrote:
> 
> > I am assuming you are talking about the following patches - using
> > struct tpm_chip instead of chip number and this patch.
> 
> yes
> 
> > I won't be able to test if struct tpm_chip usage as I don't have
> > multiple tpm hw in one machine. In case of tpm rng changes I can test
> > only the lifecycle of tpm rng device. Is that enough? I feel my test
> > will be limited. Please provide your thoughts on this.
> 
> That is certainly better than no testing.
> 
> Jason

WFM too.

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
