Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EC3239E7D;
	Fri, 17 Apr 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776447733; cv=none; b=CW80dozWuliTTI1hNIfu5hq2yYmgiK4muarPR5sC9Znr3Zd6+ST1B0UhCXYR1ICN1CHPKCtqz4bxGhXVhKKArlUGHiwo1mx0VXE63JImYlByOQqTR3pRKzCReL3CSIMrER7y3m7NTqvLSer+3BF5uMGwdmbP8L/+oXsLMVrLXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776447733; c=relaxed/simple;
	bh=C/PEZD3fW8Z9QLLtFyuySoodXudScC97LdjE3jvGC90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVLtIpsOP7HQixM2xY/mcIkV4QbkVdb5K3FiVGg3W2qzMq9J1CnPpZ3qeApdqSTWEZuvH8thoT3c1iksIApZckBwRvGlKvCSXOV0m8Uq/ZScfjdPxqiMGxqImKx8KIFjhuNuYfUKfBvaB0qIilvYlELEmVbmuHwRYNrgAjr/O50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=kqp6HbX8; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kqp6HbX8"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id B551120B7128; Fri, 17 Apr 2026 10:42:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B551120B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1776447732;
	bh=wc3r1qGYePa1HSg0tIR7M/rjUWPQEGZdbGUyWIvYyck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kqp6HbX82MGPYm5sQBOX0TlOiyX88uXPl/LGHQSknVV9qi7u3dU2v75z8YbLy9BQJ
	 cSU32fpvvwT3zbTEUsiyjiwfNYcLqxLpCCMlqMKV1wg2aL4AW1JP7rEKohCFEeZSqi
	 +Aa7mxZyXLJmvMtdAE0hs1CohpomSxxN1wl5Np4E=
Date: Fri, 17 Apr 2026 10:42:12 -0700
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Paul Monson <paul.monson@capgemini.com>
Subject: Re: [PATCH] crypto: tstmgr - guard xxhash tests
Message-ID: <aeJw9I38heQRbbe6@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260407192859.270745-1-hamzamahfooz@linux.microsoft.com>
 <adYNClYB6RY820Xl@gondor.apana.org.au>
 <adffSYxKIuaDLZit@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aeCmk6LbLFT4Keo2@gondor.apana.org.au>
 <aeCnNsNrK5o2JcMu@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeCnNsNrK5o2JcMu@gondor.apana.org.au>

On Thu, Apr 16, 2026 at 05:09:10PM +0800, Herbert Xu wrote:
> On second thought, fips_allowed should not mean that an algorithm
> must be present.
> 
> So we should change it such that an -ENOENT is not fatal, or at least
> when it's called from tcrypt.
> 

It appears that commit 6318fbe26e67 ("crypto: testmgr - Hide ENOENT
errors better"), already does exactly that and it appears to resolve the
issue that I'm seeing. So, is there any reason it can't be backported to
stable?
