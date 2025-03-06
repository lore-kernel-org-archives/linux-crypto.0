Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97BA28FF;
	Thu,  6 Mar 2025 11:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261331; cv=none; b=KBzPvcSNDywf2vZ9ul+I3awQRZLz6OoeZpww8tGIW4y7EwbfyhKB9pg8GS9UqUtJ9OVEVxI/AJYz1mffKbwFk1EnWL6mdaqPtXuwqvmKb0ZDXUtHu2rBwf+Tcd4W1nHz8AHuzKSlWHspMe1fPDQ1gFDBprFMaU9A+g9nmBnyDO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261331; c=relaxed/simple;
	bh=GmSE+Ebky2LN0ZVQLaVc7VPYpNG/+8m9YHUsLPoNTLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BDFbkLQB2mJpr9hXJBadpCOQpPaC419saIDKbGwbH9L4ZM/4sxkPt2TzX7IQ6LTs5vK9mRKyNcAaEn+owFQrUZd5oGDjvlxpShPRZ9hleZ/c5iAC9ZQeZ7LX2i7T88gVbDd3R77VMZRwokHFuN262sJcoB7FIB4SnfaMrxa+G1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxEch3lV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxEch3lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BBEC4CEE0;
	Thu,  6 Mar 2025 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741261331;
	bh=GmSE+Ebky2LN0ZVQLaVc7VPYpNG/+8m9YHUsLPoNTLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxEch3lV9N/gGWTmIrP+RsHXdHsyI7cdQZRIlFjO6CEE3pqQ+sO6luoeK9ZHX5DJz
	 aUb5o02IfvrOU1HLD8ioEqeylt1zo2/WWlRjCM4pAihAHTC4GAcrsNsXoiGcTmDuE0
	 HTnzrU9y8VwiyzSBaPCkczOoD7Z8QqY96uUZ1koGi6Lp5Iq2WldUo/nlq1ih3kb+Y3
	 P7nKS1nJXte+IuH5XQbqAnA9r8ivJSwGeVVioI9dBZOco/4eMQL7+jRBhGvVkqb2LB
	 +oXLNGwNzABjyKm+pbpiCex0UU88IXBIIBVviQAcazefbuCMjOul3ylDmd2cTHgUx/
	 0SBKadAy87Rgw==
Date: Thu, 6 Mar 2025 12:42:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <Z8mKDZOI5Q3XRtCp@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
 <20250305173925.GA4014401@google.com>
 <Z8iTSzfzrFLv-JBL@gmail.com>
 <20250305203018.GB19889@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305203018.GB19889@sol.localdomain>


* Eric Biggers <ebiggers@kernel.org> wrote:

> Deleting the ldmxcsr(MXCSR_DEFAULT) adds about 14 MB/s.

BTW., that's still a +3% performance improvement, so it is worth 
considering in addition to the current patch IMO.

Thanks,

	Ingo
