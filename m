From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 15:53:39 -0500
Message-ID: <97ed3294-a06a-58da-6531-cb30c7154726@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
 <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
 <20171011200444.3njniblsvxn2vhl6@pd.tnic>
 <cd9e71bc-5187-fc88-ad80-4aa171370af6@amd.com>
 <20171011202836.d3ur3ndrnea25ywi@pd.tnic>
 <e3da0e38-b6e6-2db0-3adf-205f99c68808@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
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
In-Reply-To: <e3da0e38-b6e6-2db0-3adf-205f99c68808@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/11/2017 03:45 PM, Brijesh Singh wrote:
> 
> 
> On 10/11/2017 03:28 PM, Borislav Petkov wrote:
>> On Wed, Oct 11, 2017 at 03:10:49PM -0500, Brijesh Singh wrote:
>>> The current 'struct sev_data_status' matches with the firmware names 
>>> and the
>>> bit fields. Only thing I did was the fields with no name is called as
>>> "reservedX"
>>
>> Ok, I see it. So what you actually wanna do is:
>>
>> struct sev_data_status {
>>          u8 api_major;                           /* Out */
>>          u8 api_minor;                           /* Out */
>>          u8 state;                               /* Out */
>>          u8 flags;                               /* Out */
>>          u32 config;                             /* Out */
>>          u32 guest_count;                        /* Out */
>> } __packed;
>>
> 
> OK, if userspace is going to pick bits apart then how about this:
> 
>   struct sev_data_status {
>           u8 api_major;                           /* Out */
>           u8 api_minor;                           /* Out */
>           u8 state;                               /* Out */
>           u32 flags;                              /* Out */
>           u8 build;                               /* Out */
>           u32 guest_count;                        /* Out */
>   } __packed;
> 


BTW, I kept the build name because KVM driver prints some debug 
information like this:

pr_info_once("SEV: api_major %d api_minor %d build %d\n",
               status->api_major, status->api_minor, status->build);

Of course, I can modify it to access bit field if we decide to go with 
your recommended structure - thanks
