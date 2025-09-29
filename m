Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539882D6E43
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 09:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759139264; cv=none; b=FBNXYSEimgK73pZ8T0cVnAv76sZyNOuaZEFp3eAW5xljEe8jlyuasd7fmRtg8OjdkeLPTicKEv+a0cxXDhQdl1sR2dbHuycPS0f1mxIE4Fext0j5LaCxXf65KekbYz8esRbe9Pz5HIo1h2MWwaSkKutTkiL3T+gLmYEduY9ly3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759139264; c=relaxed/simple;
	bh=ASXwhqcORvhNkY2l90P911X8c8KnWjYM2LqXASGJUjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vb2bn8TzUBQlmqbZfAOCL+O1fhfIcfkHjz0k5ocNH1OoetYHw4PLWiZwMdJtmlE2sh0xBxXcqYxeupg/iaXvemCHyWj6NmeFEE+x2o+bpVMyR1eJ0FIZy+w6fdh67fJVUy/JCCKl4Ci3qBHuQpC42TqrtsE0jYWuEErIerPrzvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ahc4rbbO; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ahc4rbbO"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3f0308469a4so2562899f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 02:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759139261; x=1759744061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p1eJI1OUZqzGZIEOdjNU40XW3K4YBNlIBSlep784rzc=;
        b=ahc4rbbOmLOCUOqSkuOI1ehNV0iz2TTTNA6dgEqGbxBhW4+vBB6Tw0Ofjv/oJLT5G0
         gMpl2erMRJGd49E5/puVx38wau1gSmZ3W5XEMZ+IlhGE3keoM1Jo708/NKNsj27fWP4q
         vq9+ujtQAjbawuuum0rsWYIe/5c7pJ/2rkbRbiz0aEah8fFJa/5YOeaP/oceTSLQFa0h
         5H7UnmZJ6xNEkxrZQwwpnCdb6pF9VDOBEsZqPsgjOmtnnQZns7kOUeDvjWpn04fmjqOi
         HsliU0914ppO20Hff+qfSzjoRhws+ZLh93O2SerhE+gNy3+WpdRfXzx3OI6jt2Xlq9g6
         oVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759139261; x=1759744061;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1eJI1OUZqzGZIEOdjNU40XW3K4YBNlIBSlep784rzc=;
        b=bKoHazqCf5TmCbJofeLX/tDHi7RvxnDcb7sX7aYxTpSPih+7LDMp4SUdRkMxtoILvg
         Dk4T0zIoQOQ3U+1aACDHhBB0eNTE0AgYK7cfD676TAt359HrZi60SbacbnT6E6sNYch2
         jt4D7uiXJBGEDGAnVoZEPasQnafe3RgGLFbw3fE7c+6ZgWXPhqSNZL1rWtbYEfOho636
         Oh66F5BIVTJxccRTd519T/lMQ6HG/UIEMFufHTPoDg+DO3L+Wz6QCgdlxanua4CSy9Jk
         7E2nE5Y+LFZZwHIz4ZKOwxp//19kRvnCzepcXUfh9ErmTNmX5WxPyYqgK43AGanLcMKB
         V//g==
X-Forwarded-Encrypted: i=1; AJvYcCVBp3jeri+9nHNlu5455PAJGrxkJFuK8N7bcfvy4b0HiS5Yn/5rDkexXr7k3jBKD17R6e3KUzH9jzRpE9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTRoeinzaoQEXYwvy7ChwjlR/V49nUX1zquwcxygUqQbGRa1ts
	j/hzf50TH2zqHiOpIhTyuxE7lmQb4Hc08onRGH0OEwWmnA2zHalOky2F13HuT5b5WVw=
X-Gm-Gg: ASbGncsGjuNs6zL7LAsndwrPsZjEbb33UYdyjBb4B+Pn0DQQyR28xUAYzNYXRCSHFjs
	Cwl3KxpcjvYbK1ySjKCSzv48p6dOGmTHNNfz6SH/td63/tobpELj5VVsG7D52D/DJnIRZVLxwrI
	GKWTN2mAeiyIvv5AYQoCmfUwiYK0vQ2Q/b2Uhc47gyu3/nfXkITUpgRiahxVQrzdZH6ZDcA6B56
	XFX4Xse/M1LegIhzdFZDqoKO+NXjKD95mKX1d+AHpiVN/Ixu3TxZAazBWfGpbtmVGmv1jAvmRg2
	Ivt6O3OSRBghLoTEtOyVMiJXF14wYBqntlnJVnYjhdAvElp49IIDAzOkTdUx4c31tCrSAigYeRn
	rGJlvGb8EKq39IQrzDDVhuxwbMNP9iKQil4fmWNl9/yreiidFmA5Kyw==
X-Google-Smtp-Source: AGHT+IGp7WQmlNJyGfoAWrgsGxFEL6Znj/8z2UZGtWFBZgR6B6emhNKiOUHLvrUGAeRm1cRG2rq/hQ==
X-Received: by 2002:a05:6000:26c9:b0:3fc:e880:8bc with SMTP id ffacd0b85a97d-40e45a92576mr14528488f8f.16.1759139260579;
        Mon, 29 Sep 2025 02:47:40 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb7203b8asm17744328f8f.9.2025.09.29.02.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 02:47:40 -0700 (PDT)
Message-ID: <b689b57d-07bd-4d11-98f0-9a99f0fa3c5d@suse.com>
Date: Mon, 29 Sep 2025 11:47:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 019/104] module: add load_module_mem() helper
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
 Vladis Dronov <vdronov@redhat.com>, Stephan Mueller <smueller@chronox.de>,
 Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
 Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-20-vegard.nossum@oracle.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20250904155216.460962-20-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 5:50 PM, Vegard Nossum wrote:
> Add a new helper function, load_module_mem(), which can load a kernel
> module from a byte array in memory.
> 
> Also add a new module loader flag, MODULE_INIT_MEM, signalling that a
> module was loaded in this way.
> 
> When a module is loaded with load_module_mem(), we do a few things
> differently:
> 
> - don't do signature verification
> - ignore vermagic

Why is checking the vermagic skipped?

> - don't taint the kernel

Why is tainting the kernel skipped?

> - keep the initial reference to the module until the caller wants to
>   drop it
> 
> These changes are necessary for having a bundled (but separately
> compiled) FIPS module.
> 
> We may want to let distros carry patches to disable tainting separately
> so this information is not lost in case somebody builds a non-distro
> kernel using a FIPS module compiled for an incompatible version.
> 
> Co-developed-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

I realize this is posted as an RFC so I'm not sure if you're looking for
more detailed comments on the implementation at this point. Nonetheless,
some notes are provided below.

> ---
>  include/linux/module.h      |  2 +
>  include/uapi/linux/module.h |  5 ++
>  kernel/module/main.c        | 99 ++++++++++++++++++++++++++-----------
>  3 files changed, 77 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 3319a5269d28..00d85602fb6a 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -586,6 +586,8 @@ struct module {
>  
>  #ifdef CONFIG_MODULES
>  
> +extern int load_module_mem(const char *mem, size_t size);
> +

Nit: The extern keyword is unnecessary here. See
Documentation/process/coding-style.rst, 6.1) Function prototypes.

>  /* Get/put a kernel symbol (calls must be symmetric) */
>  void *__symbol_get(const char *symbol);
>  void *__symbol_get_gpl(const char *symbol);
> diff --git a/include/uapi/linux/module.h b/include/uapi/linux/module.h
> index 03a33ffffcba..5dcd24018be7 100644
> --- a/include/uapi/linux/module.h
> +++ b/include/uapi/linux/module.h
> @@ -7,4 +7,9 @@
>  #define MODULE_INIT_IGNORE_VERMAGIC	2
>  #define MODULE_INIT_COMPRESSED_FILE	4
>  
> +#ifdef __KERNEL__
> +/* Internal flags */
> +#define MODULE_INIT_MEM			30
> +#endif
> +

This looks to be incorrect, 30 is 0b11110. The value should be a flag
with only one bit set.

Additionally, I think referring to this special-type module as MEM is
misleading as all modules are eventually loaded from the kernel memory.
Perhaps call it MODULE_INIT_EMBEDDED_FILE, which also aligns with
MODULE_INIT_COMPRESSED_FILE?

>  #endif /* _UAPI_LINUX_MODULE_H */
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index c66b26184936..12ce4bad29ca 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2572,11 +2572,14 @@ static void module_augment_kernel_taints(struct module *mod, struct load_info *i
>  
>  static int check_modinfo(struct module *mod, struct load_info *info, int flags)
>  {
> -	const char *modmagic = get_modinfo(info, "vermagic");
> +	const char *modmagic = NULL;
>  	int err;
>  
> -	if (flags & MODULE_INIT_IGNORE_VERMAGIC)
> -		modmagic = NULL;
> +	if (flags & MODULE_INIT_MEM)
> +		return 0;
> +
> +	if (!(flags & MODULE_INIT_IGNORE_VERMAGIC))
> +		modmagic = get_modinfo(info, "vermagic");
>  
>  	/* This is allowed: modprobe --force will invalidate it. */
>  	if (!modmagic) {
> @@ -3007,7 +3010,7 @@ module_param(async_probe, bool, 0644);
>   * Keep it uninlined to provide a reliable breakpoint target, e.g. for the gdb
>   * helper command 'lx-symbols'.
>   */
> -static noinline int do_init_module(struct module *mod)
> +static noinline int do_init_module(struct module *mod, int flags)
>  {
>  	int ret = 0;
>  	struct mod_initfree *freeinit;
> @@ -3071,7 +3074,8 @@ static noinline int do_init_module(struct module *mod)
>  			mod->mem[MOD_INIT_TEXT].base + mod->mem[MOD_INIT_TEXT].size);
>  	mutex_lock(&module_mutex);
>  	/* Drop initial reference. */
> -	module_put(mod);
> +	if (!(flags & MODULE_INIT_MEM))
> +		module_put(mod);
>  	trim_init_extable(mod);
>  #ifdef CONFIG_KALLSYMS
>  	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
> @@ -3347,31 +3351,17 @@ static int early_mod_check(struct load_info *info, int flags)
>  /*
>   * Allocate and load the module: note that size of section 0 is always
>   * zero, and we rely on this for optional sections.
> + *
> + * NOTE: module signature verification must have been done already.
>   */
> -static int load_module(struct load_info *info, const char __user *uargs,
> -		       int flags)
> +static int _load_module(struct load_info *info, const char __user *uargs,
> +			int flags)
>  {
>  	struct module *mod;
>  	bool module_allocated = false;
>  	long err = 0;
>  	char *after_dashes;
>  
> -	/*
> -	 * Do the signature check (if any) first. All that
> -	 * the signature check needs is info->len, it does
> -	 * not need any of the section info. That can be
> -	 * set up later. This will minimize the chances
> -	 * of a corrupt module causing problems before
> -	 * we even get to the signature check.
> -	 *
> -	 * The check will also adjust info->len by stripping
> -	 * off the sig length at the end of the module, making
> -	 * checks against info->len more correct.
> -	 */
> -	err = module_sig_check(info, flags);
> -	if (err)
> -		goto free_copy;
> -
>  	/*
>  	 * Do basic sanity checks against the ELF header and
>  	 * sections. Cache useful sections and set the
> @@ -3405,7 +3395,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	 * We are tainting your kernel if your module gets into
>  	 * the modules linked list somehow.
>  	 */
> -	module_augment_kernel_taints(mod, info);
> +	if (!(flags & MODULE_INIT_MEM))
> +		module_augment_kernel_taints(mod, info);
>  
>  	/* To avoid stressing percpu allocator, do this once we're unique. */
>  	err = percpu_modalloc(mod, info);
> @@ -3452,7 +3443,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	flush_module_icache(mod);
>  
>  	/* Now copy in args */
> -	mod->args = strndup_user(uargs, ~0UL >> 1);
> +	if ((flags & MODULE_INIT_MEM))
> +		mod->args = kstrdup("", GFP_KERNEL);
> +	else
> +		mod->args = strndup_user(uargs, ~0UL >> 1);
> +
>  	if (IS_ERR(mod->args)) {
>  		err = PTR_ERR(mod->args);
>  		goto free_arch_cleanup;
> @@ -3500,13 +3495,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	if (codetag_load_module(mod))
>  		goto sysfs_cleanup;
>  
> -	/* Get rid of temporary copy. */
> -	free_copy(info, flags);
> -
>  	/* Done! */
>  	trace_module_load(mod);
>  
> -	return do_init_module(mod);
> +	return do_init_module(mod, flags);
>  
>   sysfs_cleanup:
>  	mod_sysfs_teardown(mod);
> @@ -3562,7 +3554,52 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  		audit_log_kern_module(info->name ? info->name : "?");
>  		mod_stat_bump_becoming(info, flags);
>  	}
> +	return err;
> +}
> +
> +/*
> + * Load module from kernel memory without signature check.
> + */
> +int load_module_mem(const char *mem, size_t size)

The description and name of this function are not ideal. All module
loads via load_module() are from the kernel memory and skipping the
signature check is not the only different property.

I suggest calling the function load_embedded_module() and improving its
description. Please preferably also use a kernel-doc to describe it as
the function is external.

> +{
> +	int err;
> +	struct load_info info = { };
> +
> +	info.sig_ok = true;
> +	info.hdr = (Elf64_Ehdr *) mem;
> +	info.len = size;
> +
> +	err = _load_module(&info, NULL, MODULE_INIT_MEM);
> +	if (0)
> +		free_copy(&info, 0);

Remove the dead code.

> +
> +	return err;
> +}
> +
> +static int load_module(struct load_info *info, const char __user *uargs,
> +		       int flags)
> +{
> +	int err;
> +
> +	/*
> +	 * Do the signature check (if any) first. All that
> +	 * the signature check needs is info->len, it does
> +	 * not need any of the section info. That can be
> +	 * set up later. This will minimize the chances
> +	 * of a corrupt module causing problems before
> +	 * we even get to the signature check.
> +	 *
> +	 * The check will also adjust info->len by stripping
> +	 * off the sig length at the end of the module, making
> +	 * checks against info->len more correct.
> +	 */
> +	err = module_sig_check(info, flags);
> +	if (!err)
> +		err = _load_module(info, uargs, flags);
> +
> +	/* Get rid of temporary copy. */
>  	free_copy(info, flags);
> +
>  	return err;
>  }

In the current code, the load_module() function frees the temporary copy
prior to calling the module's init function, which should generally
result in less memory pressure. This behavior looks useful to me to
preserve.

You could keep the current load_module() as is but wrap its
module_sig_check() call with 'if (!info->sig_ok)'. Similarly, the
free_copy() call could be protected by
'if (!(flags & MODULE_INIT_MEM))'.

>  
> @@ -3728,6 +3765,10 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
>  
>  	pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
>  
> +	/*
> +	 * Deliberately omitting MODULE_INIT_MEM as it is for internal use
> +	 * only.
> +	 */
>  	if (flags & ~(MODULE_INIT_IGNORE_MODVERSIONS
>  		      |MODULE_INIT_IGNORE_VERMAGIC
>  		      |MODULE_INIT_COMPRESSED_FILE))

Nit: I suggest the following to improve the comment flow:

	/*
	 * Check flags validity. Deliberately omit MODULE_INIT_MEM as it is for
	 * internal use only.
	 */

-- 
Thanks,
Petr
