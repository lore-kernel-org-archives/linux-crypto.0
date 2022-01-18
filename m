Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 407E0C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 10:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbiARKdS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:33:18 -0500
Received: from 9.mo548.mail-out.ovh.net ([46.105.48.137]:51101 "EHLO
        9.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiARKdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 05:33:12 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 05:33:12 EST
Received: from mxplan1.mail.ovh.net (unknown [10.109.143.188])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 7A8FF202AE;
        Tue, 18 Jan 2022 10:23:59 +0000 (UTC)
Received: from bracey.fi (37.59.142.101) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 11:23:58 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-101G0042346288b-dc62-4f9e-ae6f-c68d33800242,
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
Subject: [PATCH v3 0/4] arm64: accelerate crc32_be
Date:   Tue, 18 Jan 2022 12:23:47 +0200
Message-ID: <20220118102351.3356105-1-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG8EX2.mxp1.local (172.16.2.16) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 320ff225-2336-4bd6-a476-b579844d0d1c
X-Ovh-Tracer-Id: 10754314438517493865
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepueektdeiuefhueevheejudetleehudffheekffdtteegheefueeggfetudejgedunecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhdurdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepkhgvvhhinhessghrrggtvgihrdhfihdpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvghvihhnsegsrhgrtggvhidrfhhi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Originally sent only to the arm-linux list - now including linux-crypto.
Ard suggested that Herbert take the series.

This series completes the arm64 crc32 helper acceleration by adding crc32_be.

There are plenty of users, for example OF.

To compensate for the extra supporting cruft in lib/crc32.c, a couple of minor
tidies.

changes since v2:
- no code change, but sent to Herbert+crypto with Catalin's ack for arm64

changes since v1:
- assembler style fixes from Ard's review

Kevin Bracey (4):
  lib/crc32.c: remove unneeded casts
  lib/crc32.c: Make crc32_be weak for arch override
  lib/crc32test.c: correct printed bytes count
  arm64: accelerate crc32_be

 arch/arm64/lib/crc32.S | 87 +++++++++++++++++++++++++++++++++++-------
 lib/crc32.c            | 14 +++----
 lib/crc32test.c        |  2 +-
 3 files changed, 80 insertions(+), 23 deletions(-)

-- 
2.25.1

