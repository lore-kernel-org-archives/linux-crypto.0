From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sun, 8 Oct 2017 19:11:04 -0500
Message-ID: <7131ad30-6c07-16d5-8cfc-06d446a66dca@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
 <20171008140019.flvyovgq2xpqdcoq@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171008140019.flvyovgq2xpqdcoq@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/8/17 9:00 AM, Borislav Petkov wrote:
> On Sun, Oct 08, 2017 at 08:30:47AM -0500, Brijesh Singh wrote:
>> During the device probe, sev_ops_init() will be called for every device
>> instance which claims to support the SEV.  One of the device will be
>> 'master' but we don't the master until we probe all the instances. Hence
>> the probe for all SEV devices must return success.
> I still am wondering whether that design with multiple devices - master
> and non-master devices is optimal. Why isn't the security processor a
> single driver which provides the whole functionality, PSP including? Why
> do you need all that register and unregister glue and get_master bla if
> you can simply put the whole thing in a single module?

There is a single security processor driver (ccp) which provides the
complete functionality including PSP.  But the driver should be able to
work with multiple devices. e.g In my 2P EPYC configuration, security
processor driver is used for the following devices

02:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
03:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
13:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
14:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
22:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
23:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
31:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
32:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
41:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
42:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
51:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
52:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
61:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
62:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468
71:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1456
72:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
1468

Some of the these devices support CCP only and some support both PSP and
CCP. It's possible that multiple devices support the PSP functionality
but only one of them is master which can be used for issuing SEV
commands. There isn't a register which we can read to determine whether
the device is master. We have to probe all the devices which supports
the PSP to determine which one of them is a master.
 
> And the fact that you need a global variable to mark that you've
> registered the misc device should already tell you that something's
> not optimal. Because if you had a single driver, it will go, detect
> the whole functionality, initialize it, register services and be done
> with it. No registering of devices, no finding of masters, no global
> variables, no unnecessary glue.
>
> IOW, in this diagram:
>
>          +--- CCP
>          |
> AMD-SP --|
>          |            +--- SEV
>          |            |
>          +---- PSP ---*
>                       |
>                       +---- TEE
>
> why isn't the whole PSP functionality part of drivers/crypto/ccp/sp-dev.c ?
>
> That driver is almost barebones minimal thing. You can very well add the
> PSP/SEV stuff in there and if there's an *actual* reason to carve pieces
> out, only then to do so, not to split it now unnecessarily and make your
> life complicated for no reason.

I was trying to follow the CCP  model -- in which sp-dev.c simply
forwards the call to ccp-dev.c which does the real work. Currently,
sev-dev.c contains barebone common code. IMO, keeping all the PSP
private functions and data structure outside the sp-dev.c/.h is right
thing. Having said that, I am okay with moving all the PSP stuff in
sp-dev.c but before we do that lets see what CCP maintainers say.

Tom and Gary,  comments please ?
 
Additionally, I would like to highlight that if we decide to go with
moving all the PSP functionality in sp-dev.c then we have to add #ifdef
CONFIG_CRYPTO_DEV_SP_PSP because PSP feature depends on X86_66, whereas
the sp-dev.c gets compiled for all architectures (including aarch64,
i386 and x86_64).
 
>
> Or am I missing some obvious and important reason?
