Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653B25228D;
	Thu,  4 Jun 2026 05:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780551772; cv=none; b=FYY7Mtk0wBnp07D5LclJVi0hSXScnk6EYOKTqsX4dfPO2t/ZBHagBIt/AIt2vxV7ZbM6C5apS60qfPH8bl0lViJ5IoMYeJegzkSQv002IdBWpkszrIu3KfLS6cIb6Nm70CtbQE+71pngGhkpKmWvG0oTp4zpKiyfL5jKt8gOhx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780551772; c=relaxed/simple;
	bh=kllpQdJk7f30xvh3IYaPyj8ADd2Ln5TrG2yStupVJ9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFT7hjEwpN8FY6MrskxTCSjd3Fmhdoy5gl+T88wC25iiP4UVLzB8WpQ63OpChtMrEr+ogtBE4cPocbHO94Hidk87TQYojoMkFW5wEhebANamEX886zDicexJsrX++zhx+Ad1Z15TSTAV6A3TaiZHJttvtFarKMlBIUFEZzoGXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQpIAaOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQpIAaOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B9E1F00893;
	Thu,  4 Jun 2026 05:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551770;
	bh=q9tmiXPVsIPEQKPNVR5tyYF9BeAqrl1kj2A/uE9ti9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OQpIAaOL83BtmMFptyFRwIIFDmWLzhMF3sw9GuM3J1mNaZ8qfQm2t9to4sar6QyMN
	 gvASAtks0oVD1+I9JGSuLZnY76QUgfzOFzkKHXzi4S9ojSNJ8WJVMyvrNJsPn7YMK/
	 DCBVVnWthip4IslwNZp6hCUTxlPVNr6GiXP0fFcizRvA5KvFFE6JBXSZfcD47MkLaX
	 216v+ZEY9502vzVW+lmMaxoIIfxTBjsqEaoA3Jf+rIrbVlZXKEj9alGZ08liZGQOzI
	 9s32oW6Rog/ymE5c/3bBMi3OVRtJYTK2dvazsXMD5IwBdhepXkQVpK3WY9PzGELLiY
	 zeBsbIV+f6d5w==
Date: Thu, 4 Jun 2026 05:42:48 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Om Prakash Singh <quic_omprsing@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: qcom-rng - Remove crypto_rng interface
Message-ID: <20260604054248.GA3999742@google.com>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-4-ebiggers@kernel.org>
 <021127c9-baff-816d-e053-897a7d4043d8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021127c9-baff-816d-e053-897a7d4043d8@oss.qualcomm.com>

On Thu, Jun 04, 2026 at 10:20:38AM +0530, Neeraj Soni wrote:
> On 5/30/2026 7:33 AM, Eric Biggers wrote:
> > qcom-rng.c exposes the same hardware through two completely separate
> > interfaces, crypto_rng and hwrng.  However, the implementation of this
> > is buggy because it permits generation operations from these interfaces
> > to run concurrently with each other, accessing the same registers.  That
> > is, qcom_rng_generate() synchronizes with itself but not with
> > qcom_hwrng_read().  This results in potential repetition of output from
> > the RNG, output of non-random values, etc.
> > 
> > Fortunately, there's actually no point in hardware RNG drivers
> > implementing the crypto_rng interface.  It's not actually used by
> > anything besides the "rng" algorithm type of AF_ALG, which in turn is
> > not actually used in practice.  Other crypto_rng hardware drivers are
> 
> How it was established that there are no active users/clints for qcom-rng
> using crypto_rng interface? If there is no concrete way to do then this
> patch breaks backward compatibility.

The only in-kernel user of crypto_rng uses it to access
"drbg_nopr_hmac_sha512" on "FIPS-enabled" systems.  So, the only
possibility for a user of "qcom-rng" would be userspace via AF_ALG.  But
I've never heard of that being done.  It would be a really odd and
pointless thing to do when the much easier to use UAPIs /dev/random and
/dev/hwrng already exist.  And broken too, as I pointed out.

AF_ALG as a whole is rarely used and is a mistake.  It exposes a massive
amount of unused and broken functionality to userspace, including every
single implementation of every single crypto algorithm by name, which
never should have been done in the way it was.  We don't have much
choice but to continue removing algorithms/drivers from it to keep Linux
maintainable, as has already been happening successfully for many years.

The AF_ALG hardware RNG support is especially pointless, given the
redundancy with /dev/random and /dev/hwrng.  As far as I can tell the
main purpose of it is just to confuse RNG driver authors into thinking
that they are making Linux utilize their RNG.

Keep in mind that for AF_ALG there's also a compatibility trick
available to be implemented if it ever needs to: the kernel could
automatically remap requests for a particular driver name, like
"qcom-rng", to a different one like "drbg_nopr_hmac_sha512".

However, it's never actually been necessary to use that trick in *any*
of the times that crypto drivers have been removed or renamed.  No one
has ever cared.  There's some AF_ALG functionality we know that a few
programs use, but this isn't part of that.

So I think we can be quite confident in proceeding with this patch even
without proactively putting in the name remapping.

- Eric
