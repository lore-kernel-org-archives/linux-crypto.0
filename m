Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B01155C82;
	Mon, 20 Jul 2026 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784508707; cv=none; b=qeIuyYg8r9JqREZtuu3Ms4K/aZKrKugZtlxjDFA0jEInTb160vYHw5i4dxmQDgVm80wSji+3RrwPDRWpdWUjfCc/s4Ht5OwjqCpawXW5ckj/lT4Z1UJ5rWhc1GGxW+ZCyn9POv77x4DHR1Ay7Asj3mnczkD8hc6ycFBjR+PkeFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784508707; c=relaxed/simple;
	bh=LFbEsyxA1KuKGuSliYdLfO36Cw1dzSSX0prXBoVOd0I=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mz1PQs29a6GM4GLnqGhdJOU1h8ikfhWzzNRdrIetNKLW7uJKrB9YcRSc2R2M2se9t+lEq6rNLhzeki82GCE5Fn68RoHmwawqunSYpkf6nR5ibPm+b2fBhMx8FHhPUtOd/q6AZSen5E6y2ySDx8f/vUHuRwg4GManf4wUBEXAWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rfPWOS0f; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rfPWOS0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:cc:to:subject:message-id:date:from
	:content-type:reply-to; bh=+/QlPkWndMeWDkZm2GL060ebxR50BCetvjFvCm8os3E=; b=rf
	PWOS0fNsPhE1Ovb2pj8Ox4do49GmFiB82oaBFgS4vREHeaEZAaS1o9OBgDh15JGsJBy2eRWAFVIku
	eb7RFA7GwipOmKG0vFweNi8JDwSb8rF4Ib15uR8Agco2uDLd1zlpp13doEuKm524i2sCyrIZ9sAco
	JdHhWo5ADBTqAJScOgwsGafKIZwS+PFTxYwFbeJ/EHF6ZwArNRCC46moo0x/NzxfwVuPv7H/HZCJC
	94x7OItABUmhoUI0sqG9Q35B+IhgAt4Q2hZ2gdhKqE4KPspOFJSwbQXN034pxcn2fhRrCkisvxYLW
	cU2wjEFKG87NAo0gu3SOFVTVukhkjnPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wlcEO-0000000Extd-0fiO;
	Mon, 20 Jul 2026 08:51:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Jul 2026 10:51:40 +1000
Date: Mon, 20 Jul 2026 10:51:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.2
Message-ID: <al1xHJ44X6qhXFTy@gondor.apana.org.au>
References: <aiZWfDt54UazaMJ0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiZWfDt54UazaMJ0@gondor.apana.org.au>

Hi Linus:

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p2

for you to fetch changes up to 8173f7e2ce67e6ca1d4763f3da14e5b01ce77456:

  rhashtable: clear stale iter->p on table restart (2026-07-17 09:04:45 +1000)

----------------------------------------------------------------
This push contains the following changes:

- Fix potential crash in rhashtable walk.
----------------------------------------------------------------

Cen Zhang (Microsoft) (1):
      rhashtable: clear stale iter->p on table restart

 lib/rhashtable.c | 1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
