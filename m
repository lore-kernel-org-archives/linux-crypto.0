Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A222BCF7F;
	Sat, 22 Nov 2025 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763839155; cv=none; b=R2zIK+niBSfUaSBDGVynwE3ZRBdujx34r2F8r4peM88CWgVPEEDLqQxL/MAw9xXdRCwVXvcBF8CddDFjgErSY4pJlpOhQiaZHDizVFbOsEFdDgb4pmPNuxG/hyXHE3lwc2v+u2G6AQawQ5ye/Fhc103/7k1xuZxPSzkMzjYPWOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763839155; c=relaxed/simple;
	bh=fjHiEoCG9KfheXknOEAgf9DFo409Ea4T6wFEwywOLQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E78ls8zouJa6MNphavrkOKQBA+ED849JDuaK2wh0zA9iPL+NJGbrIwnSszgv2PodcyTzJJWrH0MVPUTerrGON0IQ6DbRMT7qmQUiyix3PItCMuyK/BmFBe9c5LOzw5kXTIu94GE28di/heomwekEozB5yy0ACYBdCyAD0hVojVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZrFjJTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZrFjJTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6E9C4CEF5;
	Sat, 22 Nov 2025 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763839154;
	bh=fjHiEoCG9KfheXknOEAgf9DFo409Ea4T6wFEwywOLQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZrFjJTA6dMt8EukYuJPsRoiUvmaRZt2n7+CdGg8H1K/gfhQ5nXrqV+vCAZcMwBP4
	 DUH4UdQr/OL4VCqLTNR0cQChn9+Tyw39szowbf0bbWRYZZbeDo+ruSCtkNR3t1HzWu
	 9PGku4FwLdQmn53r4b2eEvXidHDu8YONJ/RdSc8cQrEcpcpQvwCw/OQsL0Ty0WWNnU
	 s5Edkye0W7SCDDCmjMa+oqjF/m84IPBtHqMSvTLXlUmaacCAnDjb5+/da7Gew3VqY2
	 M8nl1FocBW3g4GMGw/3HjV+3rYQMrfuCGmhJzK9TRWVC4a36VqBTFxFMHoXxY3CLpf
	 sfW4+zUIIx0rw==
Date: Sat, 22 Nov 2025 11:19:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <20251122191912.GA5803@quark>
References: <20251120011022.1558674-1-Jason@zx2c4.com>
 <20251120011022.1558674-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120011022.1558674-2-Jason@zx2c4.com>

On Thu, Nov 20, 2025 at 02:10:21AM +0100, Jason A. Donenfeld wrote:
> Clang and recent gcc support warning if they are able to prove that the
> user is passing to a function an array that is too short in size. For
> example:

(Replying to this patch since there is no cover letter.  In the future,
please include a cover letter when sending a multi-patch series.)

I've applied this series to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

In case it gets bikeshedded further, I merged it in on a separate
branch, and I'll plan to send it in its own pull request.

Thanks!

- Eric
