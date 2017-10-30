From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6.1 16/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 30 Oct 2017 12:49:14 -0500
Message-ID: <1e89d599-b1d2-bb16-92f4-0409ee0a6ea0@amd.com>
References: <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171029204825.18260-1-brijesh.singh@amd.com>
 <20171030172150.3eibiqr44i43zbvd@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0084.outbound.protection.outlook.com ([104.47.37.84]:43424
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932115AbdJ3RtW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 13:49:22 -0400
In-Reply-To: <20171030172150.3eibiqr44i43zbvd@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/30/2017 12:21 PM, Borislav Petkov wrote:
...

> 
> Useless forward declarations.
> 

Actually its helpful in other patches. I was trying to avoid making too 
many code movement in other patches to eliminate the forward 
declarations. I guess I can fix in v7.


>>   static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>>   {
>>   	struct device *dev = sp->dev;
> 
> ...
> 
>> +static int sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> 
> You can use the "__" prefix to denote that it is a lower-level helper:
> 
> __sev_do_cmd
> __sev_do_cmd_locked
> 
> Ditto for the other locked functions.

noted

> ...
> 
>> +static int sev_platform_init_locked(struct sev_data_init *data, int *error)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_data_init *input = NULL;
>> +	int rc = 0;
>> +
>> +	if (!psp)
>> +		return -ENODEV;
>> +
>> +	if (psp->sev_state == SEV_STATE_INIT)
>> +		return 0;
>> +
>> +	if (!data) {
>> +		input = kzalloc(sizeof(*input), GFP_KERNEL);
>> +		if (!input)
>> +			return -ENOMEM;
>> +
>> +		data = input;
>> +	}
> 
> You can do the allocation in the enclosing function, outside of the
> critical region so that you can keep it shorter.
> 
> Or even better: if you're going to synchronize the commands with a
> mutex, you can define a static struct sev_data_init input in this file
> which you always hand in and then you can save yourself the kmalloc
> calls.
> 

If the buffer is allocated on the stack then there is no guarantee that 
__pa() will gives us a valid physical address. IIRC, when 
CONFIG_VMAP_STACK=y then stack space is mapped similar to vmalloc'd 
storage and __pa() will not work.

Since we need to pass the physical address to PSP hence variable 
allocated on the stack will not work.

I can certainly move the allocation outside, but then it may increase 
the code size in other functions. If its not a big deal then I would 
prefer to keep what we have.


...
>> +
>> +int sev_platform_shutdown(int *error)
>> +{
>> +	if (error)
>> +		*error = 0;
>> +
>> +	return 0;
>> +}
> 
> I'm guessing that that's just bare-bones and it will get filled up in
> the next patches. Otherwise it looks pretty useless.
> 

Well, we are not expanding in other patches. I was also debating on what 
to do with this function. Since we need sev_platform_init() hence it 
made sense to add sev_platform_shutdown() as well. If we add the 
function then I wanted to make sure that we set the *error = SUCCESS so 
that caller knows that function succeeded.


> If it is just to block the user from sending SHUTDOWN to the PSP
> master, just do that in the ioctl directly - no need to call some empty
> functions.
> 

The function is not used by userspace ioctl, its used by kvm drv when it 
launch/terminates the SEV guest.

-Brijesh
