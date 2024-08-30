Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B11D18E355;
	Fri, 30 Aug 2024 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013711; cv=none; b=D2vQ6vrS9wmkTc5yKWIXXFl241GvsU10nMtSqCdh6VU84SLeXeYJu6n5pMSciiEzrKffKexjZ6EpBdqqaz/kmRuBe/lMGHCjGBRh4u6TGVH+ZXYzQBU6rceWli9H9AFy8YjyyXnhnB5brX5QXmsIFkeS+deD91KEro0JqLLbpPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013711; c=relaxed/simple;
	bh=zIr6ofHRy4wHFT1oom3DmckyPg52yr84jBW6Dqoz3Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNR6K2lplVii/R8R9kRm+o94ksdkgZhElhaQQd5n4QavXBtP3kWGzSrB4zCxRjwfA/qBld97DmO+WIQfiXIb3adwybtij+l3DgaE8NgX6H+cgXjLKRhH47QfMhDWvc5KSY+jJptNSVdHItFn3zCZ8+uPlV8bglYTrKIr4V5uAfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjyj9-008Ufb-1u;
	Fri, 30 Aug 2024 18:28:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:28:20 +0800
Date: Fri, 30 Aug 2024 18:28:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavan Kumar Paluri <papaluri@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Properly unregister /dev/sev on sev
 PLATFORM_STATUS failure
Message-ID: <ZtGexA2G-kOTQZ4i@gondor.apana.org.au>
References: <20240815122500.71946-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815122500.71946-1-papaluri@amd.com>

On Thu, Aug 15, 2024 at 07:25:00AM -0500, Pavan Kumar Paluri wrote:
> In case of sev PLATFORM_STATUS failure, sev_get_api_version() fails
> resulting in sev_data field of psp_master nulled out. This later becomes
> a problem when unloading the ccp module because the device has not been
> unregistered (via misc_deregister()) before clearing the sev_data field
> of psp_master. As a result, on reloading the ccp module, a duplicate
> device issue is encountered as can be seen from the dmesg log below.
> 
> on reloading ccp module via modprobe ccp
> 
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xd7/0xf0
>   dump_stack+0x10/0x20
>   sysfs_warn_dup+0x5c/0x70
>   sysfs_create_dir_ns+0xbc/0xd
>   kobject_add_internal+0xb1/0x2f0
>   kobject_add+0x7a/0xe0
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   ? get_device_parent+0xd4/0x1e0
>   ? __pfx_klist_children_get+0x10/0x10
>   device_add+0x121/0x870
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   device_create_groups_vargs+0xdc/0x100
>   device_create_with_groups+0x3f/0x60
>   misc_register+0x13b/0x1c0
>   sev_dev_init+0x1d4/0x290 [ccp]
>   psp_dev_init+0x136/0x300 [ccp]
>   sp_init+0x6f/0x80 [ccp]
>   sp_pci_probe+0x2a6/0x310 [ccp]
>   ? srso_alias_return_thunk+0x5/0xfbef5
>   local_pci_probe+0x4b/0xb0
>   work_for_cpu_fn+0x1a/0x30
>   process_one_work+0x203/0x600
>   worker_thread+0x19e/0x350
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0xeb/0x120
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x3c/0x60
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>   kobject: kobject_add_internal failed for sev with -EEXIST, don't try to register things with the same name in the same directory.
>   ccp 0000:22:00.1: sev initialization failed
>   ccp 0000:22:00.1: psp initialization failed
>   ccp 0000:a2:00.1: no command queues available
>   ccp 0000:a2:00.1: psp enabled
> 
> Address this issue by unregistering the /dev/sev before clearing out
> sev_data in case of PLATFORM_STATUS failure.
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
