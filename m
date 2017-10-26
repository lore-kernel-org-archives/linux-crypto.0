From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 15:59:32 -0500
Message-ID: <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171026201322.GA32181@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/26/2017 03:13 PM, Borislav Petkov wrote:
> On Thu, Oct 26, 2017 at 02:26:15PM -0500, Brijesh Singh wrote:
>> SHUTDOWN command unconditionally transitions a platform to uninitialized
>> state. The command does not care how many processes are actively using the
>> PSP. We don't want to shutdown the firmware while other process is still
>> using it.
> 
> So why do you have to init and shutdown the PSP each time you execute a
> command? Why isn't the PSP initialized, *exactly* *once* at driver init
> and shut down, also exactly once at driver exit?

Wish we could do that but the following reasons makes things complicated:

1) The commands must be issued from the PSP master devices, at PSP 
initialization time we do not know the PSP 'master' device. Hence we 
will not able to invoke sev_platform_init() during the PSP 
initialization time.

2) some commands require the platform to be in UNINIT state -- e.g 
FACTORY_RESET. So, if we do the INIT at the PSP initialization time then 
we still need to perform the SHUTDOWN outside the normal code flow to 
handle these commands.

we can workaround #1 by adding some hooks in sp_pci_init() to invoke the 
PSP initialization routines after pci_register_driver() is done but #2 
can get painful because it will require us calling the SHUTDOWN outside 
the sp_pci_exit() code flow.


-Brijesh
