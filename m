Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C68517583;
	Sun,  1 Jun 2025 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748804523; cv=none; b=IdxrktBekBsZdNqfBD0y8xjT5R0ieIji1LXoKO/Ep/qxeEt4Wj8rdOkqw+fHBVL0cD34FINoIfrK/hRCEc+2RL6+KvqIjE/racwgdROKRsQyWlnQecLQ+YWVF43tJH/hWHBURbDIob4VDQkOdfu6dzGSkqjfqGSa2rrDQjoZkc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748804523; c=relaxed/simple;
	bh=sWxU1QlXVVhFQA48Wl9f3uDE8KMVp5j9ljALXqPEPwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URJZVeAGU7tUr11+JFwJumUU/Yz2CHkRSLEq+Yyov3sGacBZ6vyQrkSjtpkJDDimEBtgNSQ7MpvVL05L8LGNzgAu+NQKjxOlefGv+XtMclM1PCpdbpk4mQHkX0B6H6BciEY+kATMMk6zbclGupprr9RFiwTw2+909/kw9OyP3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6rqvhEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6rqvhEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F846C4CEE7;
	Sun,  1 Jun 2025 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748804522;
	bh=sWxU1QlXVVhFQA48Wl9f3uDE8KMVp5j9ljALXqPEPwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X6rqvhEb84xqVSP9YClGm3bDf3fHFaA0eQjkDFsMRrxIhSaWAb+YwXxTFgcm+63K6
	 qXSf57a5PT3QdibZe8zrAnQx9xf8X70tjFniLile4nc1MRUZSdxwDINTuDMM4fdVIW
	 p3kBlm34WARxRa5Miu6yz5jW0n0WWttdpQGgjfElSnpugT6nyvrLEokeFVW2bWEe+R
	 1/bmgYi7tk3pWF0l6zM4qud2xXUTLSygK/r9w2ws+Bdkb07U5f48njn4JjYScTxz+8
	 1lVDe3LVikSDAkUi15hz94Rq2fIDXLO8HFGr3ci938971Ag2AtjylUaCZ8FcWx8jpw
	 BIa8xZ0yzZjdQ==
Date: Sun, 1 Jun 2025 12:01:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Fabien Dessenne <fabien.dessenne@foss.st.com>,
	Lionel Debieve <lionel.debieve@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] crypto: stm32 - remove crc32 and crc32c support
Message-ID: <20250601190144.GA1228@sol>
References: <20250531200047.16872-1-ebiggers@kernel.org>
 <CAMj1kXF87LNGXYkikjTHXnPinTXHc5KSZst=LDdDmMWXu4y3Wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF87LNGXYkikjTHXnPinTXHc5KSZst=LDdDmMWXu4y3Wg@mail.gmail.com>

On Sun, Jun 01, 2025 at 11:00:31AM +0200, Ard Biesheuvel wrote:
> (cc Arnd)
> 
> Hi Eric,
> 
> On Sat, 31 May 2025 at 22:02, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Remove the crc32 and crc32c support from the stm32 driver, since there's
> > very little chance that it still has any relevance:
> >
> > - Now that nearly all users of crc32 and crc32c in the kernel use the
> >   library functions instead of the crypto interface, and this driver
> >   only supports the crypto interface, there are very few cases in which
> >   this driver could plausibly still be used.
> >
> > - While the commit that added this driver quoted up to a 900% speedup
> >   over crc32c-generic, this was likely a best-case scenario with long
> >   lengths.  Short lengths are commonly used, and this driver has a lot
> >   of fixed overhead.  It likely performs poorly on short lengths.
> >
> > - At the time that microbenchmark was done, there were multiple generic
> >   implementations of CRC32C, and it's unclear which was used.  It could
> >   have been the bit-at-a-time one, which is really slow.
> >
> > - While the microbenchmark appears to have been done on an ARM Cortex-M7
> >   CPU that doesn't support CRC or PMULL instructions, it's now 8 years
> >   later and more CPUs have those instructions.
> >
> 
> This IP appears to be used on two different SOCs:
> - one based on Cortex-M7, which is based on the ARM M (embedded)
> profile, whose ISA does not include CRC instructions, and does not
> have SIMD at all
> - one based on Cortex-A7, which does not implement CRC instructions
> 
> What other SOCs based on other architecture revisions may or may not
> implement today is kind of irrelevant here: the question is whether we
> need to keep supporting h/w accelerated CRC on these particular
> platforms.
> 
> I'd say M7 is dead as a doornail, so we can disregard that one, along
> with the speedup claim. The question is whether this IP is useful on
> A7 to anyone still running recent kernels on them.

Sure, IPs get reused and can show up in newer SoCs though.  My observation was
just meant to emphasize that that's unlikely here.

> As you say, there are very few users left, as they have all moved to
> the library API. Combined with the fact that this is a unusual,
> synchronous, MMIO based engine that needs to rely on spinlocks to
> protect its critical sections, and fall back to the software
> implementation if, e.g., crc32() is called from softirq context while
> an operation is in progress in task context, I tend to agree that we'd
> be better off just removing it.
> 
> (note that even with two available CRC engines that could
> theoretically serve task context and softirq context in parallel, the
> existing logic managing the linked list appears flawed and may result
> in the driver grabbing the CRC engine that is locked and falling back
> to software while an unlocked one might be available)
> 
> > - Originally this driver was completely broken: it calculated the wrong
> >   CRC values, it wasn't thread-safe, it slept in atomic sections, and it
> >   used the wrong context format.  Use with ext4 or f2fs immediately
> >   crashed the kernel with a BUG_ON.  That strongly suggests that the
> >   submission was based purely on the microbenchmark and not a real use
> >   case.  Furthermore, the fixes for these issues added significant
> >   additional overhead to the driver, such as a spinlock.  That calls
> >   into question the possible performance benefit.
> >
> 
> I wouldn't qualify an [uncontended] spinlock as 'significant
> additional overhead', tbh.

It's significant on short lengths, which are common.  ext4 metadata_csum passes
a lot of 4-byte lengths to crc32c(), for example.  Fiddling with a spin lock,
linked list, runtime pm, and hardware registers to process 4 bytes is an awful
lot of work for something that could have just been a few table lookups.

> > - The driver may still be broken.  For example, its update function can
> >   fail.  Many users are not prepared to handle errors.  Unlike the
> >   software CRC code there are also different code paths for serial vs.
> >   parallel usage, which are unlikely to be tested.  The software CRC
> >   code is much less error-prone and much better tested.
> >
> 
> The only failure mode appears to be that the devices may have been
> removed while the shash tfm is still in use. In this case, the driver
> should just use the existing software fallback rather than give up.

Right, that specific bug might be harmless, but it's still an example of an
issue that is not possible with software CRC code.

> > Support for this hardware could be added to arch/arm/lib/crc32.c in the
> > unlikely event that it would actually be useful.  But this would need to
> > come with evidence that it's actually worthwhile, along with QEMU
> > support so that the driver can be tested.
> >
> 
> I think it is fine to remove this driver solely on the basis that the
> crc32(c) shashes are no longer used (I could only find crc32c being
> used in btrfs, but that doesn't seem like a use case worth caring
> about on this hardware), and we can drop most of the motivation in the
> commit log, and summarize it along the lines of 'driver needs work but
> what's the point?'
> 
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Sure, but an alternate approach would be to wire up this driver to
arch/arm/lib/crc32.c.  I just wanted to elaborate on why this driver seems
pretty useless, possibly even harmful, and is better off just removed for now.

- Eric
