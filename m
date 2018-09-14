From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: [PATCH 0/2] Miscellaneous SEV fixes
Date: Fri, 14 Sep 2018 17:32:02 -0500
Message-ID: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The first patch provides a fix for a static checker warning.

The second patch allows for the SEV firmware blob, which will
be searched for when updating SEV during PSP initialization,
to be named based on the family and model of the processor.

Janakarajan Natarajan (2):
  Fix static checker warning
  Allow SEV firmware to be chosen based on Family and Model

 drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

-- 
2.7.4
