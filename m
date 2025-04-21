Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 79D36288D2;
	Mon, 21 Apr 2025 08:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745224306; cv=none; b=G+rMPiPN0pnjlXq5oq1qZY6hvJorn9qZvR66oJfhBmagrXFV9j9LBpBAovpouJuRHoWAY+BzmJfG5OSyQrorXru4jDWrsC382TULnB2IHchPw12dloxFOSojUhTFFUfKS9+wyUgWshmF3WJ9kxsJzmk/lQXcIfLbrhtzcdN53DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745224306; c=relaxed/simple;
	bh=BA7VZdnswUJ0BTvh/DJPgGayChaPc3t2wYtkXj3cQEA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PsEeeTPrIDZxTf/JzFbYSOBWqS+iVEql0cOF+vuRTgO0avfHI68cUT1wMFn23Jbe7RIHiN/HRaIIy7ZhrsVBmVS7STJl6zIziD5TbIlEiytrWnk0yQxEi1IVcuihvQdj3BGhC1FgCC9m63YGallnHLUa8gjNiQU9ZwtA7+R93YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from longsh.shanghai.nfschina.local (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 886DF60260748;
	Mon, 21 Apr 2025 16:31:37 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	steffen.klassert@secunet.com,
	christophe.jaillet@wanadoo.fr
Cc: Su Hui <suhui@nfschina.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2 0/2] crypto: some cleanup and hardening
Date: Mon, 21 Apr 2025 16:31:15 +0800
Message-Id: <20250421083116.1161805-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

using size_add() to hardening kmalloc() and remove some redundant include
headers.
Compile test only.

v2:
 - remove redundant include headers in v1 (<linux/overflow.h>).
 - add a patch to remove other redundant headers.

v1:
 - https://lore.kernel.org/all/20250421055104.663552-1-suhui@nfschina.com/

Su Hui (2):
  crypto: using size_add() for kmalloc()
  crypto: remove some redundant include headers

 include/crypto/acompress.h    | 4 ----
 include/crypto/aead.h         | 6 +-----
 include/crypto/aes.h          | 1 -
 include/crypto/akcipher.h     | 4 ++--
 include/crypto/algapi.h       | 3 ---
 include/crypto/blowfish.h     | 1 -
 include/crypto/cast5.h        | 1 -
 include/crypto/cast6.h        | 1 -
 include/crypto/drbg.h         | 2 --
 include/crypto/hash.h         | 2 --
 include/crypto/internal/des.h | 1 -
 include/crypto/kpp.h          | 5 +----
 include/crypto/krb5.h         | 1 -
 include/crypto/pcrypt.h       | 1 -
 include/crypto/poly1305.h     | 1 -
 include/crypto/polyval.h      | 1 -
 include/crypto/rng.h          | 2 --
 include/crypto/serpent.h      | 1 -
 include/crypto/skcipher.h     | 4 ----
 include/crypto/sm4.h          | 1 -
 20 files changed, 4 insertions(+), 39 deletions(-)

-- 
2.30.2

