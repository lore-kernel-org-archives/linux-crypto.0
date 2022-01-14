Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797D8C4167D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jan 2022 00:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbiANAay (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jan 2022 19:30:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiANAay (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jan 2022 19:30:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABC8DB823E5;
        Fri, 14 Jan 2022 00:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C70FC36AEB;
        Fri, 14 Jan 2022 00:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642120251;
        bh=9/XHk4RvSS656zeV4onzLM9pbNe+LNr64q6UP1/ojFk=;
        h=From:To:Cc:Subject:Date:From;
        b=XtUe/NIl2zu1Z31gD4pEN8MqcT5TspPEtx8phreKcha0rn3+4HPYaKSCfBLSETgfV
         OKjnwxQINPO/BY0UkQkVclpUOGwhhVwVC1hoKrGn8shPyGArpuAjk/MVNz+VSaXknN
         5g8CC22S4bIC8fJ3FPdpQ/qYllPOgfrxL3ynAh9av2Vedfjq93fbdDxfl66gtbVopT
         KZLyxCOgX+zrhd6Osz80mmPcXHqgPmdN25kLMhOjFnTy0DLqwG7cpQ/kERnTdW0YVp
         0vQlDHiHPl90wlL8htT+8pRk6xjp/Xbv+7W2zaNEvotNUphLB2AGDB2sLQs9qe9skp
         rnsYwqWPpZs9A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/4] KEYS: x509: various cleanups
Date:   Thu, 13 Jan 2022 16:29:16 -0800
Message-Id: <20220114002920.103858-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series cleans up a few things in the X.509 certificate parser.

Eric Biggers (4):
  KEYS: x509: clearly distinguish between key and signature algorithms
  KEYS: x509: remove unused fields
  KEYS: x509: remove never-set ->unsupported_key flag
  KEYS: x509: remove dead code that set ->unsupported_sig

 crypto/asymmetric_keys/pkcs7_verify.c     |  3 --
 crypto/asymmetric_keys/x509.asn1          |  2 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 34 ++++++++++++-----------
 crypto/asymmetric_keys/x509_parser.h      |  1 -
 crypto/asymmetric_keys/x509_public_key.c  | 18 ------------
 5 files changed, 19 insertions(+), 39 deletions(-)


base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59
-- 
2.34.1

