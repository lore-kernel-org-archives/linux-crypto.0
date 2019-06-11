Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38A4C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 01:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A862086D
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 01:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="dQpPZ6wo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390400AbfFKByh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 21:54:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34358 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390388AbfFKByg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 21:54:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so6367245pfc.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2019 18:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d8vqyEfyEGXEarVNNYpCOFtLHlqzQ7o7fyj/liwhzuE=;
        b=dQpPZ6woCtcySsrf4Ul24GN4v7BttX0OsyBXheASptYvWUSyDbA8NWCGKPrtzLqrrv
         l7K8qC2z/2pi73CIZUzt9wGWtnEYd8AlZiYKTJWC787q4ePdDEMTa8c4vEX7IO97tRxm
         +3EMgB0ZMLZh1elTgLedz+xdXlx53qs8ajD7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d8vqyEfyEGXEarVNNYpCOFtLHlqzQ7o7fyj/liwhzuE=;
        b=ilO/gBJ7FlAyn3p2VurGtVZJjMSxCcdxmfkXqdWv1a6tMrDaGX+5MzO+Lx26JIaHJK
         Cxg5lrYnnLjWRbDmjEI+gIAcGPQZVE+zNNVVjXzTEefdEReYstYQUNOU0Up+YStDf3GH
         kUqr5B7Lq0q1xKlK79zu4Wak+1W6MKnvpJgl1kKBdRFDiiJGItryZRTogCD9ijhfcbja
         xDv4dEBiHRf01GenMvp6buFBDq/7kUbPvHsxn7DRLMnefoySXjd0auLu42J82mte3ud0
         fBxIkKG0sVZNofEiUm4ahXMkPcntUqM/yAeN0gDxLj43cFfvgdlWLByl738F8+u6N5RD
         smjg==
X-Gm-Message-State: APjAAAVqlQs1VVEuW4KDk1Ps2eqCBbDy8nppludGfXLzdbO48QZrjpCj
        1NP9zxclrOKl1kwtvu0EXEzbhw==
X-Google-Smtp-Source: APXvYqw3WSeugZDuLtsfP733puLMUeQvH9dbPzsXTHy2ldDDcutOiW/unPP4BCv/v+BIqhRKFY58ig==
X-Received: by 2002:a65:6284:: with SMTP id f4mr18441480pgv.14.1560218076066;
        Mon, 10 Jun 2019 18:54:36 -0700 (PDT)
Received: from localhost (ppp167-251-205.static.internode.on.net. [59.167.251.205])
        by smtp.gmail.com with ESMTPSA id b26sm7741233pfo.129.2019.06.10.18.54.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 18:54:35 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     mpe@ellerman.id.au, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: [PATCH] crypto: vmx - Document CTR mode counter width quirks
Date:   Tue, 11 Jun 2019 11:54:31 +1000
Message-Id: <20190611015431.26772-1-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CTR code comes from OpenSSL, where it does a 32-bit counter.
The kernel has a 128-bit counter. This difference has lead to
issues.

Document it.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/crypto/vmx/aesp8-ppc.pl | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index 9c6b5c1d6a1a..db874367b602 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1286,6 +1286,24 @@ ___
 
 #########################################################################
 {{{	# CTR procedure[s]						#
+
+####################### WARNING: Here be dragons! #######################
+#
+# This code is written as 'ctr32', based on a 32-bit counter used
+# upstream. The kernel does *not* use a 32-bit counter. The kernel uses
+# a 128-bit counter.
+#
+# This leads to subtle changes from the upstream code: the counter
+# is incremented with vaddu_q_m rather than vaddu_w_m. This occurs in
+# both the bulk (8 blocks at a time) path, and in the individual block
+# path. Be aware of this when doing updates.
+#
+# See:
+# 1d4aa0b4c181 ("crypto: vmx - Fixing AES-CTR counter bug")
+# 009b30ac7444 ("crypto: vmx - CTR: always increment IV as quadword")
+# https://github.com/openssl/openssl/pull/8942
+#
+#########################################################################
 my ($inp,$out,$len,$key,$ivp,$x10,$rounds,$idx)=map("r$_",(3..10));
 my ($rndkey0,$rndkey1,$inout,$tmp)=		map("v$_",(0..3));
 my ($ivec,$inptail,$inpperm,$outhead,$outperm,$outmask,$keyperm,$one)=
@@ -1357,7 +1375,7 @@ Loop_ctr32_enc:
 	addi		$idx,$idx,16
 	bdnz		Loop_ctr32_enc
 
-	vadduqm		$ivec,$ivec,$one
+	vadduqm		$ivec,$ivec,$one	# Kernel change for 128-bit
 	 vmr		$dat,$inptail
 	 lvx		$inptail,0,$inp
 	 addi		$inp,$inp,16
@@ -1501,7 +1519,7 @@ Load_ctr32_enc_key:
 	$SHL		$len,$len,4
 
 	vadduqm		$out1,$ivec,$one	# counter values ...
-	vadduqm		$out2,$ivec,$two
+	vadduqm		$out2,$ivec,$two	# (do all ctr adds as 128-bit)
 	vxor		$out0,$ivec,$rndkey0	# ... xored with rndkey[0]
 	 le?li		$idx,8
 	vadduqm		$out3,$out1,$two
-- 
2.20.1

