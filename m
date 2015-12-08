From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/4] crypto: add precalculated hash for zero message length
Date: Tue,  8 Dec 2015 09:10:49 +0100
Message-ID: <1449562253-13846-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	geert+renesas@glider.be, herbert@gondor.apana.org.au,
	luis@debethencourt.com, maxime.ripard@free-electrons.com,
	thomas.lendacky@amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35270 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbbLHIK5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2015 03:10:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

Some crypto drivers cannot process empty data message and so rely on
precalculated hash.
This patch series add precalculated hash in headers and
make the drivers use them.

Using those precalculated hash make some additionnal constify patch necessary.

Changes since v1
- Moved arrays from headers to c file and made them EXPORT.

LABBE Corentin (4):
  crypto: hash: add zero length message hash for shax and md5
  crypto: niagara: Use precalculated hash from headers
  crypto: ccp: Use precalculated hash from headers
  crypto: ux500: Use precalculated hash from headers

 crypto/md5.c                          |  6 ++++++
 crypto/sha1_generic.c                 |  7 +++++++
 crypto/sha256_generic.c               | 16 ++++++++++++++
 drivers/crypto/ccp/ccp-ops.c          | 39 +++++++----------------------------
 drivers/crypto/n2_core.c              | 33 ++++++-----------------------
 drivers/crypto/ux500/hash/hash_core.c | 20 ++----------------
 include/crypto/md5.h                  |  2 ++
 include/crypto/sha.h                  |  6 ++++++
 8 files changed, 53 insertions(+), 76 deletions(-)

-- 
2.4.10
