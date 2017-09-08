From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Fri, 8 Sep 2017 08:54:17 -0500
Message-ID: <628e9dbd-77ff-b931-50b1-e72d753612ee@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
 <20170907142737.g4aot7xatyopdfwp@pd.tnic>
 <9de7139f-676e-e671-13a1-cbc5170cc816@amd.com>
 <20170908084009.tb7wzm4j63vhgem4@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170908084009.tb7wzm4j63vhgem4@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 09/08/2017 03:40 AM, Borislav Petkov wrote:
> On Thu, Sep 07, 2017 at 05:19:32PM -0500, Brijesh Singh wrote:
>> At high level, AMD-SP (AMD Secure Processor) (i.e CCP driver) will provide the
>> support for CCP, SEV and TEE FW commands.
>>
>>
>>           +--- CCP
>>           |
>> AMD-SP --|
>>           |            +--- SEV
>>           |            |
>>           +---- PSP ---*
>>                        |
>>                        +---- TEE
> 
> I still don't see the need for such finegrained separation, though.
> There's no "this is a separate compilation unit because... ". At least
> the PSP branch could be a single driver without the interface.
> 
> For example, psp_request_sev_irq() is called only by sev_dev_init(). So
> why is sev-dev a separate compilation unit? Is anything else going to
> use the PSP interface?
> 

I don't know anything about the TEE support hence I don't have very strong
reason for finegrained separation -- I just wanted to ensure that the SEV
enablement does not interfere with TEE support in the future.


> If not, just put it all in a psp-dev file and that's it. We have a
> gazillion config options and having two more just because, is not a good
> reason. You can always carve it out later if there's real need. But if
> the SEV thing can't function without the PSP thing, then you can just as
> well put it inside it.
> 
> This way you can save yourself a bunch of exported functions and the
> like.
> 
> Another example for not optimal design is psp_request_tee_irq() - it
> doesn't really request an irq by calling into the IRQ core but simply
> assigns a handler. Which looks to me like you're simulating an interface
> where one is not really needed. Ditto for the sev_irq version, btw.
> 

It's possible that both TEE and SEV share the same interrupt but their
interrupt handling approach could be totally different hence I tried to
abstract it.

I am making several assumption on TEE side without knowing in detail ;)

I can go with your recommendation -- we can always crave it out later once
the TEE support is visible.

-Brijesh
