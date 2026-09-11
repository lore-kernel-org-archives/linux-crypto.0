Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CE39768F;
	Fri, 11 Sep 2026 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789119489; cv=none; b=Ga0b24vCLW0SAwgWQddX5y3wxwP9TGyeCbIjYYTVSM7T6orBfVE1XawxkcW85MkOGMRDX+sRaCbuux1s3Wij5zz8NQOTMitdYosOOPoy4YFfkh6Ty71EW0AzaHQYteWI8o3El+wiBMpTTdfMWM3UyL0hM49kVohQtGtURokA9n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789119489; c=relaxed/simple;
	bh=sb6ClNqSQhPq2ZVhuU+8klKUwkLjODKU96QOOaqi6Cw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hAUe8WxEDOonDVIo3OzRL4HImhO1d9ZMNENjjmVvPvvBOWhgL/4+yoLeJvbuXs1Gi4mQniwFw2zCFZEKJvztZAIZGanE87Hpi/xZ+hPZHD83ANL9tfk6TIRhOrFsxBv3coqpUogi0VCHfz1Yt8OODoWE1335oAWZFtCRiXYIWHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DM9yb6wk; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DM9yb6wk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789119488; x=1820655488;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=sb6ClNqSQhPq2ZVhuU+8klKUwkLjODKU96QOOaqi6Cw=;
  b=DM9yb6wkIw6H/4OUaxjgfsWqnlyifFSzuJm4auThBBtBwc0mV354yWRx
   XtVaPKQt14wWQTHxwmAuXrNtLuI74H7+XGOopmobWMGCbssTFCTgK70GN
   xPc/0fvgWUsW06yKDHuGJmgGIjUvm1V7dS7+MPTBjbLpMhgWAOSeQFKK8
   CXvQwBVdRUh7PB3vVnm8I4Hbb6wYWM1MRgDUtsgLsesnWkjK2NOk6/5wg
   tMkfigA95OrdDDeQGjA0+DXpjVm+sYk7WNYD5sMczGNu5j/1W9HF8+vvK
   A11b1psKdcGb9tZV65ASr1A+m9roMLitbGJqHxiKH0mDnGtQeJfczTkfU
   w==;
X-CSE-ConnectionGUID: lv8LjnQ/RM2Ip6FtGVq2QA==
X-CSE-MsgGUID: o8V6DDF0TnKqW/TDijK+BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="115120614"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="115120614"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:38:07 -0700
X-CSE-ConnectionGUID: SRo+o97pTgCUDHnSfx1bsQ==
X-CSE-MsgGUID: d5IlSxrWQfGb/hpk+vV9Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="296857533"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.158])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:37:41 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 11 Sep 2026 12:37:38 +0300 (EEST)
To: Juergen Gross <jgross@suse.com>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, 
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
    Dave Hansen <dave.hansen@linux.intel.com>, 
    "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
    Arnaldo Carvalho de Melo <acme@kernel.org>, 
    Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
    Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
    Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
    Adrian Hunter <adrian.hunter@intel.com>, 
    James Clark <james.clark@linaro.org>, 
    "K. Y. Srinivasan" <kys@microsoft.com>, 
    Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
    Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
    Sean Christopherson <seanjc@google.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
    Alexey Makhalov <alexey.makhalov@broadcom.com>, 
    Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, 
    Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Pu Wen <puwen@hygon.cn>, 
    Tony Luck <tony.luck@intel.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>, 
    Vitaly Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
    Bjorn Helgaas <bhelgaas@google.com>, 
    "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, 
    Kiryl Shutsemau <kas@kernel.org>, 
    Rick Edgecombe <rick.p.edgecombe@intel.com>, 
    Boris Ostrovsky <boris.ostrovsky@oracle.com>, Len Brown <lenb@kernel.org>, 
    Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
    David Airlie <airlied@redhat.com>, Olivia Mackall <olivia@selenic.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Viresh Kumar <viresh.kumar@linaro.org>, Huang Rui <ray.huang@amd.com>, 
    Mario Limonciello <mario.limonciello@amd.com>, 
    Perry Yuan <perry.yuan@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
    Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, 
    Yazen Ghannam <yazen.ghannam@amd.com>, Linus Walleij <linusw@kernel.org>, 
    Bartosz Golaszewski <brgl@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
    Artem Bityutskiy <artem.bityutskiy@linux.intel.com>, 
    Artem Bityutskiy <dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    Miquel Raynal <miquel.raynal@bootlin.com>, 
    Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
    Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>, 
    Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>, 
    Xi Pardee <xi.pardee@linux.intel.com>, 
    Daniel Lezcano <daniel.lezcano@kernel.org>, 
    Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
    Helge Deller <deller@gmx.de>, xen-devel@lists.xenproject.org, 
    linux-geode@lists.infradead.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [PATCH v3 12/13] treewide: convert rdmsrq() from a macro to an
 inline function
In-Reply-To: <20260911074530.3140830-13-jgross@suse.com>
Message-ID: <b2baa471-0f6b-84e8-bda1-ae0964b72b04@linux.intel.com>
References: <20260911074530.3140830-1-jgross@suse.com> <20260911074530.3140830-13-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1162080221-1789119116=:1171"
Content-ID: <b9134b99-a885-4c62-2abd-7195415a52e3@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1162080221-1789119116=:1171
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <085b47bf-864b-9802-2915-a51186e45c40@linux.intel.com>

On Fri, 11 Sep 2026, Juergen Gross wrote:

> Today rdmsrq() is a macro using its second parameter as the target for
> storing the read MSR value.
>=20
> Convert rdmsrq() to an inline function returning the MSR value.
>=20
> The users have been converted using the following semantic patch:
>=20
>   // Options: --include-headers
>=20
>   virtual patch
>   virtual report
>=20
>   @@
>   expression msr, val;
>   @@
>   (
>   - rdmsrq(msr,val)
>   + val =3D rdmsrq(msr)
>   )
>=20
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>      # ATA

Acked-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>=09=09# pdx86

What is the plan for merging this?

> Reviewed-by: Michael Kelley <mhklinux@outlook.com> # Hyper-V

--=20
 i.
--8323328-1162080221-1789119116=:1171--
