Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA1F1B86C7;
	Mon, 23 Mar 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774290045; cv=none; b=oHfhgInYavSsXFls58bW3nH6Varyhy+75LfUQcOg5/0VuzDiHk7s1vMLIVGDrY5OjUjAEsnPnSTaKfr9vwqm94Xkkpf3s4molWgS+I/VCdT49V8pkz6ouprGVI/CUyoeoAQdAiVBpX9a4rmVZclVs51JygaDOJ/8E15qAhDRWRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774290045; c=relaxed/simple;
	bh=9vpkkBfXRkLZrtOLMsxA44Brq1gUhkeUk+l1ZYdlBlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGIiouNba2mqFp3kIrQoWju8G5yR2HBSmx32g2nnd/nqe6IMIofKH5wyxUHbatohxpuAJF3T5JSlBW+nIDT4GE1GoE0tMAwVJ2Zcr2kzIZA81jcCgG3CrOfkpO0LPUJoKi014Aa+2TDIDS3PhlkAgMunP3fMJNzw4myQef1Vjos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rmz/4IvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rmz/4IvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1972EC4CEF7;
	Mon, 23 Mar 2026 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774290044;
	bh=9vpkkBfXRkLZrtOLMsxA44Brq1gUhkeUk+l1ZYdlBlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rmz/4IvEYdHKDOlM+Phbfig880vMCGnk9Td0EE+6xaEYHFuSWbIB2N8q/S89OlyPh
	 y9Oj+n9qIf2rHm2RVNTPfDuFgSqgF8+9A9zsvR/wF6fN44nr2LdM3ZOCcv08Ikztb6
	 FoItttsING5a0NUSYgz57GxYgdIbm1S0tVfcoJMgrP32N/YTemMXky4obCCHzODVlt
	 j+2W5jfVu6t8b6Heh1WobGuUBl0kH7Q7gF2WO00anVa9rVS3rzMtHgsgImmSbQgsGL
	 dRgGBNFaqFrXVtlLIsVUEDbzzmlsEVtzzLRT5gS3bAe8R1Coe3DTnfjIihhVlTWWYM
	 +iBfMAYnX5ifw==
Date: Mon, 23 Mar 2026 11:20:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Nathaniel Roach <nroach44@nroach44.id.au>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
Message-ID: <20260323182042.GA2205@quark>
References: <20260316204211.GA2661@quark>
 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
 <20260317034539.GA2705965@google.com>
 <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
 <29665ec3-5052-4cdd-8eb9-e6c91092de79@nroach44.id.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29665ec3-5052-4cdd-8eb9-e6c91092de79@nroach44.id.au>

On Mon, Mar 23, 2026 at 06:36:52PM +0800, Nathaniel Roach wrote:
> On 17/3/26 15:16, John Paul Adrian Glaubitz wrote:
> > Hi Eric,
> > 
> > On Tue, 2026-03-17 at 03:45 +0000, Eric Biggers wrote:
> > > On Tue, Mar 17, 2026 at 10:48:52AM +0800, Nathaniel Roach wrote:
> > > > I've been testing some of the PCI changes that have come through on my T5-2.
> > > > I'll happily add some tests for the crypto functions, I've just got no idea
> > > > how to do so.
> > > Well, try enabling all KUnit tests in lib/crc/ and lib/crypto/, as well
> > > as CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.
> > > 
> > > However, will this be a regular testing run, or only a one-off run?  If
> > > it will only be one-off, we'll quickly be back to where we started.
> > > 
> > > We need regular testing on either hardware or QEMU.
> > If Nathaniel can test the code from time to time for the time being, we should
> > already get some coverage. In the near future, we could certainly set up a CI
> > job if you let me know what infrastructure to use for it.
> > 
> > Please keep in mind that a lot of us are doing this as volunteers and we don't
> > always have the possibilities to respond to such requests within a short time.
> > 
> > Feel free to use the sparclinux issue tracker if you want to file any requests:
> > 
> > https://github.com/sparclinux/issues/issues
> > 
> > Adrian
> I enabled the below options, based on what I could find, in my test config:
> 
> CONFIG_CRYPTO_SELFTESTS=y
> CONFIG_CRYPTO_SELFTESTS_FULL=y
> CONFIG_CRYPTO_ARIA,BLOWFISH,CAMELLIA,CAST5,CAST6,DES,FCRYPT,SERPENT,
>   SM4_GENERIC,TWOFISH,CTR=m
> CONFIG_CRC_KUNIT_TEST=m
> CONFIG_CRC_BENCHMARK=y
> CONFIG_CRYPTO_LIB_BENCHMARK=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_KUNIT=m

I recommend using the latest linux-next, to get the latest KUnit-related
kconfig updates, and using the following on top of sparc64_defconfig:

(
    cat lib/{crc,crypto}/.kunitconfig
    echo CONFIG_EXPERT=y
    echo CONFIG_CRYPTO=y
    echo CONFIG_CRYPTO_SELFTESTS=y
    echo CONFIG_CRYPTO_SELFTESTS_FULL=y
    echo CONFIG_CRYPTO_DES_SPARC64=y
    echo CONFIG_CRYPTO_AES_SPARC64=y
    echo CONFIG_CRYPTO_CAMELLIA_SPARC64=y
    echo CONFIG_CRYPTO_AES=y
    echo CONFIG_CRYPTO_DES=y
    echo CONFIG_CRYPTO_CAMELLIA=y
    echo CONFIG_CRYPTO_ECB=y
    echo CONFIG_CRYPTO_CBC=y
    echo CONFIG_CRYPTO_CTR=y
) >> .config

Note: most of the complexity here is to fully enable the traditional
crypto self-tests to cover arch/sparc/crypto/.  The plan is to finish
migrating those into lib/crypto/, in which case that code will become
covered by the lib/crypto/ tests and only the kunitconfigs would be
needed.  But for now, the traditional tests are still needed too.

- Eric
