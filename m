Return-Path: <SRS0=/kEc=EJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01F8C2D0A3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 12:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5724022264
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 12:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgKCMPT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Nov 2020 07:15:19 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7134 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgKCMPT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Nov 2020 07:15:19 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CQTJ21W5Tz15R2V;
        Tue,  3 Nov 2020 20:15:14 +0800 (CST)
Received: from huawei.com (10.110.54.32) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Tue, 3 Nov 2020
 20:15:08 +0800
From:   l00374334 <liqiang64@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <liqiang64@huawei.com>
Subject: [PATCH 0/1] arm64: Accelerate Adler32 using arm64 SVE instructions.
Date:   Tue, 3 Nov 2020 20:15:05 +0800
Message-ID: <20201103121506.1533-1-liqiang64@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: liqiang <liqiang64@huawei.com>

Dear all,

Thank you for taking the precious time to read this email!

Let me introduce the implementation ideas of my code here.

In the process of using the compression library libz, I found that the adler32
checksum always occupies a higher hot spot, so I paid attention to this algorithm.
After getting in touch with the SVE instruction set of armv8, I realized that
SVE can effectively accelerate adler32, so I made some attempts and got correct
and better performance results. I very much hope that this modification can be
applied to the kernel.

Below is my analysis process:

Adler32 algorithm
=================

Reference: https://en.wikipedia.org/wiki/Adler-32

Assume that the buf of the Adler32 checksum to be calculated is D and the length is n:

        A = 1 + D1 + D2 + ... + Dn (mod 65521)

        B = (1 + D1) + (1 + D1 + D2) + ... + (1 + D1 + D2 + ... + Dn) (mod 65521)
          = n×D1 + (n−1)×D2 + (n−2)×D3 + ... + Dn + n (mod 65521)

        Adler-32(D) = B × 65536 + A

In C, an inefficient but straightforward implementation is:

        const uint32_t MOD_ADLER = 65521;

        uint32_t adler32(unsigned char *data, size_t len)
        {
                uint32_t a = 1, b = 0;
                size_t index;

                // Process each byte of the data in order
                for (index = 0; index < len; ++index)
                {
                        a = (a + data[index]) % MOD_ADLER;
                        b = (b + a) % MOD_ADLER;
                }

                return (b << 16) | a;
        }

SVE vector method
=================

Step 1. Determine the block size:
        Use addvl instruction to get SVE bit width.
        Assuming the SVE bit width is x here.

Step 2. Start to calculate the first block:
        The calculation formula is:
                A1 = 1 + D1 + D2 + ... + Dx (mod 65521)
                B1 = x*D1 + (x-1)*D2 + ... + Dx + x (mod 65521)

Step 3. Calculate the follow block:
        The calculation formula of A2 is very simple, just add up:
                A2 = A1 + Dx+1 + Dx+2 + ... + D2x (mod 65521)

        The calculation formula of B2 is more complicated, because
        the result is related to the length of buf. When calculating
        the B1 block, it is actually assumed that the length is the
        block length x. Now when calculating B2, the length is expanded
        to 2x, so B2 becomes:
                B2 = 2x*D1 + (2x-1)*D2             + ... + (x+1)*Dx + x*D(x+1) + ... + D2x + 2x
                   = x*D1 + x*D1 + x*D2 + (x-1)*D2 + ... + x*Dx + Dx + x*1 + x + [x*D(x+1) + (x-1)*D(x+2) + ... + D2x]
                     ^^^^   ~~~~   ^^^^   ~~~~~~~~         ^^^^   ~~   ^^^   ~   +++++++++++++++++++++++++++++++++++++
        Through the above polynomial transformation:
                Symbol "^" represents the <x * A1>;
                Symbol "~" represents the <B1>;
                Symbol "+" represents the next block.

        So we can get the method of calculating the next block from
        the previous block(Assume that the first byte number of the
        new block starts from 1):
                An+1 = An + D1 + D2 + ... + Dx (mod 65521)
                Bn+1 = Bn + x*An + x*D1 + (x-1)*D2 + ... + Dx (mod 65521)

Step 4. Implement and test with SVE instruction set:
        Implement the above ideas with the SVE instruction set (Please refer
        to the patch for details), and conduct correctness and performance tests.

        The following are three sets of test data, the test objects are random
        data of 1M, 10M, 100M:
                [root@xxx adler32]# ./benchmark 1000000
                Libz alg: Time used:    615 us, 1626.0 Mb/s.
                SVE  alg: Time used:    163 us, 6135.0 Mb/s.
                Libz result: 0x7a6a200
                Sve  result: 0x7a6a200
                Equal

                [root@xxx adler32]# ./benchmark 10000000
                Libz alg: Time used:   6486 us, 1541.8 Mb/s.
                SVE  alg: Time used:   2077 us, 4814.6 Mb/s.
                Libz result: 0xf92a8b92
                Sve  result: 0xf92a8b92
                Equal

                [root@xxx adler32]# ./benchmark 100000000
                Libz alg: Time used:  64352 us, 1554.0 Mb/s.
                SVE  alg: Time used:  20697 us, 4831.6 Mb/s.
                Libz result: 0x295bf401
                Sve  result: 0x295bf401
                Equal
	Test environment: Taishan 1951.

        The test results show that on Taishan 1951, the speed of SVE is generally
        about 3 to 4 times that of the C algorithm.

liqiang (1):
  Accelerate Adler32 using arm64 SVE instructions.

 arch/arm64/crypto/Kconfig            |   5 ++
 arch/arm64/crypto/Makefile           |   3 +
 arch/arm64/crypto/adler32-sve-glue.c |  93 ++++++++++++++++++++
 arch/arm64/crypto/adler32-sve.S      | 127 +++++++++++++++++++++++++++
 crypto/testmgr.c                     |   8 +-
 crypto/testmgr.h                     |  13 +++
 6 files changed, 248 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/crypto/adler32-sve-glue.c
 create mode 100644 arch/arm64/crypto/adler32-sve.S

-- 
2.19.1

