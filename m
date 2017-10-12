From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.2 12.1/31] crypto: ccp: Define SEV userspace
 ioctl and command id
Date: Thu, 12 Oct 2017 09:18:31 -0500
Message-ID: <a5b12dcf-4a07-8f6b-226c-841db5eec4fc@amd.com>
References: <20171007010607.78088-2-brijesh.singh@amd.com>
 <20171011164605.115592-1-brijesh.singh@amd.com>
 <20171012132752.6qgkjyxuofwhvcto@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012132752.6qgkjyxuofwhvcto@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/12/2017 08:27 AM, Borislav Petkov wrote:
...

> 
>> +/**
>> + * struct sev_user_data_status - PLATFORM_STATUS command parameters
>> + *
>> + * @major: major API version
>> + * @minor: minor API version
>> + * @state: platform state
>> + * @owner: self-owned or externally owned
>> + * @config: platform config flags
>> + * @build: firmware build id for API version
>> + * @guest_count: number of active guests
>> + */
>> +struct sev_user_data_status {
>> +	__u8 api_major;				/* Out */
>> +	__u8 api_minor;				/* Out */
>> +	__u8 state;				/* Out */
>> +	__u8 owner;				/* Out */
>> +	__u32 config;				/* Out */
>> +	__u8 build;				/* Out */
>> +	__u32 guest_count;			/* Out */
>> +} __packed;
>> +
> 
> After yesterday's discussion about the sev_data_status layout, that
> struct is not needed anymore, right?
> 

Yes, we no longer need that structure.

-Brijesh
