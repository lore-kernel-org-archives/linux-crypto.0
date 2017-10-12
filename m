From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.5/31] crypto: ccp: Implement SEV_PEK_GEN
 ioctl command
Date: Thu, 12 Oct 2017 15:11:07 -0500
Message-ID: <e2a67da0-5442-f9d6-6390-bfbb0a352639@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-5-brijesh.singh@amd.com>
 <20171012182844.kjv5zab7o6fwwwdk@pd.tnic>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0079.outbound.protection.outlook.com ([104.47.40.79]:26432
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752849AbdJLULO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 16:11:14 -0400
In-Reply-To: <20171012182844.kjv5zab7o6fwwwdk@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/12/17 1:28 PM, Borislav Petkov wrote:
> On Fri, Oct 06, 2017 at 08:06:03PM -0500, Brijesh Singh wrote:
>> The SEV_PEK_GEN command is used to generate a new Platform Endorsement
>> Key (PEK). The command is defined in SEV spec section 5.6.
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Gary Hook <gary.hook@amd.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: linux-crypto@vger.kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  drivers/crypto/ccp/psp-dev.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 68 insertions(+)
> Just small fixups. Worth noting is this:
>
>         if (do_shutdown)
> -               sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
> +               ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
>
> I think we want to return the result of the *last* command
> executed, which, in the do_shutdown=1 case is SEV_CMD_SHUTDOWN, not
> SEV_CMD_PEK_GEN.

Lets  consider this scenario
1- platform is in uninit state, we transition it to INIT
2- PEK_GEN command failed
3- since we have transitioned the platform in INIT state hence we must
call the shutdown otherwise we will leave the system in wrong state. The
shutdown command will most probably succeed and we will look the ret value

> ---
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index d02f48e356e8..31045ea7e798 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -211,7 +211,7 @@ static int sev_platform_get_state(int *state, int *error)
>  	if (!data)
>  		return -ENOMEM;
>  
> -	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
> +	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
>  	if (!ret)
>  		*state = data->state;
>  
> @@ -228,7 +228,7 @@ static int sev_firmware_init(int *error)
>  	if (!data)
>  		return -ENOMEM;
>  
> -	rc = sev_handle_cmd(SEV_CMD_INIT, data, error);
> +	rc = sev_do_cmd(SEV_CMD_INIT, data, error);
>  
>  	kfree(data);
>  	return rc;
> @@ -240,8 +240,8 @@ static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
>  	int ret, state;
>  
>  	/*
> -	 * PEK_GEN command can be issued only when firmware is in INIT state.
> -	 * If firmware is in UNINIT state then we transition it in INIT state
> +	 * The PEK_GEN command can be issued only when the firmware is in INIT
> +	 * state. If it is in UNINIT state then we transition it in INIT state
>  	 * and issue the command.
>  	 */
>  	ret = sev_platform_get_state(&state, &argp->error);
> @@ -258,10 +258,10 @@ static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
>  		do_shutdown = 1;
>  	}
>  
> -	ret = sev_handle_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
> +	ret = sev_do_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
>  
>  	if (do_shutdown)
> -		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
> +		ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
>  
>  	return ret;
>  }
> @@ -291,10 +291,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  		ret = sev_ioctl_do_platform_status(&input);
>  		break;
>  
> -	case SEV_PEK_GEN: {
> +	case SEV_PEK_GEN:
>  		ret = sev_ioctl_pek_gen(&input);
>  		break;
> -	}
> +
>  	default:
>  		ret = -EINVAL;
>  		goto out;
>
