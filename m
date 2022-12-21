Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B84C4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 22:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiLUWmN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiLUWmM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 17:42:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBADE86
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 14:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671662485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bLYZMh2LR87CuiMLuCzUcuWCtKa8d3kE51+MQe3QUCA=;
        b=ZhivPbmSUHORMBSJYENzQsavQ5rz2oBZnMqoRCdhMlEJNQqNkAduBH73UokXt6vXhY4Daz
        H4N8l++asjM9e+dT5NK+tPDLqLm5I+gq4stwR8hqiaN5rkE9p636a5Ym7GYENdjqDeEmUt
        Ue6INSZCqNoGntmAXF6t8PrdrjPua+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-ETNqCoCEOIag41ARSFnPAA-1; Wed, 21 Dec 2022 17:41:24 -0500
X-MC-Unique: ETNqCoCEOIag41ARSFnPAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20F638F6E81;
        Wed, 21 Dec 2022 22:41:24 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-208-11.brq.redhat.com [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04A1240C2004;
        Wed, 21 Dec 2022 22:41:21 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     nstange@suse.de, elliott@hpe.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, smueller@chronox.de,
        vdronov@redhat.com
Subject: [PATCH 0/6] Trivial set of FIPS 140-3 related changes
Date:   Wed, 21 Dec 2022 23:41:05 +0100
Message-Id: <20221221224111.19254-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This patchset and cover letter was initially composed by Nicolai Stange
and sent earlier as:

https://lore.kernel.org/all/20221108142025.13461-1-nstange@suse.de/
with a subject: [PATCH 0/4] Trivial set of FIPS 140-3 related changes

I'm adding patches 2 and 3 which (I hope) resolve issues spotted by
reviewers of previous version of the patchset. This new patchset should
ease our future kernel work on the FIPS mode.

I'm quoting Nicolai's cover letter here:

> Hi all,
> 
> these four rather unrelated patches are basically a dump of some of the
> more trivial changes required for working towards FIPS 140-3 conformance.
> 
> Please pick as you deem appropriate.
> 
> Thanks!
> 
> Nicolai

Nicolai Stange (4):
  crypto: xts - restrict key lengths to approved values in FIPS mode
  crypto: testmgr - disallow plain cbcmac(aes) in FIPS mode
  crypto: testmgr - disallow plain ghash in FIPS mode
  crypto: testmgr - allow ecdsa-nist-p256 and -p384 in FIPS mode

Vladis Dronov (2):
  crypto: xts - drop xts_check_key()
  crypto: xts - drop redundant xts key check

 arch/s390/crypto/aes_s390.c                        |  4 ----
 arch/s390/crypto/paes_s390.c                       |  2 +-
 crypto/testmgr.c                                   |  4 ++--
 drivers/crypto/atmel-aes.c                         |  2 +-
 drivers/crypto/axis/artpec6_crypto.c               |  2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  8 +++-----
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |  8 +++-----
 drivers/crypto/ccree/cc_cipher.c                   |  2 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |  2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |  2 +-
 include/crypto/xts.h                               | 24 ++++++++----------------
 11 files changed, 22 insertions(+), 38 deletions(-)


