Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435A8485CE6
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789132968; cv=none; b=pKlmczaPyFtYNHqptMAH8ONhFekQr7vHEfdAw14uYiNqRnRY4sfpeijb7PotNBV6K9W7ly+E21nCy1HwE3mOEhKyKOOMUMpl3V404sqJmRiQN+KMRNzT6aQbVR5DqA8uHsc7u86+RIcVqmHMl+nOjBvRSj6MiFEENCkWgBveSfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789132968; c=relaxed/simple;
	bh=T/e2vgzi/yX3haBVonSYMOMOZ1YJ8sxvxQcGMOKmPKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bjy/TQl7Inu4D+lkTvNVUi8CPrKK3kUBFnP/MPHlp/cFdmHFfz9+Ovz4zlnUgwy2QER1RBlxcOIj04DfeX7aU0j1J4ebJwFGTox1+lFHB7eq7Jh6vv0wDkc4M1YH7sZVP0s6+P/vKawxMiKI+Pk1yDiJIDAzXBzeJgwgU93EtRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RLwvSvK3; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RLwvSvK3"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-396638f9a18so1537304a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 06:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789132963; x=1789737763; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqAHaS5fsv9ERkHKe2Kmet0fUHotC014bD2kFqqX4to=;
        b=RLwvSvK31Nx6W5e5cWd1Zwn3GrqgUoi6AhS072W/uylcwVwZ3gpe+kx6GEa9rIFlk0
         FYF4erl5BDuLlexOocQCSN41l6ccwOOPma6v34CdMIG5khIVZqkDirlCdqv964QjHzjX
         wPzKEn407qRm3Embbs+yCBCiSEJTY3Js8tzzleFdo1mBTOxt2yTNnE2xosV20WkoMQvM
         wIayUAwD/BVN9hgLYwfzEr+DeuhSbiV33KL8FX8Bmqy/2DX9ttcVZLG7uRr6EAwczGFk
         ZiDQLDEUQiAQ8XVcZzOaCJECezVH/N/QfYRIjvdt+E3bJGSQdWRG09uKOPUwfNDqFGFJ
         twjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789132963; x=1789737763;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kqAHaS5fsv9ERkHKe2Kmet0fUHotC014bD2kFqqX4to=;
        b=i+Y8XiE8Ua3y8iPsok8LhsfwWwjvrWe76QXsuXu5IA/Iz2cw864mgn1+KZs/Xt0DIS
         C1Jw2Sk2uX1AF+3uKtXB/buOiv/R+Ot314ErTM2X8tYbcHZMNCDWPi23MBH+/9g2KzoQ
         1OLUT6fXm0EVCD20BxxHLuL5lQxouAwZekBc48JpWEaRknDe2+3xVGFEoEUtnuutauUd
         d9BxS3ADGnt9Rp6nh4M0VWBBm7vyxo/up5Q0JahDYcZZDZHEEN0fVWQEfbazIGxPMboY
         1zwjVKyc0/javmKKhQJbjqqGM55wCDtMyDXmlwOM9r3bgM9lmn6DwvJzRmGHdvWMFBm/
         DR/A==
X-Forwarded-Encrypted: i=1; AKwUvBzXYoOAhkFA6JyVNjVpB9OeHUQg+4KiOIbj2gmyTXa+i509c89TWIw0SkoJny4RE2kg/PlihUgCXIjRyvA=@vger.kernel.org
X-Gm-Message-State: AFuF++ma+vJnAViZUrEUcEFtbfz+1/7G8jXQqiRSJu+e+JrACvlxjM0O
	UMqd59oUlRNXzf2bFKCgCDuJBKmoz89KqdIlI+3+pb6vICdPgQA6u7MhBNjDy70KsbLg6BlrErD
	7gxcpAA==
X-Received: from pjbmv13.prod.google.com ([2002:a17:90b:198d:b0:39d:8dae:7e6d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c89:b0:398:e46e:ade3
 with SMTP id 98e67ed59e1d1-39d9c39625dmr7169956a91.23.1789132962606; Fri, 11
 Sep 2026 06:22:42 -0700 (PDT)
Date: Fri, 11 Sep 2026 06:22:41 -0700
In-Reply-To: <20260911074530.3140830-13-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260911074530.3140830-1-jgross@suse.com> <20260911074530.3140830-13-jgross@suse.com>
Message-ID: <aqQAodJCAEZyeQ1k@google.com>
Subject: Re: [PATCH v3 12/13] treewide: convert rdmsrq() from a macro to an
 inline function
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-edac@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-crypto@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-mtd@lists.infradead.org, platform-driver-x86@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Pu Wen <puwen@hygon.cn>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Len Brown <lenb@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	David Airlie <airlied@redhat.com>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Huang Rui <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Perry Yuan <perry.yuan@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>, Artem Bityutskiy <dedekind1@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Ashok Raj <ashok.raj.linux@gmail.com>, 
	Hans de Goede <hansg@kernel.org>, 
	"Ilpo =?utf-8?B?SsOkcnZpbmVu?=" <ilpo.jarvinen@linux.intel.com>, 
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>, Xi Pardee <xi.pardee@linux.intel.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Helge Deller <deller@gmx.de>, xen-devel@lists.xenproject.org, 
	linux-geode@lists.infradead.org, Michael Kelley <mhklinux@outlook.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 11, 2026, Juergen Gross wrote:
> Today rdmsrq() is a macro using its second parameter as the target for
> storing the read MSR value.
> 
> Convert rdmsrq() to an inline function returning the MSR value.
> 
> The users have been converted using the following semantic patch:
> 
>   // Options: --include-headers
> 
>   virtual patch
>   virtual report
> 
>   @@
>   expression msr, val;
>   @@
>   (
>   - rdmsrq(msr,val)
>   + val = rdmsrq(msr)
>   )
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>      # ATA
> Reviewed-by: Michael Kelley <mhklinux@outlook.com> # Hyper-V
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
