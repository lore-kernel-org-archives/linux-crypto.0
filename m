Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70238F252;
	Fri, 27 Mar 2026 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774640338; cv=none; b=Pc/0V2MJcYp86VAZNih49b2QFsKOOhm7WKyntHWjWhNH59yB9sTmutPuv9CNOXOOqM9JHKQCNEj6CZLp5/Otknxu6XBm1dAe+HeZRGNg76JpfGPqYOBp79uDeTltLLLQARkE1Pif568eZD6U6XJfMQFQT6L7xHX74oIPIhB3S5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774640338; c=relaxed/simple;
	bh=6m+QQM3HH64vBWB9ttrYHPv7p/YraE7ev05IU3DXyzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPYRZsiOs2ZzFCmaNw0+i94LRgsgUNtnW5AbWEgHh6OBblq0KI+CHcsmGVmLAuhSqcaf75/AzEhmCarnD2bA3+q9spw9OnvSU4VsHIsDrwcLTVx9YNhKReUKzz4n8O/nlgyS3JTB7kLg09n3EbIftqFtXtmppnYXpElc/V5jOU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7chMGXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7chMGXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457F3C2BC86;
	Fri, 27 Mar 2026 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774640337;
	bh=6m+QQM3HH64vBWB9ttrYHPv7p/YraE7ev05IU3DXyzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d7chMGXe+3e7WS1rbF6pR+y/vGBrhxSxU3qNZw1UwKPw8/QT6vy8P4a51xnltG0b4
	 npraO7vFyKbiRssc/Cd2H1zqfgTF9twKPad2qQJewDwAFgeAaZBZeAxem7LtY4XANw
	 nwIRSi6DQb8HN5aB6yKQS77Q9OEQSg7kcwRQkNaWPsf7FnVMzBmQ/l6wp0RGOk6cLN
	 d3zzOp3hRVi+7WVhbYJoBosBKfd88Rc7SiKPs3wDA5C7q1tfO4MWgadLpMmokyx/Ba
	 wv5w7lGgsVi7Q7nWoFjGPdPgm2hZDSrYrnN90eufSib7wlIE0BSTXbq5NmO8XjB+2s
	 QG7/JKEyK93nA==
Date: Fri, 27 Mar 2026 12:38:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260327193855.GA25969@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
 <20260327060211.902077-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327060211.902077-1-demyansh@gmail.com>

[+Cc linux-arm-kernel@lists.infradead.org]

Thanks!  This is almost ready.  Just a few more comments:

On Fri, Mar 27, 2026 at 06:02:11AM +0000, Demian Shulhan wrote:
> - Safely falls back to the generic implementation on Big-Endian systems.

Drop the above bullet point.  This patch doesn't explicitly exclude big
endian.  Which is correct: Linux arm64 is little-endian-only now.

> +	/*
> +	 * Reduce the 128-bit value to 64 bits.
> +	 * By multiplying the high 64 bits by x^127 mod G (fold_consts_val[1])
> +	 * and XORing the result with the low 64 bits.
> +	 */

That is not what this code does.  How about something like:

	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */

Granted, that doesn't do a good job explaining it either.  However, a
full explanation of this stuff, like the one in the comments in
lib/crc/x86/crc-pclmul-template.S, would be much longer.

I suggest we leave the full explanation for when a similar template is
written for arm64.  For now brief comments or even no comments are fine.

Just if any comments are included they really ought to be correct, as
otherwise they are worse than no comments.

> +			scoped_ksimd() crc = crc64_nvme_arm64_c(crc, p, chunk);

clang-format doesn't know about scoped_ksimd(), so I suggest overriding
the formatting in this particular case:

	scoped_ksimd()
		crc = crc64_nvme_arm64_c(crc, p, chunk);

- Eric
