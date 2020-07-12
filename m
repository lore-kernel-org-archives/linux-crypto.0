Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E35C433E4
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05AAA20720
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgGLWFv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 18:05:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48300 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgGLWFu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 18:05:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F7AE1A0D0D;
        Mon, 13 Jul 2020 00:05:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 733101A0CFD;
        Mon, 13 Jul 2020 00:05:48 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0557A204BE;
        Mon, 13 Jul 2020 00:05:47 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 0/2] crypto: caam - add tagged keys functionality and tk transformations for skcipher
Date:   Mon, 13 Jul 2020 01:05:34 +0300
Message-Id: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tagged keys are keys that contain metadata indicating what
they are and how to handle them using the new added tag_object API.
A tag object represents the metadata (or simply a header/configuration)
and the actual data (e.g. black key) obtained from hardware.
Patch #2 adds support, for tagged keys, to skcipher algorithms by
adding new transformations, with tk prefix to distinguish
between plaintext and tagged keys.

The tk_ transformations can be used directly by their name:
struct sockaddr_alg sa = {
.salg_family = AF_ALG,
.salg_type = "skcipher", /* this selects the symmetric cipher /
.salg_name = "tk(cbc(aes))" / this is the cipher name */
};
or for dm-crypt, e.g. using dmsetup:
dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
sector_size:512".

tk_ transformations will know how to handle tagged keys, by loading the
proper settings for KEY command.

Iuliana Prodan (2):
  crypto: caam - add tag object functionality
  crypto: caam - support tagged keys for skcipher algorithms

 drivers/crypto/caam/Kconfig        |   9 +++
 drivers/crypto/caam/Makefile       |   1 +
 drivers/crypto/caam/caamalg.c      | 107 ++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_desc.c |  28 ++++++--
 drivers/crypto/caam/desc.h         |   4 +-
 drivers/crypto/caam/desc_constr.h  |   4 ++
 drivers/crypto/caam/tag_object.c   | 129 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/tag_object.h   |  99 ++++++++++++++++++++++++++++
 8 files changed, 372 insertions(+), 9 deletions(-)
 create mode 100644 drivers/crypto/caam/tag_object.c
 create mode 100644 drivers/crypto/caam/tag_object.h

-- 
2.1.0

