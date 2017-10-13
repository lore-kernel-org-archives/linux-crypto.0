From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.7/31] crypto: ccp: Implement SEV_PEK_CSR
 ioctl command
Date: Thu, 12 Oct 2017 23:13:44 -0500
Message-ID: <df846578-247a-978f-703e-ed6a6d23ee01@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-7-brijesh.singh@amd.com>
 <20171012195331.bdzwqzyrjc6fi5lj@pd.tnic>
 <d83b3e27-1195-817e-e976-36982e275588@amd.com>
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
In-Reply-To: <d83b3e27-1195-817e-e976-36982e275588@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/12/17 9:24 PM, Brijesh Singh wrote:
>
> On 10/12/17 2:53 PM, Borislav Petkov wrote:
> ...
>
>> Ok, a couple of things here:
>>
>> * Move the checks first and the allocations second so that you allocate
>> memory only after all checks have been passed and you don't allocate
>> pointlessly.
>
> I assume you mean performing the SEV state check before allocating the
> memory for the CSR blob, right ? In my patches, I typically perform all
> the SW specific checks and allocation before invoking the HW routines.
> Handling the PSP commands will take longer compare to kmalloc() or
> access_ok() etc. If its not a big deal then I would prefer to keep that
> way.
>
>
>> * That:
>>
>>         if (state == SEV_STATE_WORKING) {
>>                 ret = -EBUSY;
>>                 goto e_free_blob;
>>         } else if (state == SEV_STATE_UNINIT) {
>>                 ret = sev_firmware_init(&argp->error);
>>                 if (ret)
>>                         goto e_free_blob;
>>                 do_shutdown = 1;
>>         }
>>
>> is a repeating pattern. Perhaps it should be called
>> sev_firmware_reinit() and called by other functions.
>
>> * The rest is simplifications and streamlining.
>>
>> ---
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index e3ee68afd068..d41f5448a25b 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -302,33 +302,30 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
>>  	int ret, state;
>>  	void *blob;
>>  
>> -	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
>> -			   sizeof(struct sev_user_data_pek_csr)))
>> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>> +		return -EFAULT;
>> +
>> +	if (!input.address)
>> +		return -EINVAL;
>> +


As per the spec, its perfectly legal to pass input.address = 0x0 and
input.length = 0x0. If userspace wants to query CSR length then it will
fill all the fields with. In response, FW will return error
(LENGTH_TO_SMALL) and input.length will be filled with the expected
length. Several command work very similar (e.g PEK_CSR,
PEK_CERT_EXPORT). A typical usage from userspace will be:

- query the length of the blob (call command with all fields set to zero)
- SEV FW will response with expected length
- userspace allocate the blob and retries the command. 


>> +	/* allocate a physically contiguous buffer to store the CSR blob */
>> +	if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
>> +	    input.length > SEV_FW_BLOB_MAX_SIZE)
>>  		return -EFAULT;
>>  
>>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>>  	if (!data)
>>  		return -ENOMEM;
>>  
>> -	/* allocate a temporary physical contigous buffer to store the CSR blob */
>> -	blob = NULL;
>> -	if (input.address) {
>> -		if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
>> -		    input.length > SEV_FW_BLOB_MAX_SIZE) {
>> -			ret = -EFAULT;
>> -			goto e_free;
>> -		}
>> -
>> -		blob = kmalloc(input.length, GFP_KERNEL);
>> -		if (!blob) {
>> -			ret = -ENOMEM;
>> -			goto e_free;
>> -		}
>> -
>> -		data->address = __psp_pa(blob);
>> -		data->len = input.length;
>> +	blob = kmalloc(input.length, GFP_KERNEL);
>> +	if (!blob) {
>> +		ret = -ENOMEM;
>> +		goto e_free;
>>  	}
>>  
>> +	data->address = __psp_pa(blob);
>> +	data->len = input.length;
>> +
>>  	ret = sev_platform_get_state(&state, &argp->error);
>>  	if (ret)
>>  		goto e_free_blob;
>> @@ -349,25 +346,23 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
>>  		do_shutdown = 1;
>>  	}
>>  
>> -	ret = sev_handle_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
>> +	ret = sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
>>  
>>  	input.length = data->len;
>>  
>>  	/* copy blob to userspace */
>> -	if (blob &&
>> -	    copy_to_user((void __user *)(uintptr_t)input.address,
>> -			blob, input.length)) {
>> +	if (copy_to_user((void __user *)input.address, blob, input.length)) {
>>  		ret = -EFAULT;
>>  		goto e_shutdown;
>>  	}
>>  
>> -	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
>> -			 sizeof(struct sev_user_data_pek_csr)))
>> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
>>  		ret = -EFAULT;
>>  
>>  e_shutdown:
>>  	if (do_shutdown)
>> -		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
>> +		ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
>> +
>>  e_free_blob:
>>  	kfree(blob);
>>  e_free:
>> @@ -408,10 +403,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>  		ret = sev_ioctl_pdh_gen(&input);
>>  		break;
>>  
>> -	case SEV_PEK_CSR: {
>> +	case SEV_PEK_CSR:
>>  		ret = sev_ioctl_pek_csr(&input);
>>  		break;
>> -	}
>> +
>>  	default:
>>  		ret = -EINVAL;
>>  		goto out;
>>
