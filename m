Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD85332EBC;
	Thu, 21 May 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375930; cv=none; b=Z9D4kz69UUsMLnNW/Fbl9yGdk0Y5xBi6M54sQ4Jtvlp3c95ms/mS3nEbhddU7FnZy+vr07cKrc5WhtfCUhBwPQN/bTcKLW5vjk6qno2jy/ts1AsOjG9sgr4J7mVUIBbneK7/8P9m+5+y1ufSP3/hZH4SSyHiEzxt5dyhnicuX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375930; c=relaxed/simple;
	bh=JpzC9mGIVNbcFYXnjsVIN9cPsK+rC/pW7L1FrOBdwyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLvADBGh5JWB0bMi1/qYLAvlP63EMX1oQUrGubMpMR0LAwoK6nq2n/mEvEUsPnhGewOcVH1n61O+6gAgKxCKUek98lDh2HGN3Dzv62dNDnMpUbQK5yuIMB3vUuX288wCeJsboFq4QREizsFWGL2st1n0yUplRRaY1SvHIIZkjLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWmEyEbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWmEyEbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127681F000E9;
	Thu, 21 May 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779375929;
	bh=dIFIWB3iaF/A92woUWsM1iNG1AQgGfZaMTy05b2SWH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SWmEyEbsmXaxglB9jmcCCy/0my3VHawriJEkg8kmOpF2TAtYoboAaePQRqbi5MDMh
	 6LIjoPUWS0RGQo/wVafqw2MbS2AmWyJ1AB8TqfY/gfjpbhYM5o7KSOX2f6JJ1XNfyc
	 k6/dlL3V9/tLmBJK4OLfNw7Vla8V0Pb/XmrGiW6o2NyFayOHQKktJCd3zja9Ji0Xy8
	 I7l/jR7VotqaOb0Rrw4YSWDLoM7YaYQ9U5wzKvKpJ1CcbvyVHFWl8aANTJg/ehLAay
	 ibMic6BYjW+HdcSxEqis1OTzOdoKMG/8cMHlA29/ETBUVGcW8lWcoyTyRq6wMhPrC0
	 BC1UQSBqFYDwg==
Date: Thu, 21 May 2026 09:05:26 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, 
	michael.roth@amd.com
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <ag8c3v3GjWLWz-OS@tycho.pizza>
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
 <6d5fd5eb-e54c-47fd-943a-6d03aaafe243@amd.com>
 <4ccf6dc7-88e6-488c-8314-5bcd95164661@amd.com>
 <b02682e5-8890-454a-ab75-fff1b6566922@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b02682e5-8890-454a-ab75-fff1b6566922@amd.com>

On Thu, May 21, 2026 at 08:12:52AM -0500, Tom Lendacky wrote:
> > Now, with unregister no longer protected by sev_cmd_mutex, a concurrent init
> > can race with shutdown on the sysfs lifetime like so:
> 
> Can it? Can init and shutdown race? Isn't that part of module load /
> unload, I'm not sure how they can race...

That's only true after
https://lore.kernel.org/all/20260504165147.1615643-5-tycho@kernel.org/
right? Before that, if the first init failed, you could trigger a
re-init via ioctl(), and presumably trigger the race sashiko is
complaining about by spamming ioctl() + sysfs writes on separate
threads.

> > t1                                 | t2
> > ---------------------------------- | ----------------------------------
> > sev_firmware_shutdown()            | sev_platform_init()
> >   unregister_verify_mitigation()   |   register_verify_mitigation()
> >     sysfs_remove_group()           |     sysfs_create_group()
> > 
> > Both sides touch sev->verify_mit without serialization. The same race also
> > exists for init vs init which is no longer covered by sev_cmd_mutex once
> > register moves outside it.
> 
> I don't think you can have init vs init race, can you? This just all seems
> odd to me. Have you created all these race scenarios to test this out?
> 
> Would putting the regsiter/unregister under the sev_cmd_mutex and then
> taking the sev_cmd_mutex upon entry to _show()/_store() fix all this?
> After obtaining the mutex in _show()/_store(), you check for
> sev->verify_mit and return an error if NULL. Then you can use the
> __sev_do_cmd_locked() to issue any commands.

As long as sysfs_remove_group() happens before
__sev_firmware_shutdown() it seems like it should be fine since sysfs
will do its own synchronization. IIUC we might not need this locking
at all assuming the above is applied?

Tycho
