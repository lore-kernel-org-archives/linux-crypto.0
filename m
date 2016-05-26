From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] KEYS: Add optional key derivation parameters for DH
Date: Thu, 26 May 2016 21:10:50 +0100
Message-ID: <23038.1464293450@warthog.procyon.org.uk>
References: <20160526165741.2634-1-mathew.j.martineau@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, smueller@chronox.de, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbcEZUKx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 16:10:53 -0400
In-Reply-To: <20160526165741.2634-1-mathew.j.martineau@linux.intel.com>
Content-ID: <23037.1464293450.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:

> +struct keyctl_kdf_params {
> +	char *name;
> +	__u8 reserved[32]; /* Reserved for future use, must be 0 */
> +};
> +
>  #endif /*  _LINUX_KEYCTL_H */
> diff --git a/security/keys/compat.c b/security/keys/compat.c
> index c8783b3..36c80bf 100644
> --- a/security/keys/compat.c
> +++ b/security/keys/compat.c
> @@ -134,7 +134,7 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
>  
>  	case KEYCTL_DH_COMPUTE:
>  		return keyctl_dh_compute(compat_ptr(arg2), compat_ptr(arg3),
> -					 arg4);
> +					 arg4, compat_ptr(arg5));

Given the new structure above, this won't work.  The problem is that on a
64-bit system the kernel expects 'name' to be a 64-bit pointer, but if we're
in the compat handler, we have a 32-bit userspace's idea of the struct - in
which 'name' is a 31-bit (s390x) or a 32-bit pointer without any padding.

So in compat code you can't just pass the user pointer direct through to
keyctl_dh_compute().  You need to supply a compat_keyctl_kdf_params struct and
translator code.

What I would recommend you do at the moment is to mark the syscall argument as
"reserved, must be 0" and deal with the implementation in the next merge
window.

David
