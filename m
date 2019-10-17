Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97346FA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DD820872
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPxVmQA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436713AbfJQQwN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:52:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39212 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394354AbfJQQwN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 12:52:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so3266981wml.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 09:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1bX+3HM93tLnowX2ISvXv03lcGckunVPJQKIvzKQp1A=;
        b=LPxVmQA3Fz0BNkYIPzVzo3yAdj72gD59ZltqvE8NKDKbs2ijmQrfTRvv4ImnipupSp
         kLVxBI+0iYcydBsJfJYNIaf5E3rRFSlmvVnTnnfYSUiMMEd67aTbI2qF71CrW3g5QNrd
         e9WoaM7A2OlrRPDB5dp69VXOpI7iUYP71+YpeL8zz3fxB014CZ3tZ9VjkPohZZ9am6MB
         2UZJPXzzxdlXKLCAXlG3dHAc6lW7kR/spe9fJ9gEoQlJpKlUXorIM8lBWgPjIwVaVzyn
         vnD4PvdS9fiem8hbzeSqKZlieBQIcD36pqjjKUW3Iy11l9CGJYIQ6FzA1vhvZa0rtscO
         Nk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1bX+3HM93tLnowX2ISvXv03lcGckunVPJQKIvzKQp1A=;
        b=HbEcBQ+62dL0unOqPKmQ0rLmfcpWas6uTNifhRDgkr5jLhFcYdubXrBDhsbrqocE9G
         zRytzxqFtM2hrjk6Ej7jgoF8N1tEGp6HyEhsJKwK5syptA5paxwllFqkOci7G5nxRavX
         F8pWWjNRUBNWHjrQWIaqdKqbD0ONn7Ky01rmf7axNuppZ9C/lyi28I4iUkjCUvX859WB
         FjeE5Brb/Nr+AvQGJsz/zxg+SCnCSl4D3Je2PRkv5RSRbe4lZ5A4KWTXyt/rQPFkgxRA
         sWivXKSrpaLKCpedmG4Rbigt5BuXvSKE+2TUtKVnKFxZ2vOGNHyD2e2ioYcY2RHO5xk/
         UmdQ==
X-Gm-Message-State: APjAAAWIYYn6KAXyu23X4VvZdI5u6LFItFcGHStF/h6dgojqV/g48oY7
        Zco0Bxwgvo7BdJWosOD85KxG59hM
X-Google-Smtp-Source: APXvYqx2+pFUf/3+415DoftbXZ80RBwGqNK/XKxiiRXeVSq/W0wTkuYn8JQFF2B435/V+ZDCO6ijsg==
X-Received: by 2002:a1c:a9c8:: with SMTP id s191mr3458705wme.74.1571331130883;
        Thu, 17 Oct 2019 09:52:10 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id t11sm2627092wmi.25.2019.10.17.09.52.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 09:52:10 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Made locally used safexcel_pci_remove() static
Date:   Thu, 17 Oct 2019 17:49:09 +0200
Message-Id: <1571327349-31138-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

safexcel_pci_remove() is only used locally in the module and not exported,
so added a static function specifier.
This fixes a sparse issue reported by Ben Dooks.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5342ba6..e5f2bd7 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1880,7 +1880,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 	return rc;
 }
 
-void safexcel_pci_remove(struct pci_dev *pdev)
+static void safexcel_pci_remove(struct pci_dev *pdev)
 {
 	struct safexcel_crypto_priv *priv = pci_get_drvdata(pdev);
 	int i;
-- 
1.8.3.1

