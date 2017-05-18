From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/4] crypto: async crypto op fixes
Date: Thu, 18 May 2017 14:26:42 +0300
Message-ID: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch set fixes various usage and documentation errors
in waiting for async crypto op to complete which can result
in data corruption.

Note: these were discovered in the process of working on a
patch set that replaces these call sites and more with a
generic implementation that will prevent these problems
going forward. These are just the fix ups for current code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: stable@vger.kernel.org
CC: Eric Biggers <ebiggers3@gmail.com>

Gilad Ben-Yossef (4):
  crypto: handle EBUSY due to backlog correctly
  crypto: drbg wait for crypto op not signal safe
  crypto: gcm wait for crypto op not signal safe
  crypto: Documentation: fix none signal safe sample

Changes from v1:
- Fix a brown paper bug compile error due to bad git rebase squashing

 Documentation/crypto/api-samples.rst | 2 +-
 crypto/asymmetric_keys/public_key.c  | 2 +-
 crypto/drbg.c                        | 5 ++---
 crypto/gcm.c                         | 6 ++----
 4 files changed, 6 insertions(+), 9 deletions(-)

-- 
2.1.4
