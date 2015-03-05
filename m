From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 0/17] crypto: talitos - Add support for SEC1
Date: Thu,  5 Mar 2015 17:46:05 +0100 (CET)
Message-ID: <20150305164605.E65D81A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:48201 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbbCEQqW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 11:46:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The purpose of this set of patchs is to add to talitos crypto driver the
support for the SEC1 version of the security engine, which is found in
mpc885 and mpc8272 processors.

The approach has been to split the driver in two main parts:
* talitos.c and talitos.h contains parts that are common
* talitos2.c and talitos2.h contains specificities of SEC2

Then
* talitos1.c and talitos1.h has been created with SEC1 specificities

Patchset:
[01/17] crypto: talitos - base address for Execution Units and macro for ISR masks
[02/17] crypto: talitos - Externalise specific SEC2 reset actions
[03/17] crypto: talitos - Use zero entry to init descriptors ptrs to zero
[04/17] crypto: talitos - Refactor the sg in/out chain allocation
[05/17] crypto: talitos - isolate scatter/gather handling for ahash
[06/17] crypto: talitos - Add talitos2.c to isolate SEC2 specific functions
[07/17] crypto: talitos - Split talitos.h into 2 parts
[08/17] crypto: talitos - Deport SEC2 error handling
[09/17] crypto: talitos - Move reset/init helpers into talitos2.h
[10/17] crypto: talitos - Move interrupt related macros in talitos2.h
[11/17] crypto: talitos - Move hash chain handling into talitos2.h
[12/17] crypto: talitos - Define compatible in talitos2.h instead of talitos.c
[13/17] crypto: talitos - move sg_count() helper into talitos.h
[14/17] crypto: talitos - Add a helper function to clear j_extent field
[15/17] crypto: talitos - Implementation of SEC1
[16/17] crypto: talitos - SEC1 bugs on 0 data hash
[17/17] crypto: talitos - Update DT bindings with SEC1

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

 .../devicetree/bindings/crypto/fsl-sec2.txt        |   5 +-
 drivers/crypto/Kconfig                             |   8 +
 drivers/crypto/Makefile                            |   2 +
 drivers/crypto/talitos.c                           | 927 +--------------------
 drivers/crypto/talitos.h                           | 185 ++--
 drivers/crypto/talitos1.c                          | 197 +++++
 drivers/crypto/talitos1.h                          | 343 ++++++++
 drivers/crypto/talitos2.c                          | 696 ++++++++++++++++
 drivers/crypto/talitos2.h                          | 335 ++++++++
 9 files changed, 1736 insertions(+), 962 deletions(-)
