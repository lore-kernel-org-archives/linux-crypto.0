From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v3] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Sat, 20 Jan 2018 13:30:12 +0530
Message-ID: <CANc+2y4XFEYP+5_NpDMY_nOFE+tzgZ1F8H6a6L5apZ+=_G+Wcg@mail.gmail.com>
References: <20171026135453.24672-1-jarkko.sakkinen@linux.intel.com>
 <20171031200303.GB18578@ziepe.ca> <CANc+2y4si3YW5FXWEdKz0UM5c76MBmHWu4RBF7d2dew9i-Ut+Q@mail.gmail.com>
 <20171114143238.looouhjk4bp5ko4g@linux.intel.com> <CANc+2y4eGcqTpUPwCuYv1RdLXGhHdb3YAOjL-dnsnvQ-O7FVRQ@mail.gmail.com>
 <20180118162013.luz36mjsswaxaekq@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
        open list <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)"
        <linux-security-module@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20180118162013.luz36mjsswaxaekq@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jarkko,

On 18 January 2018 at 21:50, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> On Wed, Jan 17, 2018 at 07:43:51PM +0530, PrasannaKumar Muralidharan wrote:
>> Hi Jarkko,
>>
>> On 14 November 2017 at 20:02, Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>> > On Sun, Nov 12, 2017 at 10:53:35AM +0530, PrasannaKumar Muralidharan wrote:
>> >> Did basic check on tpm rng patch, it works fine. As it depends on this
>> >> patch this should be working fine too.
>> >>
>> >> Tested-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> >>
>> >> Regards,
>> >> PrasannaKumar
>> >
>> > Thank you.
>> >
>> > /Jarkko
>>
>> Wondering what happened to this and tpm rng patch. Is there something
>> more to do for this to get merged?
>>
>> Thanks,
>> PrasannaKumar
>
> Was part of 4.6 PR.
>
> /Jarkko

Ah, I see.

PS: I think you meant 4.16.

Thanks,
PrasannaKumar
