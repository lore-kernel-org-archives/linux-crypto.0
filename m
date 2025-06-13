Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BE1185B67;
	Fri, 13 Jun 2025 04:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749789016; cv=none; b=D2Iz1woVclPqpniZ4HYJ4RgKhEl1Tn3iiAoHeXTXKZYKOB13N7N08HLCS1e1P6IchbwdGEV8uuYvULYHzalkCgHLZkzukE+7IgCKbJ4/8TYlAmYs4YBdRxcfzaHiWf+5d2OxkEIZSthi3myZO8tG1Ck2XsN4tnUCzuHjWVHzfsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749789016; c=relaxed/simple;
	bh=d5ZqmH7EnCTPReTkPCbhxk6znOI1UWNinQBQ6ueWwpo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SDI8Aj7hgzf2vnKByyOW9iIfpLphvt4kX8c0yx1pcburLKK9pJJa0aZjBCpFAKmWqhTyHIjzm/JFMcA6/Uq++dHAFrfDosKv8SXq3cjVJuxlCQjunEdffvR+fE4AeMw7ja1GiaIgpNe8i0FpwH5ZJIaFzJoBwTQNJ/AnyupVFkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hRKZmpZ8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hRKZmpZ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WZoTICyG5/0Z36XH78eIgWM5k3YaoH3hfF9DMKWyLzA=; b=hRKZmpZ8iA4qBADegz0ym9O7vp
	IC6ahRxBEwIpBR0B/WCVTmmbNAhU2JbWe4dGtjRrIcZYhXNs6kFyqmvHfPBz+ikb9OHpNJKgLsKZh
	yM/QwMowiOoVbE3n/1P+xWQV9RTpighzx6AZcuIhZ2GYqEoWlijiaXjDnA+07z4vJeyCKxJmIEEXz
	ZGI0ItRVMWbI7xt+fP0q4OFzsK0QSXloWPNmP0RcK/2GqCd0CjCdna6UIHojM/FH3xU1QSunwpy/s
	ZhDZZdRQ6czStjQa+R6ySYugWBDBs9sLPjfdhBt9x5mNBCT3yhdPpGXkzfxOOHWIx2sELAx+/s/au
	Rcl7Qn/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPw3H-00Cpf6-2Y;
	Fri, 13 Jun 2025 12:30:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 12:30:03 +0800
Date: Fri, 13 Jun 2025 12:30:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aEupSzhTI4h8kz-5@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p4

for you to fetch changes up to 40a98e702b528c631094f2e524d309faf33dc774:

  crypto: hkdf - move to late_initcall (2025-06-11 10:59:45 +0800)

----------------------------------------------------------------
This push fixes a broken self-test in hkdf (new regression).
----------------------------------------------------------------

Eric Biggers (1):
      crypto: hkdf - move to late_initcall

 crypto/hkdf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
