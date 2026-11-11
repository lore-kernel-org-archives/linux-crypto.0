Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395304;
	b=eU3yb5xwCzBS2xMkBw6EXuSWprXa08o0OeFwcKac61zAwmw4sg41Nq/xe+yx3BGzsq8d
	 j3BvhbHf7gLoIUvhZKYJZdhGWQ8MacLkMHKmHpflyrZBYOf7YxJJkZTrAeNGTkItQjiMh
	 3mf4bM3/UN+CqpZ7CH53Kab/hatThOrgI/m1wofNyKcRp5CbcJ0X5Qf2vAyfHMUOq+neO
	 vbxrVNRMAX24+yduF6jFdBcTtBGTi6acEtVySssncuZSA3k9JG1+muODO1EmKyrIcoE2W
	 iB/uL5hKwKLvKkVBZxApW1S2dGCynT7W1zYLgb7hIphzclFy3kuy/XwHhkU98CMKaYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395304;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=rAjGBw1QzyMu8I6oGt32iWA6nBeADuP/yOWkMjeTyS4=;
	b=mvnReI+G386tA7LDJ8vjfMaR8HOD2tRNmJ7FlqUTy1YrL+0cz44LFY3dgqkk9wVckE50
	 PkugqtOcned9ICZ9ZVCR5c27Rl6hKPSPk3tqOy+qXyEnijsQ+BugF8ymoOVlSQJBX9jr5
	 3VhjE80YVyOi49NLsBalIcUFf6bHWNNpyaDO6wcb59IWfPP8F+XX4Hy3zA5SyCgDhpm6B
	 slVKn2BVVmO0ZvjNDoT/DRzCQCAxY/a9mhnFUmUA9Ciq/+0uQzoSvi2i27Us/gJjq0BtW
	 LEg82hlyZR5hZSLrr9ffSDTNMUuxIM6ariOdPKqzNRNzdZpA/W+zBWWMWcytqbsk1fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bS9AEq0n;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C354C606A89A;
	Wed, 11 Nov 2026 11:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C354C606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bS9AEq0n
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=rAjGBw1QzyMu8I6oGt32iWA6nBeADuP/yOWkMjeTyS4=; b=bS9AE
	q0nobRzz9Z0Dk7UnsxdeCDeVu03IdeczM9e1vcoLC1k1KQsD+wToJ+cbsLya1PRc8jlFGltx1b/Cb
	5oHlrUzgEBLeN4H3RVe3xN6NgnAEcHEaotaQuRWeFSpugZSAzCTq/hNGqeUOWd5PzJuxO4kzB3lLi
	fMukwgeR0nouDDLFwcwcYJuOPzgNIzVjwpXjB6h6HWhwWsCTRyLZ6jvGACmhcpmvdzHw/3OU/wVmj
	QRqV1bNe2J6kc+dIcppql9YUxiqeFES6sdyKikIMFQ+3CvxfWmrQ4pzjFp5FKCqTkpYSggqzlsq4m
	eb9w8I5Gtfzi3sCauWFPbci15g3xQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6Bg-0000000DmNa-0YJD;
	Wed, 11 Nov 2026 19:08:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:08:20 +0800
Date: Wed, 11 Nov 2026 19:08:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.4
Message-ID: <avRMpKP0ZQhAyqu7@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus:

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p2

for you to fetch changes up to 26ca5f34841f0a86d0883664a1c13be89a01d351:

  crypto: ccp - Make usage of sev_cmd_mutex more granular (2026-11-04 13:46:50 +0800)

----------------------------------------------------------------
This push fixes the following issues:

- Fix potential overflow from malformed keys in caam.
- Fix use-after-free in essiv.
- Fix potential dead-lock in ccp when combined with KVM changes in mainline.
----------------------------------------------------------------

Jérémy Jean (2):
      crypto: caam - reject overlong RSA CRT parameters
      crypto: essiv - fix use-after-free in AEAD path

Michael Roth (1):
      crypto: ccp - Make usage of sev_cmd_mutex more granular

 crypto/essiv.c                |   2 +-
 drivers/crypto/caam/caampkc.c |  75 +++++++++++++------------------
 drivers/crypto/ccp/sev-dev.c  | 101 +++++++++++++++++++++++++++++++-----------
 3 files changed, 107 insertions(+), 71 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
