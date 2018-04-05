From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v15 0/9] Add io{read|write}64 to io-64-atomic headers
Date: Thu, 05 Apr 2018 14:48:18 +1000
Message-ID: <876056cl7x.fsf@concordia.ellerman.id.au>
References: <20180327230834.5931-1-logang@deltatee.com> <87r2nvmf3b.fsf@concordia.ellerman.id.au> <515f5c92-ac02-6e09-830e-46ea4d462652@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <515f5c92-ac02-6e09-830e-46ea4d462652@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Logan Gunthorpe <logang@deltatee.com> writes:
> On 4/4/2018 4:38 AM, Michael Ellerman wrote:
...
>> eg. It looks like I could take the two powerpc patches on their own for
>> 4.17, and then the rest could go via other trees?
>
> Yup! If you can take the powerpc patches I can keep trying to get the 
> rest in. They are largely independent and shouldn't really change 
> anything without the following patches.

OK, I'll take those then.

>> Is patch 1 stand alone?
>
> Essentially, yes, but patch 5 depends on it seeing it's changing the 
> same area and is trying to avoid creating the same kbuild warnings that 
> patch 1 suppresses.
>
>> The other option is to ask Andrew Morton to take it, as he often carries
>> these cross-tree type series.
>
> Thanks for the tip! I'll copy him when I repost it after the merge window.

Cool. If you want him to take it you should probably explicitly say so
when you repost.

cheers
