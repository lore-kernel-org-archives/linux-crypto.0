Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B7441760;
	Mon,  8 Jan 2024 13:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tkos.co.il
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tkos.co.il
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tkos.co.il header.i=@tkos.co.il header.b="tjuaJArO"
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.tkos.co.il (Postfix) with ESMTPS id B733B440865;
	Mon,  8 Jan 2024 15:19:43 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
	s=default; t=1704719983;
	bh=wtHqN07myRERCtZ6Zo+lMUD/6DQu1zA0N6GC+nEqKds=;
	h=From:To:Cc:Subject:Date:From;
	b=tjuaJArOWz79fcZaB7H0nq9ku/btGvbHZjDZLukcaLFX/BKCR6mv2NJGO+ngbeVpD
	 vny+TDxRtMZcZDk2Gx0dAUhL7Z9criSqC7wJ+SfOgmJUpgH5YTVceUsU6OMwTlCBuJ
	 BRxW9ACD0wVkDmZL/ej67/1CwP0saylZD63W/bCYkDyNk9C/a5oEgHn5eddi7fEZVm
	 +krwazkBF5ycNvsVxg9ky9gB9i2mdfqHVTiNUZwnjpD7H20IWfMr/2P7ZQY8dmOXV8
	 eNh+6yofCth1CXjAMEXFilK5HIEvWx2Ueh5iUsNOKoqjBkYW923JJgFZaVq/evlB81
	 dly4G+sRwFY9Q==
From: Baruch Siach <baruch@tkos.co.il>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] docs: admin-guide: hw_random: update rng-tools website
Date: Mon,  8 Jan 2024 15:21:45 +0200
Message-ID: <ef52ace5008fa934084442149f64f5f9ddbba465.1704720105.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rng-tools upstream moved to github. New upstream does not appear to
consider itself official website for hw_random. Drop that part.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/admin-guide/hw_random.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/hw_random.rst b/Documentation/admin-guide/hw_random.rst
index d494601717f1..bfc39f1cf470 100644
--- a/Documentation/admin-guide/hw_random.rst
+++ b/Documentation/admin-guide/hw_random.rst
@@ -14,10 +14,9 @@ into that core.
 
 To make the most effective use of these mechanisms, you
 should download the support software as well.  Download the
-latest version of the "rng-tools" package from the
-hw_random driver's official Web site:
+latest version of the "rng-tools" package from:
 
-	http://sourceforge.net/projects/gkernel/
+	https://github.com/nhorman/rng-tools
 
 Those tools use /dev/hwrng to fill the kernel entropy pool,
 which is used internally and exported by the /dev/urandom and
-- 
2.43.0

