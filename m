From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 16:11:18 -0500
Message-ID: <622585ce-c575-29ff-0484-404b7cf684fc@amd.com>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
 <20171012140816.6siefvahj6ww7uzf@pd.tnic>
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
In-Reply-To: <20171012140816.6siefvahj6ww7uzf@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/12/17 9:08 AM, Borislav Petkov wrote:
...

> Well, if you're going to have a global var, why not pull up the misc
> device instead?
>
> And mind you, I've moved out this assignments:
>
> +       psp->sev_misc = psp_misc_dev;
> +       init_waitqueue_head(&psp->sev_int_queue);
> +       dev_info(dev, "registered SEV device\n");
>
> outside of the if-conditional as I'm assuming you want to do this for
> each psp device for which sev_ops_init() is called.
>
> Or am I wrong here?

I am OK with your patch except  one minor issue highlighted below.

> ---
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 175cb3c3b8ef..d50aaa1ca75b 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -31,7 +31,7 @@
>  #define DEVICE_NAME	"sev"
>  
>  static DEFINE_MUTEX(sev_cmd_mutex);
> -static bool sev_fops_registered;
> +static struct miscdevice *psp_misc_dev;
>  
>  static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>  {
> @@ -242,7 +242,6 @@ EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>  static int sev_ops_init(struct psp_device *psp)
>  {
>  	struct device *dev = psp->dev;
> -	struct miscdevice *misc;
>  	int ret;
>  
>  	/*
> @@ -252,26 +251,24 @@ static int sev_ops_init(struct psp_device *psp)
>  	 * sev_do_cmd() finds the right master device to which to issue the
>  	 * command to the firmware.
>  	 */
> -	if (!sev_fops_registered) {
> -
> -		misc = devm_kzalloc(dev, sizeof(*misc), GFP_KERNEL);
> -		if (!misc)
> +	if (!psp_misc_dev) {
> +		psp_misc_dev = devm_kzalloc(dev, sizeof(struct miscdevice), GFP_KERNEL);
> +		if (!psp_misc_dev)
>  			return -ENOMEM;
>  
> -		misc->minor = MISC_DYNAMIC_MINOR;
> -		misc->name = DEVICE_NAME;
> -		misc->fops = &sev_fops;
> +		psp_misc_dev->minor = MISC_DYNAMIC_MINOR;
> +		psp_misc_dev->name = DEVICE_NAME;
> +		psp_misc_dev->fops = &sev_fops;
>  
> -		ret = misc_register(misc);
> +		ret = misc_register(psp_misc_dev);
>  		if (ret)
>  			return ret;
> -
> -		sev_fops_registered = true;
> -		psp->sev_misc = misc;
> -		init_waitqueue_head(&psp->sev_int_queue);
> -		dev_info(dev, "registered SEV device\n");
>  	}
>  
> +	psp->sev_misc = psp_misc_dev;
> +	init_waitqueue_head(&psp->sev_int_queue);
> +	dev_info(dev, "registered SEV device\n");
> +
>  	return 0;
>  }
>  
> @@ -288,8 +285,8 @@ static int sev_init(struct psp_device *psp)
>  
>  static void sev_exit(struct psp_device *psp)
>  {
> -	if (psp->sev_misc)
> -		misc_deregister(psp->sev_misc);
> +	if (psp_misc_dev)
> +		misc_deregister(psp_misc_dev);

The sev_exit() will be called for all the psp_device instance. we need
to set psp_misc_dev = NULL after deregistering the device.

if (psp_misc_dev) {
  misc_deregister(psp_misc_dev);
   psp_misc_dev = NULL;
}

>  }
>  
>  int psp_dev_init(struct sp_device *sp)
>
