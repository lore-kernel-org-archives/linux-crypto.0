From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Wed, 6 Sep 2017 16:26:52 -0500
Message-ID: <58daec6d-4c37-ff7f-1473-8ec64f0a9f3a@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170906170029.bvpii7e7x3fglhwt@pd.tnic>
 <e32a7c0b-5985-e600-6ac2-f6ce48ad530d@amd.com>
 <20170906204606.f34esvg464ynsrjn@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170906204606.f34esvg464ynsrjn@pd.tnic>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/06/2017 03:46 PM, Borislav Petkov wrote:
> On Wed, Sep 06, 2017 at 03:38:38PM -0500, Brijesh Singh wrote:
>> This bit of my struggle -- tip/master is not in sync with cryptodev-2.6 [1].
>
> Aaha.
>
>> In order to expand the CCP driver we need the following commits from the
>> cryptodev-2.6
>>
>> 57de3aefb73f crypto: ccp - remove ccp_present() check from device initialize
>> d0ebbc0c407a crypto: ccp - rename ccp driver initialize files as sp device
>> f4d18d656f88 crypto: ccp - Abstract interrupt registeration
>> 720419f01832 crypto: ccp - Introduce the AMD Secure Processor device
>> 970e8303cb8d crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
>>
>> I cherry-picked these patches into tip/master before starting the SEV work.
>>
>> Since these patches were already reviewed and accepted hence I did not include it
>> in my RFC series. I am not sure what is best way to handle it. Should I include
>> these patches in the series ? or just mention them in cover letter ? I am looking
>> for suggestions on how to best communicate it. thanks
>
> Right, so I'm assuming those will go upstream this merge window, no?

They were included in a pull request (for 4.14) from Herbert, dated Monday.
