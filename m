Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B86630E0F2;
	Wed,  5 Aug 2026 19:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785959275; cv=none; b=H2sjWjoKmYG3Acz3Nt+qXnQZigUBjF+hJQc0Q/CTXgr0pJvqpRLgQ9RQAExdwk+r5JpI2AFO+ZBwmxRSV116PnNXlFUhzLZysXB5C2olv6bzQDIZfB/uKAND8Ajb8iz7m1BbGZepWN0K/YQiflYC/vqcz3lCmVB+Lr9k1usM0IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785959275; c=relaxed/simple;
	bh=2JSR5zzzeJzklOusJ4H6XOSnBzT/vyfYGFjiJdrKjMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ET9Z+1rjUx0SCDJPr7TRNBJKefF4i36FN3K8OaW0quhWdO66uVNbPBTi5uNk+vgTzu1NPpjl+lRglkJjhZr4QZHMJxtIY8EpBxC3fi1I1SD+tZx1A5MVwwnFsD06e83PJAG2IljtUpo5cbQXR/zVW/RAZVVMzLZgyFekLLVOWGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdZm8BeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdZm8BeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF65B1F00A3A;
	Wed,  5 Aug 2026 19:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785959274;
	bh=/5DFcjv17aClVPgDutzK8fCDnFDiOdggboozUKsXDgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TdZm8BeNg5217r8i6wk/fKxTNRBqqmSQBkNz8mnxh990PlIMhNnVTl+IexAx15bIe
	 t07+m5QFarIMy9G+XXvhFjWpGgtws9IPKF2J0CcYYDG3wZZBOwTWGM7KehqStJ71rw
	 RasG1gjgF3Es77ZFg9CR6hYjOg8q/nA7wv7r3q150FK7co/XP9JubLW/B7uuv95wTU
	 /ncZaPJKefiFZ/nj35O/AVALegZAbIPlcJWSQSpIkt60h752/qrkXlpAGJHqnYrvY8
	 I2znnfdjf46Y+n0NOrRd9mxOA7Elvy3BxYUt1YATvmk9NuSenCJzamjKJI17Orlh9f
	 KvKSk8eO+UcvQ==
Date: Wed, 5 Aug 2026 12:47:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] kunit: irq: Continue increasing hrtimer interval for
 longer
Message-ID: <20260805194752.GC3438@quark>
References: <20260803181842.44648-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803181842.44648-1-ebiggers@kernel.org>

On Mon, Aug 03, 2026 at 11:18:41AM -0700, Eric Biggers wrote:
> Currently, kunit_irq_test_timer_func() stops increasing the hrtimer
> interval as soon as some forward progress is made in each of softirq and
> task context.  Update it to use a more aggressive strategy: increase the
> interval as long as the hrtimer is running significantly faster than
> either context.
> 
> This resolves an occasional hang in the CRC and crypto library tests
> under qemu-system-s390x.  It was exposed by the change in the default
> preemption model on s390 from NONE to LAZY.  That seems to have exposed
> the issue by allowing some forward progress to be made while the actual
> system timer tick is still starved, preventing jiffies from increasing
> or the task context from making much progress towards max_iterations.
> 
> Fixes: 201ceb94aa1d ("kunit: irq: Ensure timer doesn't fire too frequently")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
