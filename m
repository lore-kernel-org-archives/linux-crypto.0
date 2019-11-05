Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DCFC5DF60
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8714021929
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuNZZTJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfKEPOA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:00 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39364 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389081AbfKEPOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:00 -0500
Received: by mail-pl1-f193.google.com with SMTP id o9so2897419plk.6;
        Tue, 05 Nov 2019 07:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueZjgo8+zOkBauD4syvKmnkDBEqPzkBVA/a+VdiSjDw=;
        b=kuNZZTJcNLgaWQTve3cK09G/lqOeyYrYJtHRrQ3800fNtTWOiIdaz0idiGPul69EUO
         RuFDZY5FDw4Di7RLTDQR1u6ZYOpIJAwDcoQfy9VlX9Ll1ODjmnF5gCVA0aoPw7t/Km1q
         w88PKwQc9PBNT+NGEtALv58QjefQFFX+TMwnkXzuC4zpVeGOOvfFkQYQeA1iQYJRvCau
         vjo2Vvq96GG5Q92xEAb9dIZFX0ngDwL3yMP5NwqZmf1AhFZ0iFIzhFXB09X5gYfGr9Vz
         X5eO45OzF/XFte/FZq5ZILN6hA/S3ef/VKQGmulQH5rt9H8i3PyzFUOpikGrUC641uZD
         GrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueZjgo8+zOkBauD4syvKmnkDBEqPzkBVA/a+VdiSjDw=;
        b=gR1tDLtBW5MOo6JImDLHiKa3VmZcL9NhSMPvlvI6m5D8oWERos9OGzCMWRdt0Q+CgM
         HpvxpCRbmw6ge6kHgNWl4Vlbtj/W+rhkTQZxonhu1hlmrCn1K9WQxVxlfgszVj7pd5YS
         Om4jB9MrZbA0sh84ll1/wef7SebjYvBIraWoL34OKC5k+GDqidTzgfvYgLP9F3irPxrd
         SiJ4oytuiVU/uBtrEWs25z2vCZCFxjcl5XnvuEkNRrEpvMYiyyOPpO8o5rYVWMo650FY
         LeI6r1CrtmueTi03xZ524md70ZwKpUWrCfkbxxkiPz+W9BQXDD7iquHcMpjEpb8DshGB
         l2jw==
X-Gm-Message-State: APjAAAXra/3gMH7og+db6z9BUjQ4isc3iGOAx4FSsPTAhi+Idw6oHqXg
        NjlcabBJW//zBQqHD6FMKT3WMKOd
X-Google-Smtp-Source: APXvYqwcpniO4fZCapUOY4bl/qECba5DWb8wN8JNSRCjGZBIixg3iI1rt8hvWkEkQ0vXDcwnJNUjqg==
X-Received: by 2002:a17:902:a584:: with SMTP id az4mr32907766plb.74.1572966837627;
        Tue, 05 Nov 2019 07:13:57 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:13:56 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] CAAM JR lifecycle
Date:   Tue,  5 Nov 2019 07:13:48 -0800
Message-Id: <20191105151353.6522-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Everyone:

This series is a different approach to addressing the issues brought
up in [discussion]. This time the proposition is to get away from
creating per-JR platfrom device, move all of the underlying code into
caam.ko and disable manual binding/unbinding of the CAAM device via
sysfs. Note that this series is a rough cut intented to gauge if this
approach could be acceptable for upstreaming.

Thanks,
Andrey Smirnov

[discussion] lore.kernel.org/lkml/20190904023515.7107-13-andrew.smirnov@gmail.com

Andrey Smirnov (5):
  crypto: caam - use static initialization
  crypto: caam - introduce caam_jr_cbk
  crypto: caam - convert JR API to use struct caam_drv_private_jr
  crypto: caam - do not create a platform devices for JRs
  crypto: caam - disable CAAM's bind/unbind attributes

 drivers/crypto/caam/Kconfig      |   5 +-
 drivers/crypto/caam/Makefile     |  15 +--
 drivers/crypto/caam/caamalg.c    | 114 ++++++++++----------
 drivers/crypto/caam/caamalg_qi.c |  12 +--
 drivers/crypto/caam/caamhash.c   | 117 +++++++++++----------
 drivers/crypto/caam/caampkc.c    |  67 ++++++------
 drivers/crypto/caam/caampkc.h    |   2 +-
 drivers/crypto/caam/caamrng.c    |  41 ++++----
 drivers/crypto/caam/ctrl.c       |  16 ++-
 drivers/crypto/caam/intern.h     |   3 +-
 drivers/crypto/caam/jr.c         | 173 ++++++++-----------------------
 drivers/crypto/caam/jr.h         |  14 ++-
 drivers/crypto/caam/key_gen.c    |  11 +-
 drivers/crypto/caam/key_gen.h    |   5 +-
 14 files changed, 275 insertions(+), 320 deletions(-)

-- 
2.21.0

