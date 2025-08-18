Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A983731A063;
	Mon, 18 Aug 2025 12:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755520249; cv=none; b=NSIc6dTB3NGFU9cqs3KZnA6/+UwZEEtAX+uecwi4EcJxek4VCSe4GlK6wiIQUxDJmTM8EiTC9QJjb8nEf7fcq96IvNmYDkgNLQxhT7vCv8gXuG1borlZtqs1DZLobc1719MVAZppQCfE4hfazQq5eILFLQpA1lTBAt39e4Uo5q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755520249; c=relaxed/simple;
	bh=he/ljGrtl93Ludn/QUGKRnusEDCM9jmrsquCb1fyWww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nL0httdLaBOJvvkYtYpyouleQv268CR8lrChTEqr8wOMJg//5EvEccwydZmfZfrg+e00wV7Dnmye+TYKrIVCrbxw41SqrWV88glWOiMoc28JV2+umJgOSjblBDZZ9D6+QqJZLZGkbfQ+6HdQck8OP9+IOkHUYFEnJGK0hQ6mrs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=irRzVi5n; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="irRzVi5n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HoV2JW1l/9JIS8upGKcdO9HzBqFT431DsZjG7S4TAb0=; b=irRzVi5nu1LDRtpsSMbXHC1Aqx
	bPxDy/W9QshUan54BgDxGLNzsKTCHnhZpXtdc7rbHgdnR9P7SAzEiuDyFN8NJcOWGiPQ8Fbs/H7Se
	MUCRDKtVx3DA9bYVALWSFYUIeq/Nvp1bLRYlz0RLBwfnV0z+5YmZwuSLReK/nI8oWYeQcRgjpncYQ
	7zjHctUZM8x2350RiqxgasUChRfrOpBurGaMllfm3bt8IwrqFkIPRX4q5apCCeuqD0DY2QhXex/eG
	M5l8YWfZd39rYmeDTqiLmGyQsk6ubVi11/wk4XGMhSJFRD7zUhn9q0EtoxJMKVP9yvQLHwZYgpVy+
	eSsWrf7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unykz-00FDEr-08;
	Mon, 18 Aug 2025 20:30:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 18 Aug 2025 20:30:29 +0800
Date: Mon, 18 Aug 2025 20:30:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] crypto: Mark intermediary memory as clean
Message-ID: <aKMc5amKH9CLbKL8@gondor.apana.org.au>
References: <aKG_yEuG6F4cqFjf@gondor.apana.org.au>
 <tencent_50604BE61B0A2525BA07BB9033239E401B08@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_50604BE61B0A2525BA07BB9033239E401B08@qq.com>

On Mon, Aug 18, 2025 at 08:17:17PM +0800, Edward Adam Davis wrote:
>
> Their values are equal, so why use sizeof to calculate?
> Similarly, "if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {",
> why not just use SHA3_256_DIGEST_SIZE?

Please be consistent with the existing code, every other place
in the function uses sizeof(intermediary) so your patch is the
odd one out.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
