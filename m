Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795347938;
	b=m3crKOkMRZDaCSG4SYDo5VxQNoSb0Nq+zGjFyeVLT2/Lt+oEdVt55o7TiIU3xtyEFQdt
	 QGAPKjBInMUf3i+CXCVFxFp65rwS2a6/Wu/U8dm8BgYbgu118uV7qpZ9HzDdEJ1g0NHcp
	 47X/NKXwAsR0JLppJX4meAgWKof6gplYxc1GBwKwh80GYpFZYKiznzFjZIgDxfADr9Khb
	 V4vd6fIbXUyPl1JeIsXr4t+RCI+EAw0bpwfo21yVdhw58DyODEIv8EDSGKMaBNr8SzUBo
	 yI5IB/UDdobgiit0Ghn2h3aeRC46349OswrhHqRkWnG57EIpw/VZLuHor99c19w2Rtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795347938;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cLMcqM1+ID1GgGq+PerrzsvqYkDe3KsyjwqtE/Ytfio=;
	b=KUnpO4+r9c5mZjgDZWSyQcnD9//TVtxyJvTg31aOdWKdo07+4BbgoUJhBS/5k0/Un+98
	 vEwR2AdnZvz6PdeAYUucvK6SoChEkN9MMq7ooFz6PqECuxZZ/IQMbPMKr3Gz3sbrLW9/l
	 o/2Tu+0GVYrl535iXuc3MXL9s+kplovnjA+VqYRZ4xK6EQ5OX4OD8LLkKt1yMO2Y6hNSt
	 8Iii0S7e81ncxSm1uyaiA2Wu8fGzxd9hmxEDNN0VTUAyCVbCntVMCPLefPYi3+wrcm++t
	 aB4DpaHVRiKpd5WK/zdJTL0OyWdAFVYdnD670my4JpDEbYSVaZxnHVAxbzcQR3XR1Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBZbk8ZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462E606A33F;
	Sun, 22 Nov 2026 11:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBZbk8ZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C711F000C0;
	Sun, 22 Nov 2026 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795347938;
	bh=cLMcqM1+ID1GgGq+PerrzsvqYkDe3KsyjwqtE/Ytfio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JBZbk8ZBopVc78PPFvWeVTIg2CMujdUlqemdavr/HCyWWlIQmFZkcrGxwSI3F8Lj7
	 DNLer9OUFPLbOa4J4Swvhd/E17PbHJNYpl75QSvfOs502Qnq+SIVf6x8BaBZgxP/BT
	 TLhC5kAcmMHclzMqgFcvdBPgsnO0el8R7pGYvxVYVMfFAdpjXa9S5pH5onsvDFitkW
	 F7xoQFwGUBjexAU1BbMzjGktImA7HZrErJM176ZMcRKXKM7Cl6WdGzAwr72CinZqC4
	 cUMiH2XukT43gci2XSUdvkVEDyb0hb22fl5gp/8fIaWZ7ym7dU5tWM0l+OzRL/g3Qu
	 BJv0P33zLAReA==
Date: Sun, 22 Nov 2026 12:45:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, linux-edac@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-mtd@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	David Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
	linux-geode@lists.infradead.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Pu Wen <puwen@hygon.cn>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ben Horgan <ben.horgan@arm.com>, Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <fustini@kernel.org>,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Len Brown <lenb@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	xen-devel@lists.xenproject.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: treewide: Re: [PATCH v6 00/12] msr: Drop 32-bit MSR interfaces
Message-ID: <awLVzKJWWfC3eJsH@gmail.com>
References: <20261116150208.1572254-1-jgross@suse.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116150208.1572254-1-jgross@suse.com>


* Juergen Gross <jgross@suse.com> wrote:

> For accessing the MSR registers on the local CPU, there are 2 types of
> interfaces: the "modern" 64-bit ones (rdmsrq() etc.) and the 32-bit
> ones (rdmsr() etc.) which are using the upper and lower 32-bit halves
> of the 64-bit wide MSR register values.

>  140 files changed, 572 insertions(+), 690 deletions(-)

So I've applied this to a separate branch/tree under tip:core/msr,
because I think this series is mature enough and after about a year
worth of (very patient) iterations by you we've reached the limit of
what will be picked up by maintainers.

The commit with the widest impact is automatically generated
via a semantic patch:

  treewide: Convert rdmsrq() from a macro to an inline function

  139 files changed, 493 insertions(+), 495 deletions(-)

and I'm reasonably certain that whatever merge impact this may have
on -next can be addressed quickly and in a simple fashion. Let's see
how this goes.

Thanks,

	Ingo
