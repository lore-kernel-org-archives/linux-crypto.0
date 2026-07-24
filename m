Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D38B175A93;
	Fri, 24 Jul 2026 02:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784858881; cv=none; b=cpbnQo5Ze8Mfko5Jx1zJBBhIixR2uvKvInYUWUBiPuaqItRR7KueZ+3D4yX3MTf62Du3/OMnTMf3zItogMYIocF7ds89+qoiwK+sIYLiEcT/FSYKz0tPbj4Cv8SoOvsH21VliHb39oS/gGaiHwu8AImgs5KBq89lAcLnro00k6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784858881; c=relaxed/simple;
	bh=dUhsDLAFYAeMwMx4wlNvoKLroE4q+nOngdVRAM7lO3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFXujFSI7ktH6+0SLvVaZWVODZjDzGHR1PkygMegpKa+uOsfNoxtkxB0EJmXCntNieg5tnW5Zob/jzZqrSKrVPyU+zZIu7PebAR8qHo+Niu7qECdnp4UpIKeSIR5fUsYovfmniqqw0s7eXAfEwwZvWe6Np8bvfo7CTBmotxHevc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHsqjK46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHsqjK46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5544B1F000E9;
	Fri, 24 Jul 2026 02:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784858879;
	bh=ZMGoKaVGT/WLPvCUKFso57b/S1XOxk0a0r7fmr8dVTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aHsqjK466GviO+4M28gRYI4WYgJxsCNCumllgwy29OJfBV8rWpwribREA5zqpnpCD
	 znlz95zxNhPtzmomcgD/S5bD00fiCeY11ELwJqXZmAcIf995BGNtIIQsFY6Ml4x7dM
	 +i67kc9tHHH/CAVuiAwsVNgkNDCk0I7DXjc5h3sV4CmRNQfLPjp0afYb7nbtW5hUOB
	 MX5mwLCaK71IW3iUP6thSA2cMYMNcogHo0ZfGM56T7aBWgNfiCl91GjunRA0UPCrGM
	 1wd7jyvplc1gP79pYM8/W8QVrApDZx3sJMtUO8T4jXSWr0v0eL2MeNkGK22D1u4t1z
	 bzhQOmd6o87+Q==
Date: Thu, 23 Jul 2026 19:06:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260724020608.GA51735@sol>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au>
 <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
 <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>

On Wed, Jul 22, 2026 at 01:33:51AM -0700, Bartosz Golaszewski wrote:
> We can offload crypto operations to the QCE saving CPU cycles

Here are benchmark results for SHA-256 on the SM8650 HDK, hashing 50000
4096-byte messages (matching dm-verity's and fsverity's workloads), with
all your pending patches applied:

sha256-lib (i.e. ARMv8 CE):

    Wall-clock elapsed time: 0.10s
    CPU time used: 0.10s
    CPU time spent in hardirq context: 0.00s
    CPU time spent in softirq context: 0.00s

sha256-qce:

    Wall-clock elapsed time: 10.76s
    CPU time used: 5.14s
    CPU time spent in hardirq context: 0.77s
    CPU time spent in softirq context: 2.31s

So sha256-qce is over 100 times slower and uses over 50 times more CPU
than ARMv8 CE, over half of that in hardirq or softirq context.

This was even worse than what I got last time I tried this!  So I tried
rolling back your BAM locking patches:

    Wall-clock elapsed time: 4.85s
    CPU time used: 2.78s
    CPU time spent in hardirq context: 0.55s
    CPU time spent in softirq context: 0.94s

That's more in line with what I measured last time I tried this, but
still atrocious.  It's still far more CPU time used than just doing the
hashing on the CPU, and much of it spent in hardirq and softirq
contexts.  The BAM locking just makes it even worse.

With that, plus the security claims not panning out either when
considering the actual code and usage in Linux, and also all the bugs
(both historical and current unfixed ones), I don't think there's any
credibility left.  This legacy driver should just be deleted.

To be clear: completely separate from QCE, Qualcomm SoCs have good
support for crypto acceleration in ICE and the ARMv8 CE.  That's great!
And that is, of course, what is *actually* being used in Linux.  That's
what we'll support.  Let's stop wasting time on a dead-end approach.

I understand there may be a desire to keep this driver around so that
support for restricted media content can be added to it.  However, that
would be new functionality that has nothing to do with what the driver
currently does and doesn't use the kernel's crypto API.  There's no need
to keep the driver around for this.  Just put together a clean proposal
to add a new version of the driver with just the needed functionality
(note that drivers/crypto/ probably won't be the right place for it).

- Eric
