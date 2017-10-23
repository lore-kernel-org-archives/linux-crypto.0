From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 23 Oct 2017 14:57:04 -0500
Message-ID: <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0048.outbound.protection.outlook.com ([104.47.33.48]:18863
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdJWT5M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 15:57:12 -0400
In-Reply-To: <20171023092020.GB19523@nazgul.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/23/2017 04:20 AM, Borislav Petkov wrote:
> On Thu, Oct 19, 2017 at 09:33:48PM -0500, Brijesh Singh wrote:
>> +static int __sev_platform_init(struct sev_data_init *data, int *error)
>> +{
>> +	int rc = 0;
>> +
>> +	mutex_lock(&fw_init_mutex);
>> +
>> +	if (!fw_init_count) {
> 
> I still don't like global semaphores. Can you get the status and check
> for PSTATE.INIT state and do the init only if the platform is in
> PSTATE.UNINIT?
> 


Calling PLATFORM_GET_STATUS is not required, we can manage the state 
through a simple ref count variable. Issuing PSP commands will always be 
much more expensive compare to accessing a protected global variable. I 
would prefer to avoid invoking PSP command if possible. Additionally, 
the global semaphore is still needed to serialize the 
sev_platform_init() and sev_platform_shutdown() from multiple processes. 
e.g If process "A" calls sev_platform_init() and if it gets preempted 
due to whatever reason then we don't want another process to issue the 
shutdown command while process "A" is in middle of sev_platform_init().

-Brijesh
