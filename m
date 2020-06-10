Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C6AC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 00:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922D22078D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 00:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591750664;
	bh=uzmWQ37bKQDMUkQ25i+1+Gv0eF+nsjPtHVc2DRidLhs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FxImRnHjcYI6ZRn9gwiB/TskPuqg/v1N1fqK1JtDSKNxe29UUqdUTS17inoNwPoGX
	 j7lmYYKaB+1RXyQRbEiNaH+wVHdXZ9IDTlQYfq1XW6Oi0KcRc/CCJZSi057aq3EyuR
	 aVX9fCV7B7/P5hJnyUnB7mQlsN7X8mz86vgeha+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFJA5o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jun 2020 20:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJA5n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jun 2020 20:57:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43493206C3;
        Wed, 10 Jun 2020 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591750663;
        bh=uzmWQ37bKQDMUkQ25i+1+Gv0eF+nsjPtHVc2DRidLhs=;
        h=From:To:Cc:Subject:Date:From;
        b=Jow4cysVNWJRRZ7YMmlYUGeJMM5IK+www9hXpfLsanve9C53WrbLhwFe3OsAkT3nU
         8jmPnwWyL3FPDQ9TJZxzP7nIgvvCKMVO4cLLjucFF9nd9B4H0eDVTwxDIMao96zp6a
         PRRXUrdfM5WQ3Eq6LoF5dGfYGFSYi/mQe14qGLZg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v3 0/3] esp, ah: improve crypto algorithm selections
Date:   Tue,  9 Jun 2020 17:53:59 -0700
Message-Id: <20200610005402.152495-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series consolidates and modernizes the lists of crypto algorithms
that are selected by the IPsec kconfig options, and adds CRYPTO_SEQIV
since it no longer gets selected automatically by other things.

See previous discussion at
https://lkml.kernel.org/netdev/20200604192322.22142-1-ebiggers@kernel.org/T/#u

Eric Biggers (3):
  esp, ah: consolidate the crypto algorithm selections
  esp: select CRYPTO_SEQIV
  esp, ah: modernize the crypto algorithm selections

 net/ipv4/Kconfig | 37 +++++++++++++++++++++----------------
 net/ipv6/Kconfig | 37 +++++++++++++++++++++----------------
 net/xfrm/Kconfig | 24 ++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 32 deletions(-)


base-commit: 8027bc0307ce59759b90679fa5d8b22949586d20
-- 
2.26.2

