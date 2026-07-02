Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2144E021;
	Thu,  2 Jul 2026 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782986860; cv=none; b=daVpg8CL1XxXODi/4vMGftI8ify2qUM571jjSdXjsJj6ndLonLH2+iJpseZSMjdF85vnzqb7vznL+6UswhvKl0xALF/YSkedZHBWwbaiQrXg/Xch/BNEH6vp6XeY912XhLLSoa4RsSelp/1dQLZaJ07qnUXhFyCEJnNAFq6J26Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782986860; c=relaxed/simple;
	bh=/9b8XhRdxlUi0LGnAzYPhCpgKuVEuoSHdRJkABgQExM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=df6LXzJyfKFvKbWr7Ymf3QY1RMbco/cbQLybValhkhK/AxQx3BsiUtMHBtyER0khJAkC3Amm/9706r4+CKNxctCewBX7+TpXk9t+gCYwyreuflgMpnt8u70Hl6JY7/OqFn0s8dyIo7nKtp4U0FXn1+97RUNyOFAKN74kr7tTu10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUJ2SDXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUJ2SDXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4E71F000E9;
	Thu,  2 Jul 2026 10:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782986859;
	bh=rYlxsT3EfvvJVMSpiElkKSMRxs3TOqthCAywxBW0128=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AUJ2SDXvs0VEdi5h/Kivbi3brTHkQLZzOc+/NAV87+f7C+JbSJugMOeorpgT3tHNL
	 p58+v4CbXSREtEJG3hLwTa5n8p6G+p8Uf6kuVPNIUtEb3lILgd1rLCgiUeDjzt2+mZ
	 zGpUePOrV+YiczwnsZiA+nTEa+dq7dVC2Ri5VUVSthC4z19IRHYTorV302BUc8jnc8
	 lzbpbbTR/gUCNSPcKQ4CL0UIE7YEz9VRE1nLkcyV3m++qYsnaX7iOq8PztYSNv6FrO
	 w1VeEKbpH/fT7kvqY9QrCvgHPHHPFXTLBTuAr9eAkNY5WqMk3S9O4fQkBovR+Lq+yS
	 W5zmwAV0MlSzg==
Date: Thu, 2 Jul 2026 12:07:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Juergen Gross <jgross@suse.com>,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	x86@kernel.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
	linux-hyperv@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-mtd@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	"lukasz.luba@arm.com" <lukasz.luba@arm.com>,
	Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Pu Wen <puwen@hygon.cn>, Bjorn Helgaas <bhelgaas@google.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Dave Airlie <airlied@redhat.com>,
	Helge Deller <deller@gmx.de>, linux-geode@lists.infradead.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	David E Box <david.e.box@intel.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 00/32] x86/msr: Drop 32-bit MSR interfaces
Message-ID: <akY4U0jUZm4HOGZ_@gmail.com>
References: <20260629060526.3638272-1-jgross@suse.com>
 <d7c1db52-529a-43cc-ac7d-38b52627e8bc@app.fastmail.com>
 <c1608c48-13c2-4290-826b-28b5ca51eaf7@suse.com>
 <7332feff-2649-496c-8e49-b0a19eb54a32@app.fastmail.com>
 <akJUz0kYkEBdLSZ3@gmail.com>
 <akQR9YMtMHReJTfB@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akQR9YMtMHReJTfB@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> > Note that the individual patches are IMO significantly easier to review
> > through the actual 32-bit => 64-bit variable assignment changes done
> > in isolation (which sometimes include minor cleanups), while
> > the Coccinelle semantic patch:
> > 
> >    { a(b,c) => c = a(b) }
> > 
> > which changes both the function signature and the order of terms as
> > well, is just a single add-on treewide patch.
> 
> Is the plan for subsystem maintainers to pick up the relevant patches,
> and then do the treewide change one release cycle later?

I'll try to keep the patches in a single tree (tip:x86/msr)
in the hope of not prolonging the pain two cycles - but it's
of course fine for maintainers to pick up the patches too
(most of them are standalone), we'll sort it all out in the end.

Thanks,

	Ingo
