From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 0/3] xfrm: Custom truncation lengths for authentication algorithms
Date: Wed, 25 Nov 2009 11:29:50 +0100
Message-ID: <cover.1259142145.git.martin@strongswan.org>
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zaes.ch ([213.133.111.41]:55418 "EHLO zaes.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbZKYKxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2009 05:53:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patchset adds support for defining truncation lengths
for authentication algorithms in userspace. The main purpose for this
is to support SHA256 in IPsec using the standardized 128 bit
instead of the currently used 96 bit truncation.

Martin Willi (3):
  xfrm: Define new XFRM netlink auth attribute with specified
    truncation bits
  xfrm: Store aalg in xfrm_state with a user specified truncation
    length
  xfrm: Use the user specified truncation length in ESP and AH

 include/linux/xfrm.h  |    8 +++
 include/net/xfrm.h    |   12 ++++-
 net/ipv4/ah4.c        |    2 +-
 net/ipv4/esp4.c       |    2 +-
 net/ipv6/ah6.c        |    2 +-
 net/ipv6/esp6.c       |    2 +-
 net/xfrm/xfrm_state.c |    2 +-
 net/xfrm/xfrm_user.c  |  129 ++++++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 145 insertions(+), 14 deletions(-)

