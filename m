From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Sun, 5 Nov 2017 19:27:04 -0700
Message-ID: <20171106022704.GD26011@ziepe.ca>
References: <20171031200503.GC18578@ziepe.ca>
 <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
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
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 05, 2017 at 01:05:06PM +0200, Jarkko Sakkinen wrote:

> I asked to create a series for a reason. Now this doesn't apply because I
> don't have an ancestor in my git history.

It would be unusual for me to put your patch into a series unless I am
also adopting it. eg what happens if there are more comments on it?

Also, I wasn't sure what branch your patch was against since my tree
didn't have history for it either..

Sometimes the maintainer has to sort stuff like this out... :)

> Please resend as series together with my patch. I can apply neither yet
> because they have zero tested-by's.

Hopefully PrasannaKumar can test both patches.

Jason
