Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1181C3A59D
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4F22133F
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfHPVQ0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 17:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbfHPVQZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 17:16:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A86230A7B8F;
        Fri, 16 Aug 2019 21:16:25 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 138B887A3;
        Fri, 16 Aug 2019 21:16:20 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: sha256 - Fix some coding style issues
Date:   Fri, 16 Aug 2019 23:16:06 +0200
Message-Id: <20190816211611.2568-2-hdegoede@redhat.com>
In-Reply-To: <20190816211611.2568-1-hdegoede@redhat.com>
References: <20190816211611.2568-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 16 Aug 2019 21:16:25 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For some reason after the first 15 steps the last statement of each
step ends with "t1+t2", missing spaces around the "+". This commit
fixes this. This was done with a 's/= t1+t2/= t1 + t2/' to make sure
no functional changes are introduced.

Note the main goal of this is to make lib/sha256.c's sha256_transform
and its helpers identical in formatting too the duplcate implementation
in crypto/sha256_generic.c so that "diff -u" can be used to compare them
to prove that no functional changes are made when further patches in
this series consolidate the 2 implementations into 1.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/sha256.c | 98 ++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/lib/sha256.c b/lib/sha256.c
index d9af148d4349..ba4dce0b3711 100644
--- a/lib/sha256.c
+++ b/lib/sha256.c
@@ -92,109 +92,109 @@ static void sha256_transform(u32 *state, const u8 *input)
 	t1 = b + e1(g) + Ch(g, h, a) + 0x9bdc06a7 + W[14];
 	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0xc19bf174 + W[15];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0xe49b69c1 + W[16];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0xefbe4786 + W[17];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0x0fc19dc6 + W[18];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0x240ca1cc + W[19];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0x2de92c6f + W[20];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0x4a7484aa + W[21];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0x5cb0a9dc + W[22];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0x76f988da + W[23];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0x983e5152 + W[24];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0xa831c66d + W[25];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0xb00327c8 + W[26];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0xbf597fc7 + W[27];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0xc6e00bf3 + W[28];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0xd5a79147 + W[29];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0x06ca6351 + W[30];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0x14292967 + W[31];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0x27b70a85 + W[32];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0x2e1b2138 + W[33];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0x4d2c6dfc + W[34];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0x53380d13 + W[35];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0x650a7354 + W[36];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0x766a0abb + W[37];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0x81c2c92e + W[38];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0x92722c85 + W[39];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0xa2bfe8a1 + W[40];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0xa81a664b + W[41];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0xc24b8b70 + W[42];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0xc76c51a3 + W[43];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0xd192e819 + W[44];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0xd6990624 + W[45];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0xf40e3585 + W[46];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0x106aa070 + W[47];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0x19a4c116 + W[48];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0x1e376c08 + W[49];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0x2748774c + W[50];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0x34b0bcb5 + W[51];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0x391c0cb3 + W[52];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0x4ed8aa4a + W[53];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0x5b9cca4f + W[54];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0x682e6ff3 + W[55];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	t1 = h + e1(e) + Ch(e, f, g) + 0x748f82ee + W[56];
-	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1+t2;
+	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;
 	t1 = g + e1(d) + Ch(d, e, f) + 0x78a5636f + W[57];
-	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1+t2;
+	t2 = e0(h) + Maj(h, a, b);    c += t1;    g = t1 + t2;
 	t1 = f + e1(c) + Ch(c, d, e) + 0x84c87814 + W[58];
-	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1+t2;
+	t2 = e0(g) + Maj(g, h, a);    b += t1;    f = t1 + t2;
 	t1 = e + e1(b) + Ch(b, c, d) + 0x8cc70208 + W[59];
-	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1+t2;
+	t2 = e0(f) + Maj(f, g, h);    a += t1;    e = t1 + t2;
 	t1 = d + e1(a) + Ch(a, b, c) + 0x90befffa + W[60];
-	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1+t2;
+	t2 = e0(e) + Maj(e, f, g);    h += t1;    d = t1 + t2;
 	t1 = c + e1(h) + Ch(h, a, b) + 0xa4506ceb + W[61];
-	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1+t2;
+	t2 = e0(d) + Maj(d, e, f);    g += t1;    c = t1 + t2;
 	t1 = b + e1(g) + Ch(g, h, a) + 0xbef9a3f7 + W[62];
-	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1+t2;
+	t2 = e0(c) + Maj(c, d, e);    f += t1;    b = t1 + t2;
 	t1 = a + e1(f) + Ch(f, g, h) + 0xc67178f2 + W[63];
-	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1+t2;
+	t2 = e0(b) + Maj(b, c, d);    e += t1;    a = t1 + t2;
 
 	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
-- 
2.22.0

