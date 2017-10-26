From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 11:56:57 -0500
Message-ID: <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171026135614.GA12359@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/26/2017 08:56 AM, Borislav Petkov wrote:
> On Mon, Oct 23, 2017 at 02:57:04PM -0500, Brijesh Singh wrote:
>> Calling PLATFORM_GET_STATUS is not required, we can manage the state through
>> a simple ref count variable. Issuing PSP commands will always be much more
>> expensive compare to accessing a protected global variable.
> 
> What does "protected" mean here?
> 

Access global variable after acquiring the semaphore.


> In any case, that variable can be a simple bool as you use it as such.
> 

I am not using the variable (fw_init_count) as boolean. The variable 
gets incremented in sev_platform_init() and decremented in 
sev_platform_shutdown(). In very first call to sev_platform_init (i.e 
when variable is zero) we issue  PLATFORM_INIT command, similarly 
PLATFORM_SHUTDOWN is issued on the last (i.e when variable value is 
reached to zero). The variable is used as ref counter.


>> I would prefer to avoid invoking PSP command if possible.
>> Additionally, the global semaphore is still needed to serialize
>> the sev_platform_init() and sev_platform_shutdown() from multiple
>> processes. e.g If process "A" calls sev_platform_init() and if it gets
>> preempted due to whatever reason then we don't want another process
>> to issue the shutdown command while process "A" is in middle of
>> sev_platform_init().
> 
> How? You're holding fw_init_mutex.
> 

In your previous reply you comments on global semaphore (fw_init_mutex) 
and in response I tried to highlight why we need the global semaphore. 
Did I misunderstood your comment ?

-Brijesh
