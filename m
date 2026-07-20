Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2918370AD4;
	Mon, 20 Jul 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564978; cv=none; b=ZmDfgTEqiXSarQO+nuAXL0NVPbVcV2ltzWWx72sGLp7OG+ddbCZn3Uvtwry7p/C7TVnilSEyBiMgShCDCaDGMNL9XgxQVuxwqgfb1sNVn32ds1IsqH6OFOIbAo4tt34uHD3+jWnqQW0FOkrIPOrgKGIHwxhjGlDonmBTHGpOHcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564978; c=relaxed/simple;
	bh=pxNAoS51cH90vhDg6HTeKKviWrJUrklbjvcDA5KvrWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGEGxfHqDxtbpCQ7RNQPEyo9cHHASsMBoZ13mEirntorz7U7Ed89v53bqNR0YBA6YPW5Ppu0uF1wKdrvH8aFsnO2NXUKFmxzroqSIQXBXbaj2ViqOwK5NiVAMWJBQNs/5W+1kAhyHK+Uo2hgr1luBBeT1cbqG1yWON5Q33QmlGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDi1OU1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDi1OU1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBC01F000E9;
	Mon, 20 Jul 2026 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784564976;
	bh=MbfK5XGj4SWIPCs6mqfV6stLD/ng7j+D3hoNmzAKzrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FDi1OU1g5Z/JSP1dBntxzzQdZBtqwiqYbfiXTO2AeVjEsT3zJuG4RFHQ4ysqIVOdC
	 Asb72J+nR9/5Pui9DMjTeNRM5FMXYIWrtzSVCZZNPJ0bOjrYLT4A+AOjm69U39tcu0
	 nPuw573KMLIayr+juCcpqSAzqlOQ3r9/jcX5gO1OognvcrLemS/rntbn8ulg4hpEU7
	 d8V1y5OYBc1nxBrtA63Be0fIDuZWj/Ge4G0HvYK4TV5f5J9xFs53qHHY2lI7rgkuUl
	 MG1hTgnIPIlCI0LGk0jd8ehzIy4Am4pyOamBRr5UUMagGpzgYbvthLXUfeEAnYazhR
	 uX1D7LM3+gLwA==
Date: Mon, 20 Jul 2026 16:29:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Turning on DOITM at last
Message-ID: <20260720162934.GA21086@google.com>
References: <5e739bc7-4252-4f64-90ab-c68fc5cc746c@gmail.com>
 <b2986cfd-6e2c-47c8-8a42-863582ebf1fa@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2986cfd-6e2c-47c8-8a42-863582ebf1fa@intel.com>

[+Cc linux-crypto@vger.kernel.org]

On Mon, Jul 20, 2026 at 04:55:19AM -0700, Dave Hansen wrote:
> On 7/18/26 10:01, Demi Marie Obenour wrote:
> > Is it time to go ahead and turn on DOITM?
> 
> No, I don't think so.
> 
> > - If it doesn't do anything, it's a harmless no-op.
> 
> I kinda disagree with this.
> 
> There are CPUs that enumerate support for DOITM but on which it doesn't
> do anything. On those CPUs, every cycle spent twiddling it is a waste.
> 
> > - If it does something, then that something needed to be done to
> >   protect code that handles secrets, such as crypto code.
> 
> I really disagree with this.
> 
> Lots of code "handles secrets".  memcpy() "handles secrets".
> 
> > - The overhead of switching it on and off is too high, so it's best
> >   to just leave it on all the time.
> 
> The overhead *is* too high. It's an MSR bit that requires a user/kernel
> round trip.
> 
> > - Even people who don't care about speculative execution
> >   vulnerabilities, because they only run trusted code on a particular
> >   server, still likely need secure cryptography.
> 
> I'm not sure where speculative execution vulnerabilities came in to play
> here.
> 
> > Xen already turned it on in the past.
> 
> While I very much respect the Xen folks and their security posture, Xen
> is a very different project than Linux.

The right thing to do for now is to just turn on DOITM at boot time
(https://lore.kernel.org/r/20230125012801.362496-1-ebiggers@kernel.org/)
to fix the backwards compatibility break.  With just one write per CPU
at boot time, the overhead of writing the MSR won't really matter.

For the insecure mode to be the default, there will need to be an
efficient way for userspace to enable the traditional secure mode, *and
then* several years for userspace to be updated.

Unfortunately, since the hardware enabled the insecure mode by default,
Linux inherited that backwards compatibility break without any explicit
patch submission, and the burden is being put on people wanting to
restore the traditional behavior.  It should be the other way around:
the traditional behavior needs to be the default for now, and then we
can discuss what needs to happen for it to be safe to enable the new
insecure mode by default.

- Eric
