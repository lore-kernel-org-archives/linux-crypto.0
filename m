Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C025B09C;
	Fri,  3 Jul 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783100300; cv=none; b=T+NRX0Jh8wRk5bsZLed/ObPxzSTV+wsNTj6x97tSW+s3lWsC5NV02aGx4FMvHabk3bavUqg3vevlcRDL/sGwnFq4gJMdUCnwB2DMTLmWGMOT0Fz/c8FR4gdRZX+Zo/HoEMg8hSNVYyxA2vrEOhL/kN7xws3f/x/aQTaZ0jXHKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783100300; c=relaxed/simple;
	bh=nXJnsdLsM93mqYbkHmj9fVt5nkAxY73wwf1qK2C6pG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lWqedSAjqXoW7LfcKKJR0Nw/p71Jiqdb87HfcA8QBWQLhA07cCwam2G6WUBn1m2ijJw+MkmOD54WWEiBU6TulWH969Zuhub9g0mcovu2Bp4+GqWfufe1lBinq48gtIlcXXeKk1+U4+q8InrD8IdsOLJR4lomfSsa59xEpbv8i7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fhtn9Dio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fhtn9Dio"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C18D81F000E9;
	Fri,  3 Jul 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783100298;
	bh=HnxPqiOLGycxJp+uPN8CE/Rc87ZyzW9wZbMldSEgCI8=;
	h=From:To:Cc:Subject:Date;
	b=Fhtn9Dioqf7HGLb3MGP48wv9XyzjDK61eCaYKYc6x6PqAEU80CYYGSUBcnn7Z90rI
	 LnBCcZbMZZG6BVrwugDcE/NiOBY1Nu7iQqMrc138jqniJR7XQFHTnLAeiQi9fcwX7/
	 oHHOZd8tfF/5xMbL3FeCyptGoP1gTta5haZTLLbu0r+Ofc2guBybpaez1bV9MPTt56
	 unj/a3Br/3+yT467PvQ5hOkroGPZoaCPImcLxkRartxGCGOWcCsj/akNuOfGciedI5
	 ScyYISabg75t3QM4pCkxSYMS3+QMxIFAjN2Fdrq7xHLowJ+Knk7dGOf9ByKhzoejjO
	 NjeLBfSlZmIBA==
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Gross <markgross@kernel.org>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	linux-edac@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3] MAINTAINERS: Drop Mark Gross
Date: Fri,  3 Jul 2026 19:38:03 +0200
Message-ID: <20260703173803.3589003-2-ukleinek@kernel.org>
X-Mailer: git-send-email 2.55.0.11.g153666a7d9bb
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2115; i=ukleinek@kernel.org; h=from:subject; bh=nXJnsdLsM93mqYbkHmj9fVt5nkAxY73wwf1qK2C6pG0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqR/N7Wy1d44937AOVhPlX44c64v1TT/P1S3Iy9 IicfnaXqhqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCakfzewAKCRCPgPtYfRL+ TrySB/982uqvd5z0fb5aGmSx3tU4YD1A5qa14JDMEtav5R8+xn4CGT+hDu7YyhWyJhG34PsBMSc uCipvStN4jXEwDR/ZhUGTnidPyZNXCNI+ewVLELt5FnVzRUR8AWoFWwR5a6NY/FwImJaJsUaxv3 Hf5zx+1v5RRS8omjPepL1f6/1WllkKNrrVpxtLRcAEC3y1Qi1jNeI+xQ9nutTEBie0sK4d2dYXZ Hm70J+BIdTRlx9a2+au1cRHKKrRam9Bz5Yki5hgY4sc5QA1hIj7N44/nIvXk9c6GqMBRT0Ko24F GQvEvCWo4EZ6u6KohcMC6LIkIj6B9F3QhhZpeeOfa1lf2Xks
X-Developer-Key: i=ukleinek@kernel.org; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Sending mail to Mark's Intel address results in the intel mail
server rejecting the mail. Dave Hansen confirmed he left Intel.
The kernel.org address seems to work, but there was no reply from Mark
on the discussion about broken email settings and his maintainer
entries.

So drop him from all maintainer entries.

Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
---
Hello,

this patch was already send end of May (v1 @
https://lore.kernel.org/all/20260526173806.3227828-2-ukleinek@kernel.org).
Konstantin then suggested to change the maintainer contacts to the
kernel.org address as at least one of the forward-addresses for the
kernel.org account didn't bounce. This v2
(https://lore.kernel.org/all/20260526193238.3622176-2-ukleinek@kernel.org)
wasn't picked up yet, but given the continued silence I think removing
Mark completely is the saner choice now.

If someone has a better contact, please make him react. If he returns
later, the entries can easily get restored.

Best regards
Uwe

 MAINTAINERS | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f96621b3214c..d5260c8e9af5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9354,9 +9354,8 @@ S:	Supported
 F:	drivers/edac/dmc520_edac.c
 
 EDAC-E752X
-M:	Mark Gross <markgross@kernel.org>
 L:	linux-edac@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/edac/e752x_edac.c
 
 EDAC-E7XXX
@@ -13211,7 +13210,6 @@ F:	drivers/crypto/intel/keembay/ocs-aes.h
 
 INTEL KEEM BAY OCS ECC CRYPTO DRIVER
 M:	Prabhjot Khurana <prabhjot.khurana@intel.com>
-M:	Mark Gross <mgross@linux.intel.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 F:	drivers/crypto/intel/keembay/Kconfig
@@ -26683,8 +26681,7 @@ S:	Maintained
 F:	drivers/net/ethernet/tehuti/tn40*
 
 TELECOM CLOCK DRIVER FOR MCPL0010
-M:	Mark Gross <markgross@kernel.org>
-S:	Supported
+S:	Orphan
 F:	drivers/char/tlclk.c
 
 TEMPO SEMICONDUCTOR DRIVERS

base-commit: 2b763db0c2763d6bf73d7d3e69665222d1f377cf
-- 
2.55.0.11.g153666a7d9bb

