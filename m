From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [Part2 PATCH v6 17/38] crypto: ccp: Implement SEV_PDH_GEN ioctl
 command
Date: Tue, 24 Oct 2017 13:41:35 -0500
Message-ID: <8a8f02e2-f613-6da8-0e5c-5fc1cd22ec8f@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-18-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:35200
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751511AbdJXSlo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 14:41:44 -0400
In-Reply-To: <20171020023413.122280-18-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/19/2017 09:33 PM, Brijesh Singh wrote:
> The SEV_PDH_GEN command is used to re-generate the Platform
> Diffie-Hellman (PDH) key. The command is defined in SEV spec section
> 5.6.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/psp-dev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1d7212da25a5..d9771d104eea 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -239,6 +239,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	case SEV_PEK_GEN:
>   		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
>   		break;
> +	case SEV_PDH_GEN:
> +		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> 
