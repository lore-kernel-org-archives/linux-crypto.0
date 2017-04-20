From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] ima: Simplify policy_func_show.
Date: Thu, 20 Apr 2017 08:13:23 -0400
Message-ID: <1492690403.3081.72.camel@linux.vnet.ibm.com>
References: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
         <1492546666-16615-4-git-send-email-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1492546666-16615-4-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2017-04-18 at 17:17 -0300, Thiago Jung Bauermann wrote:
> If the func_tokens array uses the same indices as enum ima_hooks,
> policy_func_show can be a lot simpler, and the func_* enum becomes
> unnecessary.

My main concern with separating the enumeration from the string
definition is that they might become out of sync.  Perhaps using
macros, similar to those used for kernel_read_file_id_str(), would be
better?

> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
> ---
>  security/integrity/ima/ima_policy.c | 47 ++++++-------------------------------
>  1 file changed, 7 insertions(+), 40 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index cfda5d7b17ec..158eafef64e8 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -896,20 +896,14 @@ static const char *const mask_tokens[] = {
>  	"MAY_APPEND"
>  };
> 
> -enum {
> -	func_file = 0, func_mmap, func_bprm,
> -	func_module, func_firmware, func_post,
> -	func_kexec_kernel, func_kexec_initramfs,
> -	func_policy
> -};
> -

At least, add a comment here and near the ima_hooks enumeration to
prevent them from becoming out of sync.

Mimi

>  static const char *const func_tokens[] = {
> +	NULL,
>  	"FILE_CHECK",
>  	"MMAP_CHECK",
>  	"BPRM_CHECK",
> +	"POST_SETATTR",
>  	"MODULE_CHECK",
>  	"FIRMWARE_CHECK",
> -	"POST_SETATTR",
>  	"KEXEC_KERNEL_CHECK",
>  	"KEXEC_INITRAMFS_CHECK",
>  	"POLICY_CHECK"
> @@ -949,48 +943,21 @@ void ima_policy_stop(struct seq_file *m, void *v)
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
> +	if (func > 0 && func < MAX_CHECK)
> +		seq_printf(m, pt(Opt_func), func_tokens[func]);
> +	else {
> +		char tbuf[64] = {0,};
> 
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
>  		snprintf(tbuf, sizeof(tbuf), "%d", func);
>  		seq_printf(m, pt(Opt_func), tbuf);
> -		break;
>  	}
> +
>  	seq_puts(m, " ");
>  }
> 

