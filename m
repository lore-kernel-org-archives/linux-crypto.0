Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=204.191.154.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794543519;
	b=j4i3qWZ4miWhsaNqNUSSxizbNlQZ4cw0/vjgbiXJ3m2Kyn4wnZXVY9LkiwCiDNyVj9eK
	 o0yxVUmaDA3+yRw9YMJt/Eczw+k+1hq49gXbepp99uPNEEdRPAhicstT03XGXiEsvEx66
	 Jdk+G1vLJ+YBN2cSDFH7jgN8TtAvLvuC3A0Au/KKzeiuILWbyPqiy0k3nEqj2Mk/2b+dg
	 SLtuxM2jcs9K6pV+jOd9F/oryeikSnRt374Ts0r185qyowSjpN6hg8UkFbtYQtL6Sy/Rz
	 QN+aJjO7fhU6rwgnmDZg9+j1uuch0h9Oi/RKs5qrqYEb9t7XDYglsy+w8WHGFWRQSwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794543519;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-SA-Exim-Connect-IP:
	 X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:Subject:X-SA-Exim-Version:
	 X-SA-Exim-Scanned;
	bh=ZiYALzwBjI65tTTQSXY2U+ySmJs1lqd9md75ReSDjlI=;
	b=RVEVr5DUf2Hx/aHS2/7ac/TmC9EP9RYaf8loOb2FZAoouX2mhrv+jnJRU+HggH8MXTXS
	 ezifIhjMMi+DE4cOHOPA+DfZXBlbuRMkIzsu+7eyFaP5Ln6fIFmUPJJ87WPg6G0tIyj9b
	 7ZuitI+hLO493+fOWR4iDtF+T84LW4Kr1bOKqMxbKkjeZzBiAAyY7+/neOYBtRYlF7P/Q
	 semkonf34IiRC2ZjCintLtvS74tUnUEkNrjcZHBza6HiNSynxaniYY2e9GIj72iTvmDHE
	 SswSmHCU4+modtSOCcSWiZm5GRMwD2yz6E3m6NnjrInkbmEZjL1lz81a0asuriJrJHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=deltatee.com;
	spf=pass smtp.mailfrom=deltatee.com;
	dkim=pass header.d=deltatee.com header.i=@deltatee.com header.a=rsa-sha256 header.s=20200525 header.b=sqJVO9Oh;
	arc=none smtp.remote-ip=204.191.154.188
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B7606A31C;
	Fri, 13 Nov 2026 04:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 420B7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.a=rsa-sha256 header.s=20200525 header.b=sqJVO9Oh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=ZiYALzwBjI65tTTQSXY2U+ySmJs1lqd9md75ReSDjlI=; b=sqJVO9OhFJFFp5d+CorT0gFFwx
	gQHtm0rP9jBKdo5gtNhPuLDVJFyS5i84cybGKtUoyz1fhqHNy/GRDTRJWNgzdqFTWEyGhMkX/IdYX
	1gczl9YxmBvNI3QYA9KvCiNAWLYKnpgv/dbGuxQdmfjTnj+SrMaiu9Ge6b2Zzu3cJj3uIAscyiV2Z
	gGz+MjtR0Ub8ypP0wa3inb778TZZgjDpL3fgNIJjKwllEUMLxQ7GC61J0NW/qoFJgAi8vPToPSlrb
	Ptdylv4aBTXI6DXk9fq3Si66BLJQ8a5feCTMk2q9JmLUpH879Zp+OriFt9ucCWJscZvyIYeC/6V5J
	pp72RlUg==;
Received: from [104.157.31.28] (helo=[192.168.1.251])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1xRik9-00000002SeY-3ZkQ;
	Thu, 12 Nov 2026 22:18:32 -0600
Message-ID: <029ccd27-68df-4e0a-bf27-3b40f68e91c6@deltatee.com>
Date: Thu, 12 Nov 2026 22:17:50 -0600
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Pavel Popov <pavel.e.popov@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
 linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, platform-driver-x86@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-4-pavel.e.popov@intel.com>
From: Logan Gunthorpe <logang@deltatee.com>
Content-Language: en-CA
In-Reply-To: <20261111234821.4814-4-pavel.e.popov@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 104.157.31.28
X-SA-Exim-Rcpt-To: pavel.e.popov@intel.com, rafael@kernel.org, viresh.kumar@linaro.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, tursulin@ursulin.net, alexander.deucher@amd.com, christian.koenig@amd.com, hansg@kernel.org, ilpo.jarvinen@linux.intel.com, peterhuewe@gmx.de, jarkko@kernel.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, leon@kernel.org, bhelgaas@google.com, arnd@arndb.de, lenb@kernel.org, sakari.ailus@linux.intel.com, jgg@ziepe.ca, airlied@gmail.com, simona@ffwll.ch, davem@davemloft.net, x86@kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, platform-driver-x86@vger.kernel.org, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [PATCH 3/7] drm/amdgpu: Include <asm/cpu_device_id.h>
 unconditionally
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2026-11-11 5:48 p.m., Pavel Popov wrote:
> <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> CONFIG_X86 around the include is no longer needed.
> 
> <asm/intel-family.h> is included by <asm/cpu_device_id.h>.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
> ---
> Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
> it is in mainline.
> 
> [1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com
> 
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index 19a566187df..fc4e7273630 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -88,10 +88,7 @@
>  
>  #include <drm/drm_drv.h>
>  
> -#if IS_ENABLED(CONFIG_X86)
> -#include <asm/intel-family.h>
>  #include <asm/cpu_device_id.h>
> -#endif
>  
I don't see the corresponding addition of adding the cpu_device_id.h.
The commit message doesn't mention that. Am I missing something here?

Logan
