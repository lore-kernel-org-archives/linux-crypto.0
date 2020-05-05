Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB135C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF892078C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 14:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgEEOAS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 10:00:18 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:35333 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEEOAR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 10:00:17 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mgf4k-1ivnwQ1PHY-00h8U6; Tue, 05 May 2020 15:59:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] crypto: curve25519-hacl64 - Disable fortify-source for clang-10
Date:   Tue,  5 May 2020 15:59:34 +0200
Message-Id: <20200505135947.216022-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lga6gFSMOtoE9mutrLnQJE7st0bQNAzIeIYfftcfMNCL7iZsqJQ
 JviJeYnETa8FS6wxzULcnVU5pwk6XzwEeQNgc1N9Zegd0vSPT8udDcc/dLNdT+kFJKuKRhM
 pCcuCgkqdQkZFnO25/DxLaQCMQ9xi7obGLLAOWZgLjMS9hGQdNJ+zq/WfLkzEqkfVOICGQT
 dOi7yOzxKWdNBMS3D/ruA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lziD+9ryinA=:tNSwIO9eiImUWcWzM7o7Yw
 /IXnoW8Wn+JMx/zGIvnc/9jMRhHbe0jJvaWE3XWRWvQtv640zle7dGxD3ITwoBIKvW8BglR/+
 X6n8DodtwVEVn50jJLaLfZSLxYycqL20C2qB2AQxsI7F9V2yeNz1H1v2Q/9RJXUq+8KH1dEko
 GuIrjHzNHIq4QKluBgnGKugirOutwiQttifk76ghCblvVoXxNGQw81DJ/WUvQJLo6XxXo0sIR
 6VF4O/d5ptPzv8X9kEYKwH5N6uLU5lxy1a4sNEVR2gHUp0CE0tZAH/hl+KGOVcV0M1XptQeDa
 LP9PsmsHPf4GLCZcdvq4uuEP9fifieYr885wEuGI6oxz/ahfDHiiiRKTkS3Yls22ToNXvUU5L
 +3ulrQra3lWiD7+TMQQvBk+EsfGWUHm2Eofm1W1UfmN8Mbr+k7QU729dOwRikSeMMFHohhBgs
 LVoKGzng6dhFRgv12dCPWqeI6+WqqAr+G0r09Wq0g1chqjpKSRWFvHWemnqxGcgP1NGR7fmIs
 F29a/PH3VNORl+cIdUV1dwJCNfT8OzlhtcjEy1NDmZ/QxWysfw/pwXbwhTEGQK8yXEh21DrGM
 FOxC3ng9GNHpNbCnD0hhVedW36jqeZlEQw4O/0Q737f8slLpdvm5YoUGdWdmEAb421gfGCvS9
 HD3530hLbMvGA7rDUtaZQD6A8SvsyQf9opZ3Vf1l9WbIJdiwHHDwV+DxnbUhRESVc29pJfvLM
 sPUHiRo21hMwdp89LUGuxi2WBvbVJckmIpTZuyYpTD5oMvwNc0nZto4P1b5V+hFrnwYzIqq/V
 YbKjFtohfywfJwXSOcPghR1tlLnCszKHERi7dzhkCX0JeTCnMY=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

clang-10 produces a warning about excessive stack usage, as well
as rather unoptimized object code when CONFIG_FORTIFY_SOURCE is
set:

lib/crypto/curve25519-hacl64.c:759:6: error: stack frame size of 2400 bytes in function 'curve25519_generic' [-Werror,-Wframe-larger-than=]

Jason Donenfeld managed to track this down to the usage of
CONFIG_FORTIFY_SOURCE, and I found a minimal test case that illustrates
this happening on clang-10 but not clang-9 or clang-11.

To work around this, turn off fortification in this file.

Link: https://bugs.llvm.org/show_bug.cgi?id=45802
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/crypto/curve25519-hacl64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/crypto/curve25519-hacl64.c b/lib/crypto/curve25519-hacl64.c
index c7de61829a66..87adeb4f9276 100644
--- a/lib/crypto/curve25519-hacl64.c
+++ b/lib/crypto/curve25519-hacl64.c
@@ -10,6 +10,10 @@
  * integer types.
  */
 
+#if (CONFIG_CLANG_VERSION >= 100000) && (CONFIG_CLANG_VERSION < 110000)
+#define __NO_FORTIFY /* https://bugs.llvm.org/show_bug.cgi?id=45802 */
+#endif
+
 #include <asm/unaligned.h>
 #include <crypto/curve25519.h>
 #include <linux/string.h>
-- 
2.26.0

