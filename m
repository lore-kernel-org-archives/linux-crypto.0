Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111A40DFCE;
	Sun, 22 Mar 2026 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774191584; cv=none; b=UKDDvofGlGNWDU1fGDlDEcGqP28WB0VwZ/YybwgpON2BBl1Szwh2MP/Hu8TJPpwGyy0cjTsJAKmlojSECBTxfd7309ab3wyY26apoNriQSx+1yhufglH+jsgMAcf4mlzQfEhK0Q1u4xjG2cLSw4pquSWUVUruXlrMxQNUWeBI2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774191584; c=relaxed/simple;
	bh=oltgeAFkxFhiXhV1pHRk95/2v1mkP9N7BoapbN3xjSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQHflBbEl/N7imfh5Y1s+nGKDXo8PrLXqLjpx43NJgWwMSn7KmAIiHlCQhQvEy4UlVNs2OAhodVb7nHO8415TuWlGigLEWAvMCthK39aiJyCAOKzrW2wWOb1pJBaK8MKcfkj55BSvLzU5KovXD0ACeAk/3LO0tacD3p4idUomGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikPoubLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikPoubLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65E2C19424;
	Sun, 22 Mar 2026 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774191584;
	bh=oltgeAFkxFhiXhV1pHRk95/2v1mkP9N7BoapbN3xjSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ikPoubLcyotaJ+uw6tDK6SVNWe04bq19yfLWvaN2xLRHSvl+pcT4oJ2/qqJ+on8i/
	 jk8JiHOlQkS6sqlMgE1WvR6Tuaakh4CpZCjiYMSP1E3bg1yCPnC8dKBE1PqdZrPgx4
	 c6CoX5uGov2KCYgE0+0W2CkzYJcCqWrVmqqInBGqQOLGLrPeMLBsPnywspgdkCWwiC
	 CqRdc6bhS/LqkVUyVlhEfSjmAC41sD/c8Nj7uc/e+RUHjmZ4jBCPxqU7SqaZi2TnW6
	 7TAUv9tiEo8nK1ebsACLD+vhs2e9Y6e1FumYXtBXojifM9dvbVg8IC6xlOig2+sHX1
	 VSr6UuYIvCOWg==
Date: Sun, 22 Mar 2026 07:59:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Theodore Tso <tytso@mit.edu>, Nathaniel Roach <nroach44@nroach44.id.au>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
Message-ID: <20260322145942.GC2183@quark>
References: <20260316204211.GA2661@quark>
 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
 <20260317034539.GA2705965@google.com>
 <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
 <20260317140646.GC53921@macsyma-wired.lan>
 <079d287944ffe94903286ea73fc1df167206321a.camel@physik.fu-berlin.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <079d287944ffe94903286ea73fc1df167206321a.camel@physik.fu-berlin.de>

On Tue, Mar 17, 2026 at 03:14:50PM +0100, John Paul Adrian Glaubitz wrote:
> Hi Ted,
> 
> On Tue, 2026-03-17 at 10:06 -0400, Theodore Tso wrote:
> > How hard would it be to add support for the Sparc crypto accleration
> > opcodes to QEMU?  Is that something that could be, say, an GSOC or
> > Outreachy project?
> 
> Good idea. I'll ask someone who has been mentoring QEMU enhancements in the past.
> 
> Adrian

FYI, I filed https://github.com/sparclinux/issues/issues/77

- Eric
