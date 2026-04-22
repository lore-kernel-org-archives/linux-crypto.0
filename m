Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9865936C0CF;
	Wed, 22 Apr 2026 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776842034; cv=none; b=HyDQlk0WjIz0+z/FCz0s9JuMr6canKzbUdeS87aOMx5MJ319KuJljkaRtfB+hyVBO88Pf9ABoY1ovCazv0Maw3eW12D/VRji5NWnZOue1qk+bN8C8+zzaL8aWhlIKDMRgntIUT46GdEBIoa3WT5KNy5fUCLNroOOYsTbFZLHyQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776842034; c=relaxed/simple;
	bh=2fkao8ArefIYQIbLZPL2ShMrSXc6ICRKryHIhWNINls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdhWVpVPN0gXqa9ewLvfF/x25ExStj45vcQQfoOFxPNhhNWPTOp2yli0RYZdzAj9y7ncvUtvnwwOeQ50VnkBc2hY+GLKRh+kUe3sDOBiCThFIi9BRrzksvtqXKHN7ib/VYOl20Ks1IzIojyA8+KpmplUdUPOlQ8e5bWq+wNebBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FeKXi2s+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FeKXi2s+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776842033; x=1808378033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2fkao8ArefIYQIbLZPL2ShMrSXc6ICRKryHIhWNINls=;
  b=FeKXi2s+sMp35Nb945P/0iuyMIxmDiVq7x1rKFZ/iFxNegKQkya1pFIq
   IACXZ3h2X4ildyuawqueaFXZ52HvH1u4KfYXXjlQM9EdzC1zKzPfXMd21
   26kWtub62VnbzFuYIQ8XobxtcKct8O6tRV/xgJhrvKoQNkoDIqgVWCSCW
   U3LX/xUHkFS0cOTttr0lVANloLbTjrLA6CdkLdHMrSmBnTclbru73Yz6h
   69yyJ4WgOassZz70JJYx1VutuLwRYC7LF+Tfb2BgAVXa1sbjgu5ltq0GX
   /8k0lTpjrFRmIoyMqNBBVxnUUuMAc9IL8K1NV70H1MdswliC6P0CIVl37
   w==;
X-CSE-ConnectionGUID: /WjouxYHSf2swGr6VJGHjQ==
X-CSE-MsgGUID: xCP1YMg5QCiUfpgHLpBXfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="77491887"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="77491887"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:13:51 -0700
X-CSE-ConnectionGUID: 8bjn/CoeRfmR+ZxM9NIV9g==
X-CSE-MsgGUID: b/tjYM8wT72QHDuE4PxnmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="227681986"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.201])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:13:32 -0700
Date: Wed, 22 Apr 2026 10:13:31 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Link Mauve <linkmauve@linkmauve.fr>, linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Geoff Levand <geoff@infradead.org>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Anatolij Gustschin <agust@denx.de>,
	Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Huth <thuth@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	David Hildenbrand <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Will Deacon <will@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Paul Moore <paul@paul-moore.com>, Nam Cao <namcao@linutronix.de>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jiri Bohac <jbohac@suse.cz>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kees Cook <kees@kernel.org>, Stephen Rothwell <sfr@cab.auug.org.au>,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Li Chen <chenl311@chinatelecom.cn>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Petr Mladek <pmladek@suse.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Sayali Patil <sayalip@linux.ibm.com>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
	Chen Ni <nichen@iscas.ac.cn>, Haren Myneni <haren@linux.ibm.com>,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Thierry Reding <treding@nvidia.com>, Yury Norov <ynorov@nvidia.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org
Subject: Re: [PATCH 1/2] powerpc: Add a typos.toml file
Message-ID: <aeh1GzpdvGjRdMdd@ashevche-desk.local>
References: <20260421121420.26079-1-linkmauve@linkmauve.fr>
 <20260421121420.26079-2-linkmauve@linkmauve.fr>
 <215f12d6-62c1-4837-9f78-ef270684950c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <215f12d6-62c1-4837-9f78-ef270684950c@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Apr 21, 2026 at 02:26:35PM +0200, Krzysztof Kozlowski wrote:
> On 21/04/2026 14:14, Link Mauve wrote:
> > This file is used by the typos tool[1] to determine which words to fix,
> > which ones not to fix, and what the target word should be.

It's a little too many people in Cc list...

> > [1] https://github.com/crate-ci/typos

You may do it as Link tag in a form of

Link: $URL [1]

> > Signed-off-by: Link Mauve <linkmauve@linkmauve.fr>
> 
> This typos.toml file does not belong to the kernel, IMO, but that's up
> to PowerPC folks.

In kernel we use codespell. If we want to have another tool to welcome, we
need to setup infrastructure in parallel, so it will be `make` option with
the fixed name and choose the tool based on availability, et cetera.

> My note here is: please use your real, full name. See submitting patches.

+1.

-- 
With Best Regards,
Andy Shevchenko


