From: Dave Young <dyoung@redhat.com>
Subject: Re: [V2][PATCH 2/2] pefile: Fix the failure of calculation for digest
Date: Thu, 14 Jul 2016 10:18:34 +0800
Message-ID: <20160714021834.GC3798@dhcp-128-65.nay.redhat.com>
References: <1468416937-21237-2-git-send-email-jia.zhang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, kexec@lists.infradead.org, vgoyal@redhat.com,
	bhe@redhat.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Lans Zhang <jia.zhang@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbcGNCSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jul 2016 22:18:40 -0400
Content-Disposition: inline
In-Reply-To: <1468416937-21237-2-git-send-email-jia.zhang@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cc crypto list

On 07/13/16 at 09:35pm, Lans Zhang wrote:
> The commit e68503bd68 forgot to set digest_len and thus cause the following
> error reported by kexec when launching a crash kernel:
> "kexec_file_load failed: Bad message"
> 
> Fixes: e68503bd68 (KEYS: Generalise system_verify_data() to provide access to internal content)
> Signed-off-by: Lans Zhang <jia.zhang@windriver.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  crypto/asymmetric_keys/mscode_parser.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
> index 6a76d5c..9492e1c 100644
> --- a/crypto/asymmetric_keys/mscode_parser.c
> +++ b/crypto/asymmetric_keys/mscode_parser.c
> @@ -124,5 +124,10 @@ int mscode_note_digest(void *context, size_t hdrlen,
>  	struct pefile_context *ctx = context;
>  
>  	ctx->digest = kmemdup(value, vlen, GFP_KERNEL);
> -	return ctx->digest ? 0 : -ENOMEM;
> +	if (!ctx->digest)
> +		return -ENOMEM;
> +
> +	ctx->digest_len = vlen;
> +
> +	return 0;
>  }
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
