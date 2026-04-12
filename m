Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C8A2A1AA;
	Sun, 12 Apr 2026 05:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775971965; cv=none; b=fZf+SCnHw9PM2ol2HbXA4vqtS3/zusJs6SqmM8pK/XY0B7dnY2r0HYlSZCoWPtGgw2s3g3I3d/WoPm5TGN2p2CdYlUkzOuu/kajEjpJUJvwcz0CotnzqVA7yfb69Mqx6514ECYIiE4G1Fdqos0UlvJpB0jj7EY3RN6IPhUfvgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775971965; c=relaxed/simple;
	bh=d3JL6Uz4MBiCKNlonEYV9q1mH+XYB9VrWJfi6undVAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaskMwbYFfEV6gbmKC3W2u5oqjRppetr9u+T+SMMVKzvW0MYiIWFLZh5Z9bdaVozB/scOYHfLHr8xA8EGVXaLdKQ1mJpal6Eo6k6J38ans2AkLJO8wTNU4elX8rzeHeHSuvqOBUAogCgdlu3eQsRUSbRUQ4hM+KsaL6VX+5X8pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dZrlutyS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dZrlutyS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HBBY7Vv/4OnTrQkBaVfR/kNRGngCrEyMnBd5ikS3K/s=; 
	b=dZrlutySs86n4CG3o/FnLwEmLnDhfW7W910rYaAV+JEV3IBd2NeuX2i3iZV4Djewwr5LPqVijZa
	zJATyfpJUtyHM5yoKH0rlA0UJXnCozstUG8/l6drnJLL5hpE6FFItvWiTepvOrERjl0CTnLdgGV0h
	RXdkeyx06Tw06nH1k4e/KABWCqysRCW66Nb4u0/1Q+qmFHyCokC8PFTQKPgivUHvpfNCkmf3mwpY7
	EbGnGeEkP/HSAr9MfRBIy/8x+Jyp4t2QhkFqokPtNEP6y0Tg8iLk/lFLWclbBX57tlNMCCdp33j5t
	Vfg4I06lvsl3Ddwecq2IpcxEFeLbKlvNrQ6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBn1G-005T0s-1h;
	Sun, 12 Apr 2026 13:32:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 13:32:21 +0800
Date: Sun, 12 Apr 2026 13:32:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daniel Pouzzner <douzzer@mega.nu>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	Taeyang Lee <0wn@theori.io>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: [v2 PATCH] crypto: algif_aead - Fix minimum RX size check for
 decryption
Message-ID: <adsuZfIjp6OcaAsi@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
 <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
 <acTSfLPWDGTaGIf7@gondor.apana.org.au>
 <73ab5267-57b8-4394-9c10-4ee3bf92e444@leemhuis.info>
 <adkOsK-uPRsv49Yz@gondor.apana.org.au>
 <ac3f34e743737c128c289576c1f134d1991d4552.camel@mega.nu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3f34e743737c128c289576c1f134d1991d4552.camel@mega.nu>

On Fri, Apr 10, 2026 at 10:33:39AM -0500, Daniel Pouzzner wrote:
>
> Meanwhile, next-20260409 with your point patches to
> crypto/algif_aead.c:_aead_recvmsg() and crypto/af_alg.c:af_alg_pull_tsgl()
> deterministically produces wrong results on these:
> 
> [FAILED: 64-bit - 7.1.0-rc7-next-next-20260409-dirty] AEAD ccm(aes) asynchronous one shot multiple test
> (/usr/local/libexec/libkcapi/kcapi  -d 4 -x 10   -c ccm(aes) -q 4edb58e8d5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d -t a7877c99 -n 674742abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4 -a fb7bc304a3909e66e2e0c5ef952712dd884ce3e7324171369f2c5db1adc48c7d)
> Exp 8dd351509dcf1df9[...]
> Got EBADMSG

Sorry I got the maths wrong.  This one works for me:

---8<---
The check for the minimum receive buffer size did not take the
tag size into account during decryption.  Fix this by adding the
required extra length.

Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com
Reported-by: Daniel Pouzzner <douzzer@mega.nu>
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index dda15bb05e89..f8bd45f7dc83 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -144,7 +144,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
-		if (used < less) {
+		if (used < less + (ctx->enc ? 0 : as)) {
 			err = -EINVAL;
 			goto free;
 		}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
