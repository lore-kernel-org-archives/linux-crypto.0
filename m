From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.4/31] crypto: ccp: Implement
 SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 19:02:05 +0200
Message-ID: <20171011170205.qpu677qiqe4ludwm@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-4-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171007010607.78088-4-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:06:02PM -0500, Brijesh Singh wrote:
> The SEV_PLATFORM_STATUS command can be used by the platform owner to
> get the current status of the platform. The command is defined in
> SEV spec section 5.5.
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
> ---
>  drivers/crypto/ccp/psp-dev.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

...

> @@ -198,6 +228,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  		ret = sev_handle_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
>  		break;
>  	}
> +	case SEV_PLATFORM_STATUS: {
> +		ret = sev_ioctl_platform_status(&input);
> +		break;
> +	}

What's with the curly brackets around the case: statements?

Anyway, here are some more improvements:

* you can get rid of the struct copying into out and the bitfields by
doing something like this:

	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
        if (ret)
                goto e_free;

        /* Clear out reserved fields: */
        data->owner  &= BIT(0);
        data->config &= BIT(0);

I'm not sure those are the ones you need to clear but you get
the idea - you simply poke holes in the reserved fields before
copying to userspace. If you need a more sophisticated mask, use
GENMASK/GENMASK_ULL.

And then you don't need struct sev_user_data_status and
simply remove the bitfields too.

* Also, a function should have a verb in the name, thus
sev_ioctl_do_platform_status().

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d668045956cb..1479db533da0 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -176,9 +176,8 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
-static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
+static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 {
-	struct sev_user_data_status out;
 	struct sev_data_status *data;
 	int ret;
 
@@ -186,19 +185,15 @@ static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
 	if (!data)
 		return -ENOMEM;
 
-	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
 	if (ret)
 		goto e_free;
 
-	out.api_major = data->api_major;
-	out.api_minor = data->api_minor;
-	out.state = data->state;
-	out.owner = data->owner;
-	out.config = data->config;
-	out.build = data->build;
-	out.guest_count = data->guest_count;
-	if (copy_to_user((void __user *)(uintptr_t) argp->data,
-			 &out, sizeof(struct sev_user_data_status)))
+	/* Clear out reserved fields: */
+	data->owner  &= BIT(0);
+	data->config &= BIT(0);
+
+	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
 		ret = -EFAULT;
 
 e_free:
@@ -226,10 +221,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
 		break;
 
-	case SEV_PLATFORM_STATUS: {
-		ret = sev_ioctl_platform_status(&input);
+	case SEV_PLATFORM_STATUS:
+		ret = sev_ioctl_do_platform_status(&input);
 		break;
-	}
+
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 10b843cce75f..223942ba3e7e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -144,11 +144,9 @@ struct sev_data_status {
 	u8 api_major;				/* Out */
 	u8 api_minor;				/* Out */
 	u8 state;				/* Out */
-	u8 owner : 1;				/* Out */
-	u8 reserved1 : 7;
-	u32 config : 1;				/* Out */
-	u32 reserved2 : 23;
-	u32 build : 8;				/* Out */
+	u8 owner;				/* Out */
+	u32 config;				/* Out */
+	u32 build;				/* Out */
 	u32 guest_count;			/* Out */
 } __packed;
 

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
