From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Tue, 30 Jan 2018 00:06:12 +0200
Message-ID: <20180129220612.ifk7r4md5tynlvz4@linux.intel.com>
References: <20171031200503.GC18578@ziepe.ca>
 <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
 <20171106022704.GD26011@ziepe.ca>
 <CANc+2y6dx_2zOzFA5aFs7RpEV8aNqxpDghmx+q_+XyendYJoew@mail.gmail.com>
 <20171107160404.GG21466@ziepe.ca>
 <20171114143421.3jxn6fzvgp2xmyk6@linux.intel.com>
 <20171117132853.cmr3wmsc3biedv7p@linux.intel.com>
 <20171117135758.wvx3w5phndvfmfsh@linux.intel.com>
 <CANc+2y4nALRpw9dY8PK8A56St4NONQoTLc8aHqxuV1RWg_PiCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
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
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        jmorris@namei.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y4nALRpw9dY8PK8A56St4NONQoTLc8aHqxuV1RWg_PiCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 27, 2018 at 12:20:18PM +0530, PrasannaKumar Muralidharan wrote:
> Hi Jarkko,
> 
> On 17 November 2017 at 19:27, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > On Fri, Nov 17, 2017 at 03:28:53PM +0200, Jarkko Sakkinen wrote:
> >
> > At least signed-off-by from PrassanaKumar is missing from the 2nd
> > commit. I'll add it.
> 
> I had the impression that my signed-off-by will be present in this
> change. But it is missing in [1]. Is it supposed to be that way?
> 
> 1. https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=6e592a065d51d26f9d62b8b7501a5114076af8b4
> 
> Thanks,
> PrasannaKumar

Yes, it would be senseful.

James, would it still be possible to amend this tag to security tree?

/Jarkko
