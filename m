Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1185334C06;
	Fri,  9 Jan 2026 09:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767952099; cv=none; b=q/TStPWy4F4AYsXzwJ6C9Ou0M999wxSjcN8ITfZ+f0jp+7hYIZwSjuGmHLvnwVBfmw8c7hXsWv1WZ83Nm8/ZRvrCRtCOI9zLs6ZVfy+ioc0tM+0/nPZGuOvt/KVEW29b4iX+dNrN6YpwCnvrFYgYO/Jj3Ai3cjMazcMpTdE310s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767952099; c=relaxed/simple;
	bh=4M2Pq8+pfncM/K+XjpfpIEqtdittXiEkK+sO/sUoLeI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PCmyEAtJ2EY+FrI43862YCH9xA3Oh06jbLeMD+0vIDL45G5jlNHDhOQACmIXU4XbsOuKawahQIHF+2wgmGbtnsbCxaWtSPY+TzoCak1lV1Vy7noN6TohPvB/Gr0gaAGvAPcWwlgAg/3/YbqmDSBWSPjnv1GSbAE6ahLB35v3rIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qF9oFmxs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qF9oFmxs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=lLhzg3KwperXX523mH7VqKT0Kl+oBc2uB5RE8cy2N/A=; b=qF9oF
	mxsri0iKtJ9oHYi+I36b+RwBez/G/cmybmTGUJbrRLfWDryuXeTA498kHVpfBzSSPRS9xdFwqir5q
	isDHQ6b4QRJNJ7txG6BBt/ghqfuobWhQ5jLWg73xvWebMlkGvCA1hNc8CWHjJhPGdJ3Ft4QkHZruO
	fiICfa+b8fvyHFn2oNervHZTDGgSNO/YLSD/oOwVXcHunzbIS9fTDWsMAoE2LSKvg9ga9cDH7o2vh
	sZbFFebyHLikgGth3/Ia4HaufriYZVe3nxyEFg3yTA4l8Fh00XvHYlCW1cxeNL6mgUFfLhGhn36Pd
	npgJZscvqVxQC54889yAFyA5LgtAw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ve969-00FNWG-0C;
	Fri, 09 Jan 2026 17:48:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Jan 2026 17:48:01 +0800
Date: Fri, 9 Jan 2026 17:48:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.19
Message-ID: <aWDO0UuX-rOGe1Sd@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit b74fd80d7fe578898a76344064d2678ce1efda61:

  crypto: hisilicon/qm - fix incorrect judgment in qm_get_complete_eqe_num() (2025-12-19 14:47:46 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p3

for you to fetch changes up to 961ac9d97be72267255f1ed841aabf6694b17454:

  crypto: qat - fix duplicate restarting msg during AER error (2025-12-29 08:44:14 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix duplicate restart messages in qat.
----------------------------------------------------------------

Harshita Bhilwaria (1):
      crypto: qat - fix duplicate restarting msg during AER error

 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 --
 1 file changed, 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
