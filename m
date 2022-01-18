Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F20C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 10:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiARKmi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:42:38 -0500
Received: from smtpout3.mo529.mail-out.ovh.net ([46.105.54.81]:45555 "EHLO
        smtpout3.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230274AbiARKmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 05:42:37 -0500
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 05:42:37 EST
Received: from mxplan1.mail.ovh.net (unknown [10.109.143.118])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 04639D86FA28;
        Tue, 18 Jan 2022 11:24:00 +0100 (CET)
Received: from bracey.fi (37.59.142.101) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 11:23:59 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-101G00401bb31b2-8a3d-400f-a362-f3edf1f5590b,
                    D2C519BAB91300E05C7E54B340BF794D215B5709) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kevin Bracey <kevin@bracey.fi>
Subject: [PATCH v3 1/4] lib/crc32.c: remove unneeded casts
Date:   Tue, 18 Jan 2022 12:23:48 +0200
Message-ID: <20220118102351.3356105-2-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118102351.3356105-1-kevin@bracey.fi>
References: <20220118102351.3356105-1-kevin@bracey.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG8EX2.mxp1.local (172.16.2.16) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 5d195ab3-7d6c-4312-bf80-12343bdd9784
X-Ovh-Tracer-Id: 10754595910225924201
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepuddvheelffeuleeugfekgeegffevudehkeefkeettdekffekjedvjeffkeevjeegnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvghvihhnsegsrhgrtggvhidrfhhi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Casts were added in commit 8f243af42ade ("sections: fix const sections
for crc32 table") to cope with the tables not being const. They are no
longer required since commit f5e38b9284e1 ("lib: crc32: constify crc32
lookup table").

Signed-off-by: Kevin Bracey <kevin@bracey.fi>
---
 lib/crc32.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 2a68dfd3b96c..7f062a2639df 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -194,13 +194,11 @@ u32 __pure __weak __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 #else
 u32 __pure __weak crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
-	return crc32_le_generic(crc, p, len,
-			(const u32 (*)[256])crc32table_le, CRC32_POLY_LE);
+	return crc32_le_generic(crc, p, len, crc32table_le, CRC32_POLY_LE);
 }
 u32 __pure __weak __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
-	return crc32_le_generic(crc, p, len,
-			(const u32 (*)[256])crc32ctable_le, CRC32C_POLY_LE);
+	return crc32_le_generic(crc, p, len, crc32ctable_le, CRC32C_POLY_LE);
 }
 #endif
 EXPORT_SYMBOL(crc32_le);
@@ -339,8 +337,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 #else
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
-	return crc32_be_generic(crc, p, len,
-			(const u32 (*)[256])crc32table_be, CRC32_POLY_BE);
+	return crc32_be_generic(crc, p, len, crc32table_be, CRC32_POLY_BE);
 }
 #endif
 EXPORT_SYMBOL(crc32_be);
-- 
2.25.1

