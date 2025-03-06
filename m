Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E5E201022;
	Thu,  6 Mar 2025 12:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263007; cv=none; b=NCm+wpEddlUZNXI1v69dNv7bggbAF8tQ9yK2WdIkYbf/4KcsxlYd2/t6G5ym15Z6f8YkKQglVMXC0s85fkBqSj1TYkjOLgdgx9zS8L/l82/pbeKZiEzswc5C+Ew1cSawlgyR3TCgJ7e764sTcZuX4xBdyT4yNW3TNyU89CW374E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263007; c=relaxed/simple;
	bh=4VrMJIjVFPsbDL3AXCsxRkmOwzuv5lOz64/j+1TMEco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUiRFyVaNdRB/Fa5i0mFt3V8Z7x/x79LStqjZYKbhVIJXVoGviPZ8ABGqKNXgEhdQfZQ9HqES4bqOd2ohElVsRxKzuw2G4MNpLaY0JgB+iu8oUlOye2XdXbuZwGhyVVSpnJeL42TU1dlpWfvV98ZzNPXeK641S24RCjkFQMRugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C/ZS0pye; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C/ZS0pye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JmS89W/xehVecg6LuB8zf80ZnuxBLneMU7jkajJH5Nk=; b=C/ZS0pyeW+kSZXL1yqW1XEpjHW
	XcCnpRcD/Bac7VesklBGS89gQoJaRAxLRjPe+TpsSJYn8z8oWWEEIo5rp3ndmFdjKleHMJSZCRfQw
	3o5PIGqFwLpptvJwpzl12nrQn5tONJmxjjHxnJrj4fUnVCfLQg2ggLgfz0wRu4vSCvRY9aaLtetIa
	Ywp7lbl0EjQSim7K0ow06uMH6Ag3KBsFvBrfwhpcKG2ihaDgr8bHp1hYOYD90sNfVCitswjxFlrbn
	FEX8imaHo8Kue6UKonywD95qO30gT7wO0Qfuv7NprVgcbcRS7njmUs1qv35f3Hq+MmJaORZwzDVXp
	pbIW66VQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tqA2u-000000094eH-2HZO;
	Thu, 06 Mar 2025 12:09:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 438FD30049D; Thu,  6 Mar 2025 13:09:47 +0100 (CET)
Date: Thu, 6 Mar 2025 13:09:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250306120947.GF16878@noisy.programming.kicks-ass.net>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8gUYamgBr4M5ZaB@gmail.com>

On Wed, Mar 05, 2025 at 10:07:45AM +0100, Ingo Molnar wrote:
> > From: Eric Biggers <ebiggers@google.com>

> > Alternatives considered:
> > 
> > - Make kernel-mode FPU sections fully preemptible.  This would require
> >   growing task_struct by another struct fpstate which is more than 2K.
> 
> So that's something that will probably happen once the kernel is built 
> using APX anyway?

ISTR looking into this at some point for RT. I also have vague memories
of other architectures doing something similar, but its all a long time
ago.

