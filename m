From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.3/31] crypto: ccp: Implement
 SEV_FACTORY_RESET ioctl command
Date: Wed, 11 Oct 2017 16:32:03 +0200
Message-ID: <20171011143203.47rm2ctbzc5apj5f@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-3-brijesh.singh@amd.com>
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
In-Reply-To: <20171007010607.78088-3-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:06:01PM -0500, Brijesh Singh wrote:
> The SEV_FACTORY_RESET command can be used by the platform owner to
> reset the non-volatile SEV related data. The command is defined in
> SEV spec section 5.4
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
>  drivers/crypto/ccp/psp-dev.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)

Some fixes ontop, like, for example, if you hit the default: label of
the switch due to input.cmd being one of the ones in the holes in enum
sev_cmd, you don't need to copy_to_user() in the end.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d3a50f1f737e..ed5a7404b5a5 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -192,19 +192,19 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		return -EINVAL;
 
 	switch (input.cmd) {
-
-	case SEV_FACTORY_RESET: {
-		ret = sev_handle_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
+	case SEV_FACTORY_RESET:
+		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
 		break;
-	}
+
 	default:
 		ret = -EINVAL;
-		break;
+		goto out;
 	}
 
 	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
 		ret = -EFAULT;
 
+out:
 	return ret;
 }

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
