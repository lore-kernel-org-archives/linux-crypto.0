From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH] libcrc32c: Fix "crc32c undefined" compilation error
Date: Tue, 11 Nov 2008 01:59:26 +0100
Message-ID: <1226365166-24472-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailx.swiss-it.ch ([81.6.4.203]:53962 "EHLO mailx.swiss-it.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYKKBU0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2008 20:20:26 -0500
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The latest shash changes leave crc32c undefined:

[...]
Building modules, stage 2.
  MODPOST 1381 modules
  ERROR: "crc32c" [net/sctp/sctp.ko] undefined!
  ERROR: "crc32c" [net/ipv4/netfilter/nf_nat_proto_sctp.ko] undefined!

Adding EXPORT_SYMBOL(crc32c) to lib/libcrc32c.c fixes the compile error.
This patch has been compile-tested only.

Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---
 lib/libcrc32c.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 38b17ab..244f548 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -57,6 +57,8 @@ u32 crc32c(u32 crc, const void *address, unsigned int length)
 	return *(u32 *)desc.ctx;
 }
 
+EXPORT_SYMBOL(crc32c);
+
 static int __init libcrc32c_mod_init(void)
 {
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
-- 
1.5.4.3

