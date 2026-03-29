Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C4C76026;
	Sun, 29 Mar 2026 22:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774822704; cv=none; b=XQp1AO8hae0+RqJBPlNDRn2D3qdkJh41D2cJFV4RDmbndbdclmwhEI2wEjnvvHVaOSCbpEr947VF5ROwEBueAxPci/0j61CghKUBkVYm0Df3isNYCP5aUB5S3+p4QB+BokaDfYq+bEc3oUfx9tsJseFzTdpdblq2HZkbADg7vIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774822704; c=relaxed/simple;
	bh=t8bKj8rddtYM3Jbs12wLmW5gizkNWgk7J2FrmPL7YAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxLp1jKYALvbGfZ/HF2YiavP9ACFlXMas4dQjtKcKtMi9jZ+oEOcCQ04dAbeXjsJq7qlYfU/UBDeqeLl8elXgb0Oq8AAgpHVXmU9bhu77HPjjbemuAE3jSDUy2u3dBWhLW0SIDgSIA4y8tudWriZqsXe/ki2kb/MJ+TiPsS8kJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMZKB+pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMZKB+pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E03CC116C6;
	Sun, 29 Mar 2026 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774822703;
	bh=t8bKj8rddtYM3Jbs12wLmW5gizkNWgk7J2FrmPL7YAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMZKB+pvpu5fxqqVroKT+MU6KLyohNGrpVaztPDLXbFpKCvOM5Zm2dEQt82yPTdh+
	 OlkrFCmrtpYCSiTF8jdczbInElDu9ZG45m8RcDpSRAQKBi9rHSZmiGyvN7j+DQ3rqg
	 whMuSjL3LNvLQAti8FELLvrAcXMeA04u6n6ZF2n6r6C1XLe9FJtBTBKcCVRu3QbL83
	 l9Gq0y9BpmnjDQbNo3NHgoHbbv7qyJOprVkbV+sasK5QzQX6PfHcFYQaTkkNYXQzlX
	 iH/hYTkTz9IcJqP5pl4eNlYD+gaWb2NY9DPIrrqbFF+/kwKVgFI3EYKqH1NdFy59yQ
	 wwbjOr19Vshkw==
Date: Sun, 29 Mar 2026 15:18:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ardb@kernel.org
Subject: Re: [PATCH v3] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260329221821.GC2106@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
 <20260329074338.1053550-1-demyansh@gmail.com>
 <20260329203829.GA2746@quark>
 <20260329225704.0eb82966@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329225704.0eb82966@pumpkin>

On Sun, Mar 29, 2026 at 10:57:04PM +0100, David Laight wrote:
> Final thought:
> Is that allowing for the cost of kernel_fpu_begin()? - which I think only
> affects the first call.
> And the cost of the data-cache misses for the lookup table reads? - again
> worse for the first call.

I assume you mean kernel_neon_begin().  This is an arm64 patch.  (I
encourage you to actually read the code.  You seem to send a lot of
speculation-heavy comments without actually reading the code.)

Currently, the benchmark in crc_kunit just measures the throughput in a
loop (as has been discussed before).  So no, it doesn't currently
capture the overhead of pulling code and data into cache.  For NEON
register use it captures only the amortized overhead.

Note that using PMULL saves having to pull the table into memory, while
using the table is a bit less code and saves having to use kernel-mode
NEON.  So both have their advantages and disadvantages.

This patch does fall back to the table for the last 'len & ~15' bytes,
which means the table may be needed anyway.  That is not the optimal way
to do it, and it's something to address later when this is replaced with
something similar to x86's crc-pclmul-template.S.

- Eric
