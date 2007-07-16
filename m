From: Frederik Sdun <fs_1600@web.de>
Subject: [PATCH] crypto/aes.c remove operator ? and variable t in bf_setkey
Date: Mon, 16 Jul 2007 02:52:34 +0200
Message-ID: <1184547154.23516.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47340 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761838AbXGPAwg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jul 2007 20:52:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

this removes the the ? operator which is false nearly all the time.


--- aes.c.orig  2007-07-15 11:43:21.000000000 +0200
+++ aes.c       2007-07-16 01:56:49.000000000 +0200
@@ -156,9 +156,12 @@
 
                p = (p << 1) ^ (p & 0x80 ? 0x01b : 0);
        }
+
+       sbx_tab[0] = 0x63;
+       isb_tab[0x63] = (u8) 0;
 
-       for (i = 0; i < 256; ++i) {
-               p = (i ? pow_tab[255 - log_tab[i]] : 0);
+       for (i = 1; i < 256; ++i) {
+               p = pow_tab[255 - log_tab[i]];
                q = ((p >> 7) | (p << 1)) ^ ((p >> 6) | (p << 2));
                p ^= 0x63 ^ q ^ ((q >> 6) | (q << 2));
                sbx_tab[i] = p;

this removes the variable t which is only a working copy of p, but you
do not need a copy

@@ -135,7 +135,7 @@
 static void __init
 gen_tabs (void)
 {
-       u32 i, t;
+       u32 i;
        u8 p, q;
 
        /* log and power tables for GF(2**8) finite field with
@@ -168,38 +171,38 @@
        for (i = 0; i < 256; ++i) {
                p = sbx_tab[i];
 
-               t = p;
-               fl_tab[0][i] = t;
-               fl_tab[1][i] = rol32(t, 8);
-               fl_tab[2][i] = rol32(t, 16);
-               fl_tab[3][i] = rol32(t, 24);
+
+               fl_tab[0][i] = p;
+               fl_tab[1][i] = rol32(p, 8);
+               fl_tab[2][i] = rol32(p, 16);
+               fl_tab[3][i] = rol32(p, 24);
 
-               t = ((u32) ff_mult (2, p)) |
+               p = ((u32) ff_mult (2, p)) |
                    ((u32) p << 8) |
                    ((u32) p << 16) | ((u32) ff_mult (3, p) << 24);
 
-               ft_tab[0][i] = t;
-               ft_tab[1][i] = rol32(t, 8);
-               ft_tab[2][i] = rol32(t, 16);
-               ft_tab[3][i] = rol32(t, 24);
+               ft_tab[0][i] = p;
+               ft_tab[1][i] = rol32(p, 8);
+               ft_tab[2][i] = rol32(p, 16);
+               ft_tab[3][i] = rol32(p, 24);
 
                p = isb_tab[i];
 
-               t = p;
-               il_tab[0][i] = t;
-               il_tab[1][i] = rol32(t, 8);
-               il_tab[2][i] = rol32(t, 16);
-               il_tab[3][i] = rol32(t, 24);
+
+               il_tab[0][i] = p;
+               il_tab[1][i] = rol32(p, 8);
+               il_tab[2][i] = rol32(p, 16);
+               il_tab[3][i] = rol32(p, 24);
 
-               t = ((u32) ff_mult (14, p)) |
+               p = ((u32) ff_mult (14, p)) |
                    ((u32) ff_mult (9, p) << 8) |
                    ((u32) ff_mult (13, p) << 16) |
                    ((u32) ff_mult (11, p) << 24);
 
-               it_tab[0][i] = t;
-               it_tab[1][i] = rol32(t, 8);
-               it_tab[2][i] = rol32(t, 16);
-               it_tab[3][i] = rol32(t, 24);
+               it_tab[0][i] = p;
+               it_tab[1][i] = rol32(p, 8);
+               it_tab[2][i] = rol32(p, 16);
+               it_tab[3][i] = rol32(p, 24);
        }
 }


Frederik
