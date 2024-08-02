Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828A17547;
	Fri,  2 Aug 2024 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604089; cv=none; b=EsNIJ3Yp0V5HsY5cqocYrcrVpu7WmilsCWSAkimenLPdFGhcO6VCcMy73rKme+UYuzKNX1uXpoKXAWTaxq3kNBzb9DJjX4WcwP2pasFeaiB5M2YoaRG8VaLY7rBFCzF4XTkB5t5tGlFxFm7aL5LryH+9mamtGeGXx0l2G0Xn7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604089; c=relaxed/simple;
	bh=p9pbDg4t4Cdpx//swVD12yoiZqbHPH+0aZ/mcEstjnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5abyCDUz3CcZ+wr3yJkd41kDLSxgVaQ8GX4ee3WFdBAejbfGxG/oqjkhrfO104hXyRcNe8ZNPT18tym1YaloyhswxLxCR5dBzpmumHVP9J5P5DlWqse4PiK6SWZdIRIOsHgTxesnjGvC5SC7gP2xkceVwN2PZ6UfmTBpk7VPjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sZrsK-001zvx-12;
	Fri, 02 Aug 2024 21:08:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Aug 2024 21:08:01 +0800
Date: Fri, 2 Aug 2024 21:08:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Helge Deller <deller@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2] crypto: xor - fix template benchmarking
Message-ID: <ZqzaMQDswTxVVVIX@gondor.apana.org.au>
References: <ZovalOTfarFv1SZa@p100>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZovalOTfarFv1SZa@p100>

On Mon, Jul 08, 2024 at 02:24:52PM +0200, Helge Deller wrote:
> Commit c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> switched from using jiffies to ktime-based performance benchmarking.
> 
> This works nicely on machines which have a fine-grained ktime()
> clocksource as e.g. x86 machines with TSC.
> But other machines, e.g. my 4-way HP PARISC server, don't have such
> fine-grained clocksources, which is why it seems that 800 xor loops
> take zero seconds, which then shows up in the logs as:
> 
>  xor: measuring software checksum speed
>     8regs           : -1018167296 MB/sec
>     8regs_prefetch  : -1018167296 MB/sec
>     32regs          : -1018167296 MB/sec
>     32regs_prefetch : -1018167296 MB/sec
> 
> Fix this with some small modifications to the existing code to improve
> the algorithm to always produce correct results without introducing
> major delays for architectures with a fine-grained ktime()
> clocksource:
> a) Delay start of the timing until ktime() just advanced. On machines
> with a fast ktime() this should be just one additional ktime() call.
> b) Count the number of loops. Run at minimum 800 loops and finish
> earliest when the ktime() counter has progressed.
> 
> With that the throughput can now be calculated more accurately under all
> conditions.
> 
> Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> Signed-off-by: Helge Deller <deller@gmx.de>
> Tested-by: John David Anglin <dave.anglin@bell.net>
> 
> v2:
> - clean up coding style (noticed & suggested by Herbert Xu)
> - rephrased & fixed typo in commit message

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
