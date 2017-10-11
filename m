From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 15:10:49 -0500
Message-ID: <cd9e71bc-5187-fc88-ad80-4aa171370af6@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
 <20171011170205.qpu677qiqe4ludwm@pd.tnic>
 <c75e2be7-117f-299b-2c83-7160f78cba7e@amd.com>
 <20171011200444.3njniblsvxn2vhl6@pd.tnic>
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
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:43968
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752580AbdJKUK4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 16:10:56 -0400
In-Reply-To: <20171011200444.3njniblsvxn2vhl6@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/11/2017 03:04 PM, Borislav Petkov wrote:
> On Wed, Oct 11, 2017 at 02:49:55PM -0500, Brijesh Singh wrote:
>> This is OK for now. But in future if FW steals another bit from reserved1
>> field to expose a new flag then 'owner' name will no longer be valid. If you
>> don't to use bit field then we have to use some generic name instead of
>> naming the field as 'owner'. Please note that its not just userspace, KVM
>> driver also uses the same fields and it may also need to know which bit
>> position to use.
> 
> So what is this field called in the spec?
> 

See Section 5.5.2 [1]

[1] http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf

The bit0 is named as 'owner' and bits 7:1 is left blank (no name is given).


>> This is a tricky one. The 32-bit are packed as:
>>
>> BIT0 - config.es
>> BIT1-23: reserved
>> BIT24-31: build
> 
> Is that what the firmware gives?
> 

Yes

> Then it is easy:
> 
> 	<firmware_field_name> &= GENMASK(23, 1);
> 
> and then userspace can pick apart bit 0 and bit24-31.
> 

The bit0 is named as config.es and bit1-23 is left blank and bit31-24 is 
named as build.

The current 'struct sev_data_status' matches with the firmware names and 
the bit fields. Only thing I did was the fields with no name is called 
as "reservedX"


> Just use one raw struct which the firmware gives you and the rest is
> done by the sw. Like clearing reserved fields before copying to user.
> 
> You don't want to be updating that struct layout later: think of old
> qemu with new kernel and all those different configurations.
> 
