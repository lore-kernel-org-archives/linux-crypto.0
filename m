Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443F1361;
	Fri,  8 Aug 2025 05:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754632725; cv=none; b=R9hdBRYlD6JMchoDEpMcq6qb0EpshqLrR2gFcOO5cUq3GQVC/tyE2l+Cg0dTV4nxbAaTn5UjdnDcPrCxpBC7nd8F1RPdfrT0/vQwi711rXJuJj7kB7U/XRb1btIRDc7ZO/gTVuSp5Aa6MSM2NH8p3HBqdZD1Tl21/tFD8sqeKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754632725; c=relaxed/simple;
	bh=ATvebudoFm58Nl5eUb5D19ul2h0IebdU3s3GD4cZlHE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rMjfrxrnB8DSS7V45yiHudik50vpnh5lp10BvgCc9/M9Wyw0YD20YHBR8NxgPsrlOcY8g2j8YLbH5+4jMlpm9iL5gxek/sG1r/cmO6CA7BEIfHxE+pEOEBbWpYm8rNPKkXIGvoBMZGx51kOdxcvPs5lGpoxE1vFkjtqMk8YONJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eQ1G0cOq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eQ1G0cOq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=47vjwj7wOdjr4ZrTC6VZ66VJ0qSo0ddvK5wjiYcRf5g=; b=eQ1G0cOqfBEDgYbHsO97lWSri5
	jjS89fxKuToJTDuURpq5a7Je5a6FiXMK/u08ib8s449po8oL/j4Pq3Axl6hH5PW4sBHEgRXUsJk20
	/tUHo/VA0Yc5HdWXzlsEuFeJPirZhqXlTpYO5EIt039zGyqwWqgCQwEThReBqhJUT6wE0O29nTLHP
	/c1FyzvVKJJ/lv++zLlIZtDYB66rwpIB3+mihhUNDRMQWEqXHOBNFvjphqwZCzyP+VmLFLQRC0PJx
	cg7oioEMp7FuP+nDDtfh1cmUn1KypmeW+Y89dwBdM3z/zd6f09IUFrvuXXDJd6fd1ARHPrOlBrcBa
	03OErsmw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ukFc3-00CXQP-1L;
	Fri, 08 Aug 2025 13:41:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Aug 2025 13:41:51 +0800
Date: Fri, 8 Aug 2025 13:41:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.17
Message-ID: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit bf24d64268544379d9a9b5b8efc2bb03967703b3:

  crypto: keembay - Use min() to simplify ocs_create_linked_list_from_sg() (2025-07-27 22:41:45 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p2

for you to fetch changes up to 9d9b193ed73a65ec47cf1fd39925b09da8216461:

  crypto: hash - Increase HASH_MAX_DESCSIZE for hmac(sha3-224-s390) (2025-08-01 19:40:54 +0800)

----------------------------------------------------------------
This push fixes a regression that breaks hmac(sha3-224-s390).
----------------------------------------------------------------

Herbert Xu (1):
      crypto: hash - Increase HASH_MAX_DESCSIZE for hmac(sha3-224-s390)

 include/crypto/hash.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
