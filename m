Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2D5BE4A;
	Fri,  4 Apr 2025 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743793766; cv=none; b=r8sqnYkd6iDX1xw2gyalVvdcTLsze1Y5BmdO77Lu9jLJk69VoM7ipmAjzrEx1JwtSLJKAZU3Sq2037UN9tQcA12glsPNClkgsAboev0+kJ3nBZ7uqcNYXl16b/IMtXD2eRHM8OQH/Eoj020l/sFQZlJIkjc/XsERL8j2zoYVcjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743793766; c=relaxed/simple;
	bh=032yjO8dSwAuQhzpJz59oORh4HEjWv5bo8lpsJmPAZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T78TJTHE6TpJppgErBA8XZDsTFscWDkJ19gyw6Gm7DVjXZTd2KL9dfFVnhi6O0UfR7/4/joFlM9pv12fz46j6aHmeQbyLhcNLR5ZCyqLETYkxnFZTHtkhvwJd95Hheqiy/MSLtjbCZzVPw+kkYrKA22yP+tigq1Ea9xAynUgUss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neMIbc0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neMIbc0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3E2C4CEDD;
	Fri,  4 Apr 2025 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743793765;
	bh=032yjO8dSwAuQhzpJz59oORh4HEjWv5bo8lpsJmPAZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=neMIbc0aiULHw5c32mnthK7FTy9wzCAFma7oIJg1grNl5U5ezrisPfTsG7cKLX6+p
	 UtIJn8/SL437DhtW41izeU6TvhWc/6MVzfByhbM7b+V8CoakCkoUITJlLMo4HjjpX7
	 kUgWe8ZWSezgDWoaxrEy4X0IVgZxyjpFKYMknyQsWj4a4kz2FT/soVsgSbHJ95EAlJ
	 +u2IoV821YblNCpcVtiUSN+TDegAP5U2lp51XhRLZVvmbDxEsGRgw15HoIGU0ph/wv
	 ewOaksxth4sUIL05aSR58bDiGNNnclyPWmiIYEeHr75q83Db10VeljxCrlb1nnOz/R
	 vJBwWtskYh2lA==
Date: Fri, 4 Apr 2025 12:09:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
Message-ID: <20250404190923.GB1622@sol.localdomain>
References: <20250403094527.349526-3-ubizjak@gmail.com>
 <202504040855.mr885Pz1-lkp@intel.com>
 <20250404015112.GA96368@sol.localdomain>
 <CAFULd4YrG-7DCXabke+uuLwLw2azciogG1nPGeAkMxLACw+0og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4YrG-7DCXabke+uuLwLw2azciogG1nPGeAkMxLACw+0og@mail.gmail.com>

On Fri, Apr 04, 2025 at 07:55:40AM +0200, Uros Bizjak wrote:
> On Fri, Apr 4, 2025 at 3:51 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Apr 04, 2025 at 09:13:40AM +0800, kernel test robot wrote:
> > > Hi Uros,
> > >
> > > kernel test robot noticed the following build warnings:
> > >
> > > [auto build test WARNING on herbert-cryptodev-2.6/master]
> > > [also build test WARNING on herbert-crypto-2.6/master tip/x86/core linus/master v6.14]
> > > [cannot apply to next-20250403]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use '--base' as documented in
> > > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > >
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/crypto-x86-Remove-CONFIG_AS_SHA256_NI/20250403-174814
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > > patch link:    https://lore.kernel.org/r/20250403094527.349526-3-ubizjak%40gmail.com
> > > patch subject: [PATCH 3/3] crypto: x86 - Remove CONFIG_AS_AVX512
> > > config: i386-buildonly-randconfig-001-20250404 (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/config)
> > > compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250404/202504040855.mr885Pz1-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202504040855.mr885Pz1-lkp@intel.com/
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > > >> lib/raid6/recov_avx512.c:382:2: warning: #warning "your version of binutils lacks AVX512 support" [-Wcpp]
> > >      382 | #warning "your version of binutils lacks AVX512 support"
> > >          |  ^~~~~~~
> > >
> > >
> > > vim +382 lib/raid6/recov_avx512.c
> > >
> > > 13c520b2993c9fa Gayatri Kammela 2016-08-12  380
> > > 13c520b2993c9fa Gayatri Kammela 2016-08-12  381  #else
> > > 13c520b2993c9fa Gayatri Kammela 2016-08-12 @382  #warning "your version of binutils lacks AVX512 support"
> >
> > Yeah, CONFIG_AS_AVX512 needs to be removed from lib/raid6/ too.  It looked like
> > that directory was rolling its own CONFIG_AS_AVX512 in lib/raid6/test/Makefile,
> > but that's a makefile for a test program and not the actual kernel makefile.
> 
> I think the best approach to avoid patch dependencies is not to remove
> the test for AS_AVX512 from Kconfig.assembler in this patch, but in a
> separate patch that will be eventually committed late in the merge
> cycle (or for the next version), after all other users are removed
> from the tree. I have patches for other parts ready.
> 
> I'll post v2 of this series with the above adjustment.
> 

$ ./scripts/get_maintainer.pl lib/raid6/avx512.c
linux-kernel@vger.kernel.org (open list)

Whee, more unmaintained code...

I think it would be okay to just update lib/raid6/ in the same patch.

But if you want to wait for the next cycle that's fine too.

- Eric
