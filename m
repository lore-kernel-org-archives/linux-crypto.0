From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Fri, 17 Nov 2017 15:57:58 +0200
Message-ID: <20171117135758.wvx3w5phndvfmfsh@linux.intel.com>
References: <20171031200503.GC18578@ziepe.ca>
 <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
 <20171106022704.GD26011@ziepe.ca>
 <CANc+2y6dx_2zOzFA5aFs7RpEV8aNqxpDghmx+q_+XyendYJoew@mail.gmail.com>
 <20171107160404.GG21466@ziepe.ca>
 <20171114143421.3jxn6fzvgp2xmyk6@linux.intel.com>
 <20171117132853.cmr3wmsc3biedv7p@linux.intel.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171117132853.cmr3wmsc3biedv7p@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 17, 2017 at 03:28:53PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 14, 2017 at 04:34:21PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 07, 2017 at 09:04:04AM -0700, Jason Gunthorpe wrote:
> > > On Tue, Nov 07, 2017 at 08:50:44AM +0530, PrasannaKumar Muralidharan wrote:
> > > 
> > > > I am assuming you are talking about the following patches - using
> > > > struct tpm_chip instead of chip number and this patch.
> > > 
> > > yes
> > > 
> > > > I won't be able to test if struct tpm_chip usage as I don't have
> > > > multiple tpm hw in one machine. In case of tpm rng changes I can test
> > > > only the lifecycle of tpm rng device. Is that enough? I feel my test
> > > > will be limited. Please provide your thoughts on this.
> > > 
> > > That is certainly better than no testing.
> > > 
> > > Jason
> > 
> > WFM too.
> > 
> > Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > /Jarkko
> 
> I applied these commits. Please check that everything is correct as
> I had to do manual work with the 2nd commit.
> 
> /Jarkko

At least signed-off-by from PrassanaKumar is missing from the 2nd
commit. I'll add it.

/Jarkko
