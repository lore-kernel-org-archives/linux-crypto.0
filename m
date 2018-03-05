From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] crypto: ccp: Use memdup_user() rather than duplicating
 its implementation
Date: Mon, 5 Mar 2018 12:52:11 -0600
Message-ID: <a4fc5dc1-1378-313a-9909-6b5891fd8d81@amd.com>
References: <ccd82e60-ba87-d224-3662-365662fa4e6e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ccd82e60-ba87-d224-3662-365662fa4e6e@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 3/5/18 7:10 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 5 Mar 2018 13:50:13 +0100
>
> Reuse existing functionality from memdup_user() instead of keeping
> duplicate source code.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/crypto/ccp/psp-dev.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks

> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index fcfa5b1eae61..8255258cd040 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -367,8 +367,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>  
>  void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>  {
> -	void *data;
> -
>  	if (!uaddr || !len)
>  		return ERR_PTR(-EINVAL);
>  
> @@ -376,18 +374,7 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>  	if (len > SEV_FW_BLOB_MAX_SIZE)
>  		return ERR_PTR(-EINVAL);
>  
> -	data = kmalloc(len, GFP_KERNEL);
> -	if (!data)
> -		return ERR_PTR(-ENOMEM);
> -
> -	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
> -		goto e_free;
> -
> -	return data;
> -
> -e_free:
> -	kfree(data);
> -	return ERR_PTR(-EFAULT);
> +	return memdup_user((void __user *)(uintptr_t)uaddr, len);
>  }
>  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>  
