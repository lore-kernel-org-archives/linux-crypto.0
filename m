Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FC9C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8029964EBA
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBASDh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBASDg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:03:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A707A64E97;
        Mon,  1 Feb 2021 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202575;
        bh=5bmG3DrObbBsorygQbM4OMpUSRXQja88+z5HvrThGlI=;
        h=From:To:Cc:Subject:Date:From;
        b=d8mt8oBpHLZCkTpy4/xU1phLJjOtHgxmtKR954M4bZq5v+HjLNfhckYIrz+nqSqXp
         I6tAIN3MdWBjF0GgkbIELyYhXFn0Ny9p2FeZ5aStt/7IiUA7XRLM9UE7odrjkQionj
         FA3zuWK1WpVBcldtumnwLT/ZH3es5ZWTiEmwj78TS1Lq93lDHryeYY2dLVULq409JJ
         wJ9+z3t1xzesBYtlfw/hjs0EtTANmJEchIiR4rHOIzFeHyn/XsRdiNH9r3Q5KnNnCw
         Gfcl1IsG6fjNovLLh3ueGPxEWgmXXMlO6GXnfGhDhW9SmDxL1Dny5TzZReFoZgojsj
         xaxVwahIAvR3g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/9] crypto: fix alignmask handling
Date:   Mon,  1 Feb 2021 19:02:28 +0100
Message-Id: <20210201180237.3171-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some generic implementations of vintage ciphers rely on alignmasks to
ensure that the input is presented with the right alignment. Given that
these are all C implementations, which may execute on architectures that
don't care about alignment in the first place, it is better to use the
unaligned accessors, which will deal with the misalignment in a way that
is appropriate for the architecture in question (and in many cases, this
means simply ignoring the misalignment, as the hardware doesn't care either)

So fix this across a number of implementations. Patch #1 stands out because
michael_mic.c was broken in spite of the alignmask. Patch #2 removes tnepres
instead of updating it, given that there is no point in keeping it.

The remaining patches all update generic ciphers that are outdated but still
used, and which are the only implementations available on most architectures
other than x86.



Ard Biesheuvel (9):
  crypto: michael_mic - fix broken misalignment handling
  crypto: serpent - get rid of obsolete tnepres variant
  crypto: serpent - use unaligned accessors instead of alignmask
  crypto: blowfish - use unaligned accessors instead of alignmask
  crypto: camellia - use unaligned accessors instead of alignmask
  crypto: cast5 - use unaligned accessors instead of alignmask
  crypto: cast6 - use unaligned accessors instead of alignmask
  crypto: fcrypt - drop unneeded alignmask
  crypto: twofish - use unaligned accessors instead of alignmask

 crypto/Kconfig            |   3 +-
 crypto/blowfish_generic.c |  23 ++--
 crypto/camellia_generic.c |  45 +++----
 crypto/cast5_generic.c    |  23 ++--
 crypto/cast6_generic.c    |  39 +++---
 crypto/fcrypt.c           |   1 -
 crypto/michael_mic.c      |  31 ++---
 crypto/serpent_generic.c  | 126 ++++----------------
 crypto/tcrypt.c           |   6 +-
 crypto/testmgr.c          |   6 -
 crypto/testmgr.h          |  79 ------------
 crypto/twofish_generic.c  |  11 +-
 12 files changed, 90 insertions(+), 303 deletions(-)

-- 
2.20.1

