From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Subject: [PATCHv2 0/2] Add new SEV commands
Date: Fri, 25 May 2018 15:23:28 -0500
Message-ID: <cover.1527274269.git.Janakarajan.Natarajan@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset adds two new SEV commands, introduced in SEV API v0.15
and v0.16 respectively.

* DOWNLOAD_FIRMWARE allows the SEV firmware to be updated if a blob newer
  than or similar to the exisiting build is available.

* GET_ID allows to query for a unique ID that can be used to retrieve the
  Chip Endorsment Key (CEK) public key signed by the AMD SEV Signing Key
  (ASK). 

v1->v2:
* Added cover letter.
* Misc changes based on Boris' feedback.

Janakarajan Natarajan (2):
  crypto: ccp: Add DOWNLOAD_FIRMWARE SEV command
  crypto: ccp: Add GET_ID SEV command

 drivers/crypto/ccp/psp-dev.c | 143 ++++++++++++++++++++++++++++++++++++++++---
 drivers/crypto/ccp/psp-dev.h |   4 ++
 include/linux/psp-sev.h      |  23 +++++++
 include/uapi/linux/psp-sev.h |  12 ++++
 4 files changed, 172 insertions(+), 10 deletions(-)

-- 
2.7.4
