From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: blowfish-x86_64: add credits
Date: Fri, 23 Sep 2011 19:51:00 +0300
Message-ID: <20110923165100.29475.89853.stgit@localhost6.localdomain6>
References: <20110923165055.29475.16493.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45435 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1IWQvD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Sep 2011 12:51:03 -0400
In-Reply-To: <20110923165055.29475.16493.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish_glue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 40911ab..2568a7b 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -3,6 +3,11 @@
  *
  * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
