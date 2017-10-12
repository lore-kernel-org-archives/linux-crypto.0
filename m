From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.5/31] crypto: ccp: Implement SEV_PEK_GEN
 ioctl command
Date: Thu, 12 Oct 2017 20:28:44 +0200
Message-ID: <20171012182844.kjv5zab7o6fwwwdk@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-5-brijesh.singh@amd.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171007010607.78088-5-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:06:03PM -0500, Brijesh Singh wrote:
> The SEV_PEK_GEN command is used to generate a new Platform Endorsement
> Key (PEK). The command is defined in SEV spec section 5.6.
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
>  drivers/crypto/ccp/psp-dev.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)

Just small fixups. Worth noting is this:

        if (do_shutdown)
-               sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+               ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);

I think we want to return the result of the *last* command
executed, which, in the do_shutdown=1 case is SEV_CMD_SHUTDOWN, not
SEV_CMD_PEK_GEN.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d02f48e356e8..31045ea7e798 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -211,7 +211,7 @@ static int sev_platform_get_state(int *state, int *error)
 	if (!data)
 		return -ENOMEM;
 
-	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
 	if (!ret)
 		*state = data->state;
 
@@ -228,7 +228,7 @@ static int sev_firmware_init(int *error)
 	if (!data)
 		return -ENOMEM;
 
-	rc = sev_handle_cmd(SEV_CMD_INIT, data, error);
+	rc = sev_do_cmd(SEV_CMD_INIT, data, error);
 
 	kfree(data);
 	return rc;
@@ -240,8 +240,8 @@ static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
 	int ret, state;
 
 	/*
-	 * PEK_GEN command can be issued only when firmware is in INIT state.
-	 * If firmware is in UNINIT state then we transition it in INIT state
+	 * The PEK_GEN command can be issued only when the firmware is in INIT
+	 * state. If it is in UNINIT state then we transition it in INIT state
 	 * and issue the command.
 	 */
 	ret = sev_platform_get_state(&state, &argp->error);
@@ -258,10 +258,10 @@ static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
 		do_shutdown = 1;
 	}
 
-	ret = sev_handle_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
 
 	if (do_shutdown)
-		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+		ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
 
 	return ret;
 }
@@ -291,10 +291,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_do_platform_status(&input);
 		break;
 
-	case SEV_PEK_GEN: {
+	case SEV_PEK_GEN:
 		ret = sev_ioctl_pek_gen(&input);
 		break;
-	}
+
 	default:
 		ret = -EINVAL;
 		goto out;

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
