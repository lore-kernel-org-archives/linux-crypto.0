Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28BFC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82047247B4
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540500;
	bh=DVVRgzvHhp0k9HGT9E6RwM+fmkPorW5IgIeEOkCSJo4=;
	h=From:To:Subject:Date:List-ID:From;
	b=kBDnZgSQqww/itCWwRwjhuDf1qrKoweX5wzCfP4N3GtzEyRtn1mXKCoiEQm8xAayO
	 rrJUiHL4l+3DKseHhlBFYE2n1Ez+44Z3Yw5wWJRBzOJXnnlIodpQWRA+hl2S/WaL2M
	 PN48O+2WA6f/X0Jgx/2m2Q4pxQhNk+xIk73p0uZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFCFlj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbfFCFlj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:41:39 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABFF7247B4
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540498;
        bh=DVVRgzvHhp0k9HGT9E6RwM+fmkPorW5IgIeEOkCSJo4=;
        h=From:To:Subject:Date:From;
        b=ItmNaEPPx0mmVkqFOVC322Knw1tGLj1uG4Noq2FUS0Q2sCfhdNYVDQsqzv1Tt3Qay
         R8ix+UkzvCDjkWamswSYbyA/MbHrO6NPW9dZA4qYAtPVpWxpabUloal+VuaBc50/7L
         umajVKj40sa1omEMjbWfpXDFDUYvB7ug7fa+HQVc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] crypto: make cra_driver_name mandatory
Date:   Sun,  2 Jun 2019 22:40:56 -0700
Message-Id: <20190603054058.5449-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Most generic crypto algorithms declare a driver name ending in
"-generic".  The rest don't declare a driver name and instead rely on
the crypto API automagically appending "-generic" upon registration.

Having multiple conventions is unnecessarily confusing and makes it
harder to grep for all generic algorithms in the kernel source tree.
But also, allowing NULL driver names is problematic because sometimes
people fail to set it, e.g. the case fixed by commit 417980364300
("crypto: cavium/zip - fix collision with generic cra_driver_name").

Of course, people can also incorrectly name their drivers "-generic".
But that's much easier to notice / grep for.

Therefore, let's make cra_driver_name mandatory.  Patch 1 gives all
generic algorithms an explicit cra_driver_name, and Patch 2 makes
cra_driver_name required for algorithm registration.

Eric Biggers (2):
  crypto: make all generic algorithms set cra_driver_name
  crypto: algapi - require cra_name and cra_driver_name

 crypto/algapi.c          | 22 ++++------------------
 crypto/anubis.c          |  1 +
 crypto/arc4.c            |  2 ++
 crypto/crypto_null.c     |  3 +++
 crypto/deflate.c         |  1 +
 crypto/fcrypt.c          |  1 +
 crypto/khazad.c          |  1 +
 crypto/lz4.c             |  1 +
 crypto/lz4hc.c           |  1 +
 crypto/lzo-rle.c         |  1 +
 crypto/lzo.c             |  1 +
 crypto/md4.c             |  7 ++++---
 crypto/md5.c             |  7 ++++---
 crypto/michael_mic.c     |  1 +
 crypto/rmd128.c          |  1 +
 crypto/rmd160.c          |  1 +
 crypto/rmd256.c          |  1 +
 crypto/rmd320.c          |  1 +
 crypto/serpent_generic.c |  1 +
 crypto/tea.c             |  3 +++
 crypto/tgr192.c          | 21 ++++++++++++---------
 crypto/wp512.c           | 21 ++++++++++++---------
 crypto/zstd.c            |  1 +
 23 files changed, 59 insertions(+), 42 deletions(-)

-- 
2.21.0

