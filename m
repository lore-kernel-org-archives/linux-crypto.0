From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/3] padata: Add a reference to the api documentation
Date: Wed, 28 Mar 2012 08:42:34 +0200
Message-ID: <20120328064234.GE16191@secunet.com>
References: <20120328064157.GD16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49140 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2C1Gm6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 02:42:58 -0400
Content-Disposition: inline
In-Reply-To: <20120328064157.GD16191@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a reference to the padata api documentation at Documentation/padata.txt

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6f10eb2..7875088 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1,6 +1,8 @@
 /*
  * padata.c - generic interface to process data streams in parallel
  *
+ * See Documentation/padata.txt for an api documentation.
+ *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
  *
-- 
1.7.0.4
