Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9888218FC9F;
	Sat, 15 Mar 2025 09:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029755; cv=none; b=sr82IFI5nJJkqKjKqt1jKw8TX8Cpn3TqtMiWYOPjiEK53NCyiYlkKIcKecj0UWtnEruOWpfuYVOP2oAN879dtWFfAlHPMZEjd+VEvfu2/KvZLvh9UGfWIrs4FH+0o+yriaDJvH9VKF3OXo+eK5SkQwSLpsU+G3DZZ5RvNOVeWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029755; c=relaxed/simple;
	bh=RN3Hwl3SXSPYywMnKLCwBQtYEPtEJMVM73NPdQueAjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0eGL2RoHBPE06ZknyjN6fSPuu2fe4tw4NLQ4W8TGiLglHRFN3QqYyOUv+4/otNm1Z4v4bKe8KQW8Lq00XfEt24QOZp/3aQ47ac7ptZ1XW41lthuMQv9qompJwhPxzMlpHNYH275N69c2iIXB+WGCWLX5UoyuN8CbBdiIX6mBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r3yFut92; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r3yFut92"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=veEyQwuRVSguA+tr2piVjFBLUcEH45me5MSTV8DwiYQ=; b=r3yFut92yyAn2KVbDfftR4aXnf
	6tEyJjlMKUlmf+FouJ350/DO3SRh2hRjukWuQKJ+cqLx1dysbIjQy2hx5k3dBKUcQfguxXkrBQmZw
	cMuJQnnu9Fni3KIWvNdU4bKKh09I2T7nDenBTNm6/etvNrWDINs7L0s9EpObw8IrF9JHFqDv28tqA
	Qfb3ZbFM3Hg7VCZ1TcRp1I1MprWuExAwqxXqWf/zq5t/FtSIXP6OqNmYL3ENCyFyQeYnqHDeJCxzI
	JXys836lqrBTZR80NQtSErDrIAbYme4+5EVWZ8a3x7ED52sAsgkmDQzPJfK13WJWSy4TMqgdyhLAh
	u+b6XbWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNVs-006nz2-0x;
	Sat, 15 Mar 2025 17:09:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:09:00 +0800
Date: Sat, 15 Mar 2025 17:09:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shashank Gupta <shashankg@marvell.com>
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Amit Singh Tomar <amitsinght@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2: suppress auth failure screaming due
 to negative tests
Message-ID: <Z9VDrBJD05mKOHn_@gondor.apana.org.au>
References: <20250305075704.2987579-1-shashankg@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305075704.2987579-1-shashankg@marvell.com>

On Wed, Mar 05, 2025 at 01:27:05PM +0530, Shashank Gupta wrote:
> This patch addresses an issue where authentication failures were being
> erroneously reported due to negative test failures in the "ccm(aes)"
> selftest.
> pr_debug suppress unnecessary screaming of these tests.
> 
> Signed-off-by: Shashank Gupta <shashankg@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
