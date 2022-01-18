Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D2EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 10:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiARKdT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:33:19 -0500
Received: from 1.mo552.mail-out.ovh.net ([178.32.96.117]:40631 "EHLO
        1.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiARKdQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 05:33:16 -0500
Received: from mxplan1.mail.ovh.net (unknown [10.109.138.7])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 6219220A98;
        Tue, 18 Jan 2022 10:24:02 +0000 (UTC)
Received: from bracey.fi (37.59.142.101) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 11:24:01 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-101G00422ebdaad-1421-4dc3-990c-2f283ada41cf,
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
Subject: [PATCH v3 3/4] lib/crc32test.c: correct printed bytes count
Date:   Tue, 18 Jan 2022 12:23:50 +0200
Message-ID: <20220118102351.3356105-4-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118102351.3356105-1-kevin@bracey.fi>
References: <20220118102351.3356105-1-kevin@bracey.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG8EX2.mxp1.local (172.16.2.16) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: c4daa560-dddf-4362-a740-0c1b5b5e7db4
X-Ovh-Tracer-Id: 10755158860178821225
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepuddvheelffeuleeugfekgeegffevudehkeefkeettdekffekjedvjeffkeevjeegnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvghvihhnsegsrhgrtggvhidrfhhi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crc32c_le self test had a stray multiply by two inherited from
the crc32_le+crc32_be test loop.

Signed-off-by: Kevin Bracey <kevin@bracey.fi>
---
 lib/crc32test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crc32test.c b/lib/crc32test.c
index 61ddce2cff77..9b4af79412c4 100644
--- a/lib/crc32test.c
+++ b/lib/crc32test.c
@@ -675,7 +675,7 @@ static int __init crc32c_test(void)
 
 	/* pre-warm the cache */
 	for (i = 0; i < 100; i++) {
-		bytes += 2*test[i].length;
+		bytes += test[i].length;
 
 		crc ^= __crc32c_le(test[i].crc, test_buf +
 		    test[i].start, test[i].length);
-- 
2.25.1

