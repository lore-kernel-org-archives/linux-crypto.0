Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF22BEFF8
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750089548; cv=none; b=I4BZb4fBLRQ3cpZgIErWkUtwx0l4Wtyjc3UkzT7HL8zMdnc2Gsi6gTvG+9oj+UJmYwkigPb+57Pf1ZfxC1e/uL7IS3Kq1ffseRbNqqwcDuELCmv6v01UOpkBOzKbSD6qZqGkTphclR8BnlN0GojYxyUwpmrLOtN1u3undg2Vfmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750089548; c=relaxed/simple;
	bh=eFsjX3ZIA1rn1hoRePJadZ2Mt6XKKPbES52zEQ3tC5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzLkBURfjX5C7LCUJiHYZx/2O8qim513CVF3yhBFKROqvaQJJyJCaBUylwZZMizUXKrOZ5bfpvbKMd8SQXC3RD2LtV0aq1OSNpDPchboMduzW4svqg8FtDwAhNKht6xAhDkUlnsh+V3rBhLd+XREcxm6nDGFDiQFK/DgEUt5xH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgsznav6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgsznav6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F31AC4CEEA;
	Mon, 16 Jun 2025 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750089547;
	bh=eFsjX3ZIA1rn1hoRePJadZ2Mt6XKKPbES52zEQ3tC5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sgsznav6N9fl9cSVGHwARL7y/NLbZHjgDQPTMHQ7VqiTUKvRV6HeO8jJKrdv/9UL2
	 VGlImJtaxsu3DPLnEoNmriAcfoCDSmH6a5T3roeyXZQ86KNjVAgarHCrNhuo91m2GA
	 dLxhWi6kl0v31QoU09xmKGqAlSBVG535/2QMg/bpf2Z5RK4aqWxMoOaXdr7ar9U2RG
	 ZILf+7if+EIbBh7No5u4Og41bNbtRE1wumgk41UHUDqT7sgkD8BRVO+Tyk/YwXzVFs
	 N7iwuhLjvgy5rB8c924XGu4n3KFpuKJbI9hAUCwApjsPuJZSgLb+2/JqimQYHAI9ai
	 87cfsVzlY6okA==
Date: Mon, 16 Jun 2025 08:58:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, dengler@linux.ibm.com
Subject: Re: CI: Another strange crypto message in syslog
Message-ID: <20250616155837.GA1373@sol>
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
 <20250605142641.GA1248@sol>
 <66d4c382f0fbe4ca5486ccfa1f0a4699@linux.ibm.com>
 <20250606174508.GA53397@google.com>
 <319c7c1d4af5c1014d4a88ade39207ea@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <319c7c1d4af5c1014d4a88ade39207ea@linux.ibm.com>

On Mon, Jun 16, 2025 at 12:50:07PM +0200, Harald Freudenberger wrote:
> On 2025-06-06 19:45, Eric Biggers wrote:
> > On Fri, Jun 06, 2025 at 09:19:18AM +0200, Harald Freudenberger wrote:
> > > > The crypto self-tests remain disabled by default; there's just no longer
> > > > a
> > > > difference between the "regular tests" and the "full tests".  The
> > > > warning makes
> > > > sense to me.  There should be an indication that the tests are running
> > > > since
> > > > they take a long time and should not be enabled in production kernels.
> > > >
> > > > If this is s390, arch/s390/configs/defconfig has
> > > > CONFIG_CRYPTO_SELFTESTS=y.  Is
> > > > that really what you want?  I tried to remove it as part of
> > > > https://lore.kernel.org/linux-crypto/20250419161543.139344-4-ebiggers@kernel.org/,
> > > > but someone complained about that patch so I ended up dropping it.  But
> > > > maybe
> > > > you still want to remove it from arch/s390/configs/defconfig.  There's
> > > > already
> > > > arch/s390/configs/debug_defconfig that has it enabled too, and maybe you
> > > > only
> > > > want tests enabled in the "debug" one?
> > > >
> > > > - Eric
> > > 
> > > Looks like we have no other options than disabling the selftests in
> > > defconfig.
> > > We have debug_defconfig - with all the now huge set of test running
> > > in CI.
> > > But for my feeling it was making total sense to have a subset of the
> > > tests
> > > run with registration of each crypto algorithm even in production
> > > kernels.
> > > However, as wrote ... there is no choice anymore.
> > 
> > There's still a command-line option cryptomgr.noslowtests=1.
> > 
> > If you really want it, we could add back a kconfig option to control
> > whether the
> > self-tests run the "fast" tests only or not.  I thought that the only
> > use case
> > for running the "fast" tests only was for people who are misusing these
> > tests
> > for FIPS pre-operational self-testing.  (Which has always been a poor
> > match, as
> > FIPS requires only a single test of any length per algorithm, for only a
> > subset
> > of algorithms.  It's totally different from actually doing proper
> > testing.)
> > Those people should be okay with the command-line option.
> > 
> > I do think the idea of running the tests in production kernels is
> > questionable.
> > There are enough tests now that you can't run all of them (and indeed
> > you are
> > not asking for that), which means the production testing will be
> > incomplete, and
> > the real testing needs to be done in the development phase with a build
> > that has
> > the tests enabled anyway.  The same applies to other kernel subsystems
> > too.
> > 
> > - Eric
> 
> In general I agree to this. Clearly it makes no sense to run all
> the tests all time when a new algorithm is registered.
> The thing is ... everybody wants to test as close as possible to the
> production systems. So the kernels are usually build for production - now
> without
> any selftests. But all the Linux distributors happily patch whatever they
> think
> is necessary and build production kernels - now without any in-kernel crypto
> selftests. The only places where selftests are now executed is in 'special'
> environments like CIs or on development systems and hopefully findings there
> are handled seriously by the maintainers and developers.
> 
> Harald Freudenberger

FYI: due to all the buggy hardware drivers and distros wanting to enable the
crypto self-tests in production, we did decide to restore the ability to run
only the "fast" crypto self-tests.  See:
https://lore.kernel.org/r/20250612174709.26990-1-ebiggers@kernel.org/

The full tests will once again not be enabled in any of the defconfigs.  You may
want to enable CRYPTO_SELFTESTS_FULL in arch/s390/configs/debug_defconfig.

- Eric
