From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Tue, 7 Nov 2017 08:50:44 +0530
Message-ID: <CANc+2y6dx_2zOzFA5aFs7RpEV8aNqxpDghmx+q_+XyendYJoew@mail.gmail.com>
References: <20171031200503.GC18578@ziepe.ca> <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
 <20171106022704.GD26011@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171106022704.GD26011@ziepe.ca>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

On 6 November 2017 at 07:57, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Sun, Nov 05, 2017 at 01:05:06PM +0200, Jarkko Sakkinen wrote:
>
>> I asked to create a series for a reason. Now this doesn't apply because I
>> don't have an ancestor in my git history.
>
> It would be unusual for me to put your patch into a series unless I am
> also adopting it. eg what happens if there are more comments on it?
>
> Also, I wasn't sure what branch your patch was against since my tree
> didn't have history for it either..
>
> Sometimes the maintainer has to sort stuff like this out... :)
>
>> Please resend as series together with my patch. I can apply neither yet
>> because they have zero tested-by's.
>
> Hopefully PrasannaKumar can test both patches.

I am assuming you are talking about the following patches - using
struct tpm_chip instead of chip number and this patch.

I won't be able to test if struct tpm_chip usage as I don't have
multiple tpm hw in one machine. In case of tpm rng changes I can test
only the lifecycle of tpm rng device. Is that enough? I feel my test
will be limited. Please provide your thoughts on this.

Regards,
PrasannaKumar
