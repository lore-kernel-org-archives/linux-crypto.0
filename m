From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 0/2] padata fixes
Date: Fri, 9 Mar 2012 07:18:28 +0100
Message-ID: <20120309061828.GI15404@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56864 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2CIGSc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Mar 2012 01:18:32 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset fixes two races that I found when I tested padata
in combination with pcrypt ablkcipher algorithms (still unpublished)
and dm-crypt. The mainline codebase seems not to trigger them, however
we need to fix these races before I can push the pcrypt ablkcipher
extensions.

The patchset is based on the crypto-2.6 tree and is also available via git:

The following changes since commit f8f54e190ddb4ed697036b60f5e2ae6dd45b801c:
  Phil Sutter (1):
        crypto: mv_cesa - fix final callback not ignoring input data

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-stk padata-fixes

Steffen Klassert (2):
      padata: Fix race in the serialization path
      padata: Fix race on sequence number wrap

 include/linux/padata.h |    6 ++----
 kernel/padata.c        |   44 ++++++++++++++------------------------------
 2 files changed, 16 insertions(+), 34 deletions(-)
