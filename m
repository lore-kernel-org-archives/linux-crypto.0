Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62383148D2;
	Tue,  1 Sep 2026 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265800; cv=none; b=izv4njoh9uX1jTcSe3j6l8fovL9GiIC2k49A+bffUWefyPY9Kz2HX3o8eYTGah3iOiGW2z0klTIPPwAG/TFXmyB+78oyTA8jJwmrbHYSkkXKS8+CQe6z5cVV+DgAXMTa3v6eGWZORMKfixeSvL6mfHZToLKcGqLivtPHEoUq1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265800; c=relaxed/simple;
	bh=jjL7xDPH53V12FyyrnxjEVfwaexXb1GFJlzfMVGdahw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbdRhCFNXYB7YwKXw3YsV3Az6Q+bn0+/MXYp0vFTTmOcksheDP2bf9pSVVOODv00iYvDpDCO2rNGho1Lv0pcr7EiYSwFy5kkmhLmpqhVNIhiyJ9oFzSCb34EddkiPrJRnOGxfMAF+roNzYMm1YODDkEO0gyzYLozk3qffxL170I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccC/SrCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccC/SrCs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E4231F000E9;
	Tue,  1 Sep 2026 12:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788265799;
	bh=HoMXPMqhYMawZqfIgCcour7wfxhHHN4NCbmORc9RngU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ccC/SrCsPJjwdfWqj2oS0XD+mgdFasL+DGe/Y5xZUZoKLxWR4SzlqBURjxMXbT7me
	 VPEqaaEvwrFy3L9xCJh4tkJP7sejSUOpcBC5CIbz360SoB9T+KCnU0YeDQEOfvJRxB
	 a+Ry6jfj5LXl42OeoOZ339IxHlMnRcH57/MBu4a/AZbR39N40K1US1/OUL4EMe9dR3
	 bvWt6NB+bC6A8h4miEYlH8KyenGhXlde8pKH3KRaAOJoya1zjAZVfbZgcO2jVfAa52
	 tcKsd/q2wij9rkngns5xhYFRf2HqQNYRNKRWT+RQE/+IfPdqGGs0HdVkOhQIZD0qX2
	 NvhV5lWZt0CEQ==
Date: Tue, 1 Sep 2026 15:29:52 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: dhowells@redhat.com, lukas@wunner.de, ignat@linux.win,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] keys: reject descriptions that exceed the index length
Message-ID: <apbFQH23Kv01CREM@kernel.org>
References: <20260824113004.3755053-1-4ncienth@gmail.com>
 <apEWZUFe8NmwgPDb@kernel.org>
 <20260828053805.1410721-1-4ncienth@gmail.com>
 <20260828080728.2641312-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828080728.2641312-1-4ncienth@gmail.com>

On Fri, Aug 28, 2026 at 05:07:28PM +0900, Daehyeon Ko wrote:
> struct keyring_index_key::desc_len is a u16.  User-provided key
> descriptions are limited to 4095 bytes, but a key type preparser can
> generate a longer description when the caller passes NULL.
> 
> The X.509 parser forms a description from the certificate subject and
> twice the raw serial length when the certificate has no Subject Key
> Identifier.  A certificate with a two-byte subject and a 32766-byte serial
> therefore produces a 65536-byte description.  Assigning strlen() to
> desc_len wraps it to zero, after which __key_link_begin() hits:
> 
>     BUG_ON(index_key->desc_len == 0);
> 
> This was reproduced through keyctl on a v6.12.105 KASAN kernel with
> panic=1 and oops=panic.  The process ran as uid and gid 1000 with no
> capabilities, and the console recorded:
> 
>     CapInh: 0000000000000000
>     CapPrm: 0000000000000000
>     CapEff: 0000000000000000
>     [   14.044055] ------------[ cut here ]------------
>     [   14.044211] kernel BUG at security/keys/keyring.c:1308!
>     [   14.044375] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>     [   14.044558] CPU: 0 UID: 1000 PID: 138 Comm: keyctl Not tainted 6.12.105-dirty #1
>     [   14.044788] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>     [   14.045025] RIP: 0010:__key_link_begin+0x1e5/0x250
>     [   14.047630] Call Trace:
>     [   14.047711]  <TASK>
>     [   14.047785]  __key_create_or_update+0x490/0xcd0
>     [   14.047954]  ? __pfx___key_create_or_update+0x10/0x10
>     [   14.048139]  ? __pfx_lookup_user_key_possessed+0x10/0x10
>     [   14.048323]  key_create_or_update+0x47/0x60
>     [   14.048484]  __do_sys_add_key+0x219/0x430
>     [   14.048632]  ? __pfx___do_sys_add_key+0x10/0x10
>     [   14.048794]  ? switch_fpu_return+0x127/0x250
>     [   14.048980]  ? srso_return_thunk+0x5/0x5f
>     [   14.049163]  ? arch_exit_to_user_mode_prepare.constprop.0+0x6f/0xa0
>     [   14.049417]  ? srso_return_thunk+0x5/0x5f
>     [   14.049582]  do_syscall_64+0x5a/0x130
>     [   14.049721]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     [   14.051772]  </TASK>
>     [   14.051975] ---[ end trace 0000000000000000 ]---
>     [   14.054729] Kernel panic - not syncing: Fatal exception
> 
> The same boundary was independently reproduced on 3/3 fresh v6.12.105
> KASAN boots with the source reproducer.
> 
> A one-byte-short control with a 32765-byte serial parsed successfully and
> returned EDQUOT without a splat, showing that the wrap boundary is causal.
> 
> Measure generated descriptions before narrowing the length and reject
> values that cannot be represented.  On 3/3 fresh patched mainline KASAN
> boots, the boundary returned EINVAL and the control continued to return
> EDQUOT, with no BUG, Oops, KASAN report, warning or panic.
> 
> A tested source reproducer exists and is available to maintainers
> privately.

I don't think this paragraph should be part of the commit message.



> 
> Fixes: f771fde82051 ("keys: Simplify key description management")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> ---
> Changes in v2:
> - Add the observed keyctl crash trace and before/after runtime results to the
>   commit message.
> - Clarify that the serial is used when the certificate has no Subject Key
>   Identifier.
> - No code changes.
> 
>  security/keys/key.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/security/keys/key.c b/security/keys/key.c
> index b34a64d81d47ab..f2f472b45f4eee 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -14,6 +14,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/random.h>
>  #include <linux/err.h>
> +#include <linux/limits.h>
>  #include "internal.h"
>  
>  struct kmem_cache *key_jar;
> @@ -820,6 +821,7 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
>  	const struct cred *cred = current_cred();
>  	struct key *keyring, *key = NULL;
>  	key_ref_t key_ref;
> +	size_t desc_len;
>  	int ret;
>  	struct key_restriction *restrict_link = NULL;
>  
> @@ -865,7 +867,12 @@ static key_ref_t __key_create_or_update(key_ref_t keyring_ref,
>  		if (!index_key.description)
>  			goto error_free_prep;
>  	}
> -	index_key.desc_len = strlen(index_key.description);
> +	desc_len = strlen(index_key.description);
> +	if (desc_len > U16_MAX) {
> +		key_ref = ERR_PTR(-EINVAL);
> +		goto error_free_prep;
> +	}
> +	index_key.desc_len = desc_len;
>  	key_set_index_key(&index_key);
>  
>  	ret = __key_link_lock(keyring, &index_key);
> 
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> -- 
> 2.54.0

BR, Jarkko
