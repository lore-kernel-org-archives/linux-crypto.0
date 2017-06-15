From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/6] ima: Simplify policy_func_show.
Date: Thu, 15 Jun 2017 12:00:50 -0400
Message-ID: <1497542450.4287.56.camel@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
         <1496886555-10082-3-git-send-email-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdFOQB0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 12:01:26 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5FFwoIa135049
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2017 12:01:25 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b3spr34pd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2017 12:01:25 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Fri, 16 Jun 2017 02:01:22 +1000
In-Reply-To: <1496886555-10082-3-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2017-06-07 at 22:49 -0300, Thiago Jung Bauermann wrote:
> If the func_tokens array uses the same indices as enum ima_hooks,
> policy_func_show can be a lot simpler, and the func_* enum becomes
> unnecessary.
> 
> Also, if we use the same macro trick used by kernel_read_file_id_str we can
> use one hooks list for both the enum and the string array, making sure they
> are always in sync (suggested by Mimi Zohar).
> 
> Finally, by using the printf pattern for the function token directly
> instead of using the pt macro we can simplify policy_func_show even further
> and avoid needing a temporary buffer.
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>

Thank you.  Queued to be upstreamed.

Mimi
> ---
>  security/integrity/ima/ima.h        | 25 +++++++++-------
>  security/integrity/ima/ima_policy.c | 58 ++++---------------------------------
>  2 files changed, 21 insertions(+), 62 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 215a93c41b51..d52b487ad259 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -172,17 +172,22 @@ static inline unsigned long ima_hash_key(u8 *digest)
>  	return hash_long(*digest, IMA_HASH_BITS);
>  }
> 
> +#define __ima_hooks(hook)		\
> +	hook(NONE)			\
> +	hook(FILE_CHECK)		\
> +	hook(MMAP_CHECK)		\
> +	hook(BPRM_CHECK)		\
> +	hook(POST_SETATTR)		\
> +	hook(MODULE_CHECK)		\
> +	hook(FIRMWARE_CHECK)		\
> +	hook(KEXEC_KERNEL_CHECK)	\
> +	hook(KEXEC_INITRAMFS_CHECK)	\
> +	hook(POLICY_CHECK)		\
> +	hook(MAX_CHECK)
> +#define __ima_hook_enumify(ENUM)	ENUM,
> +
>  enum ima_hooks {
> -	FILE_CHECK = 1,
> -	MMAP_CHECK,
> -	BPRM_CHECK,
> -	POST_SETATTR,
> -	MODULE_CHECK,
> -	FIRMWARE_CHECK,
> -	KEXEC_KERNEL_CHECK,
> -	KEXEC_INITRAMFS_CHECK,
> -	POLICY_CHECK,
> -	MAX_CHECK
> +	__ima_hooks(__ima_hook_enumify)
>  };
> 
>  /* LIM API function definitions */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 949ad3858327..f4436626ccb7 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -972,23 +972,10 @@ static const char *const mask_tokens[] = {
>  	"MAY_APPEND"
>  };
> 
> -enum {
> -	func_file = 0, func_mmap, func_bprm,
> -	func_module, func_firmware, func_post,
> -	func_kexec_kernel, func_kexec_initramfs,
> -	func_policy
> -};
> +#define __ima_hook_stringify(str)	(#str),
> 
>  static const char *const func_tokens[] = {
> -	"FILE_CHECK",
> -	"MMAP_CHECK",
> -	"BPRM_CHECK",
> -	"MODULE_CHECK",
> -	"FIRMWARE_CHECK",
> -	"POST_SETATTR",
> -	"KEXEC_KERNEL_CHECK",
> -	"KEXEC_INITRAMFS_CHECK",
> -	"POLICY_CHECK"
> +	__ima_hooks(__ima_hook_stringify)
>  };
> 
>  void *ima_policy_start(struct seq_file *m, loff_t *pos)
> @@ -1025,49 +1012,16 @@ void ima_policy_stop(struct seq_file *m, void *v)
> 
>  #define pt(token)	policy_tokens[token + Opt_err].pattern
>  #define mt(token)	mask_tokens[token]
> -#define ft(token)	func_tokens[token]
> 
>  /*
>   * policy_func_show - display the ima_hooks policy rule
>   */
>  static void policy_func_show(struct seq_file *m, enum ima_hooks func)
>  {
> -	char tbuf[64] = {0,};
> -
> -	switch (func) {
> -	case FILE_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_file));
> -		break;
> -	case MMAP_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_mmap));
> -		break;
> -	case BPRM_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_bprm));
> -		break;
> -	case MODULE_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_module));
> -		break;
> -	case FIRMWARE_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_firmware));
> -		break;
> -	case POST_SETATTR:
> -		seq_printf(m, pt(Opt_func), ft(func_post));
> -		break;
> -	case KEXEC_KERNEL_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_kexec_kernel));
> -		break;
> -	case KEXEC_INITRAMFS_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_kexec_initramfs));
> -		break;
> -	case POLICY_CHECK:
> -		seq_printf(m, pt(Opt_func), ft(func_policy));
> -		break;
> -	default:
> -		snprintf(tbuf, sizeof(tbuf), "%d", func);
> -		seq_printf(m, pt(Opt_func), tbuf);
> -		break;
> -	}
> -	seq_puts(m, " ");
> +	if (func > 0 && func < MAX_CHECK)
> +		seq_printf(m, "func=%s ", func_tokens[func]);
> +	else
> +		seq_printf(m, "func=%d ", func);
>  }
> 
>  int ima_policy_show(struct seq_file *m, void *v)
