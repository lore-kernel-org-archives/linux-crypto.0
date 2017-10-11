From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 14:49:55 -0500
Message-ID: <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0070.outbound.protection.outlook.com ([104.47.42.70]:24000
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752254AbdJKTuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 15:50:03 -0400
In-Reply-To: <20171011170205.qpu677qiqe4ludwm@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/11/2017 12:02 PM, Borislav Petkov wrote:
...

> 
> What's with the curly brackets around the case: statements?
> 

I will remove the curly braces.

> Anyway, here are some more improvements:
> 
> * you can get rid of the struct copying into out and the bitfields by
> doing something like this:
> 
> 	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
>          if (ret)
>                  goto e_free;
> 
>          /* Clear out reserved fields: */
>          data->owner  &= BIT(0);
>          data->config &= BIT(0);
> 
> I'm not sure those are the ones you need to clear but you get
> the idea - you simply poke holes in the reserved fields before
> copying to userspace. If you need a more sophisticated mask, use
> GENMASK/GENMASK_ULL.
> 

If we decide to go with this approach then we need use GENMASK (see below).

...

> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -144,11 +144,9 @@ struct sev_data_status {


Since the structure is shared with firmware hence I was trying to match 
it with the spec.


>   	u8 api_major;				/* Out */
>   	u8 api_minor;				/* Out */
>   	u8 state;				/* Out */
> -	u8 owner : 1;				/* Out */
> -	u8 reserved1 : 7;
> -	u32 config : 1;				/* Out */
> -	u32 reserved2 : 23;
> -	u32 build : 8;				/* Out */
> +	u8 owner;				/* Out */


This is OK for now. But in future if FW steals another bit from 
reserved1 field to expose a new flag then 'owner' name will no longer be 
valid. If you don't to use bit field then we have to use some generic 
name instead of naming the field as 'owner'. Please note that its not 
just userspace, KVM driver also uses the same fields and it may also 
need to know which bit position to use.


> +	u32 config;				/* Out */
> +	u32 build;				/* Out */


This is a tricky one. The 32-bit are packed as:

BIT0 - config.es
BIT1-23: reserved
BIT24-31: build

Now, if we really don't want to use bit field then we have to declare 
them as:

u8 config[3];
u8 build;

I would prefer to keep the structure as is. I am OK with changing the 
userspace sev_user_data_status to match with FW's sev_data_status to 
avoid the coying from FW structure to userspace structure.



>   	u32 guest_count;			/* Out */
>   } __packed;
>   
> 
