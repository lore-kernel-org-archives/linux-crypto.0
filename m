Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2647C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 653872075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QmhkIzKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfBVKH0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:07:26 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52308 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfBVKH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 05:07:26 -0500
Received: by mail-wm1-f52.google.com with SMTP id m1so1414639wml.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 02:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ndehm7kh1SOeSX5cKQtZIvRTlmFL28tWfrdvG/9toFM=;
        b=QmhkIzKJNzL7l/xV6Hf479njKflusUTSk8o0Wdx6hKrX6BWBj6cWe6KIAqdGnsltvS
         rc/he8qEn+WIOzZZ6mu0iRiXSH4hR1IyC9wUtU5xtz8NI0HeVZe7mLSQ0AMiscVj6F5t
         6i4379SqzaQMIUDP0daE+yAswzNW4yz110JJ0atunHLCLsmH7vrLGzwUMA+WE+NnEOMY
         izrkVxJ6GESCJhLvNbLwPwvf40JRrqxmzC4+sbEkSNvQMUbLfr4FBASsyKJze8X9Wbxz
         i3EWuxGy5Nx/vYijjkUUN6lueBWXJJ1mrkzNsIK8ga4DWHZ1sYy+X3lqVvU4oaBYsgpk
         KNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ndehm7kh1SOeSX5cKQtZIvRTlmFL28tWfrdvG/9toFM=;
        b=X84zcsCjuj8B0SMSY4R+NoMdc38R2jV3XCDHGlzI7UNYKrU53DNcw+YJqlzFUt7qiB
         3wZhBsAH64iMOpcwM25GFZ0Gl7dVPiwC+ws406+LwED8zogYm9MgSK43RIJKxME2SWum
         clc8Zmi10PP7AoMZLQxgBmojcJ2mV2/nbq59eOKwTjLirBRxL0bqL+lYrMdRfor5LzvS
         qArrrjuDgskInruiCKLIrgHQDHFDhMPdzGoffabvDRtib2QILLySsJgIJFPc4HjT/0WJ
         Ni2bKkiWb8TtZ70eaHMgZE+v5JsgkUS6rZHeBK1IJL7j2zcJ6lVJZpIu/0E58t27Xd6E
         BVmA==
X-Gm-Message-State: AHQUAua1v1eZohYygtpi45Rok9wrP0Ax03VeHWdhULHq4aXphnwEJFwn
        7TdMaQc/1YkFE/i6NfYnNTE=
X-Google-Smtp-Source: AHgI3IaBmCoFdaTnPmiKsNKBbMryu6LHpDcXmpa/RgkV16jf0AjOAW05muOOW2fhBF4uFf2JJv6Qrg==
X-Received: by 2002:a1c:4301:: with SMTP id q1mr1929190wma.44.1550830043980;
        Fri, 22 Feb 2019 02:07:23 -0800 (PST)
Received: from roadflow-linux-dev.dtes.tfl.gov.uk (host81-149-116-186.in-addr.btopenworld.com. [81.149.116.186])
        by smtp.gmail.com with ESMTPSA id j41sm2094240wre.9.2019.02.22.02.07.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:07:23 -0800 (PST)
From:   spencercw@gmail.com
X-Google-Original-From: christopher.spencer@sea.co.uk
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Subject: [RFC 0/4] crypto: caam - Add i.MX8MQ support
Date:   Fri, 22 Feb 2019 10:06:09 +0000
Message-Id: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

This patch series adds support for the i.MX8MQ to the CAAM driver. This
is mostly adapted from corresponding changes in the NXP repo. The
patches are based on v5.0-rc7.

RFC for now because I do not have any other boards to test it on.
Hopefully people can verify this change on other boards. The only thing
that I think is potentially problematic is that the RNG is now
initialised via the job ring instead of interfacing directly with the
DECO.

In principle, support for the i.MX8MM can be added by just checking for
fsl,imx8mm everywhere we are checking for fsl,imx8mq. I left this out
because there is currently no upstream support for the i.MX8MM, and I
wouldn't be able to test it anyway.

The i.MX8QM and i.MX8QXP will take more work to support because the
driver needs to be updated to handle the SECO.

I have copied the DT nodes for imx8mq.dtsi below. I will submit these
separately to the imx tree if/when these changes are accepted.

crypto: caam@30900000 {
	compatible = "fsl,sec-v4.0";
	#address-cells = <0x1>;
	#size-cells = <0x1>;
	reg = <0x30900000 0x40000>;
	ranges = <0 0x30900000 0x40000>;
	interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;

	sec_jr0: jr0@1000 {
		 compatible = "fsl,sec-v4.0-job-ring";
		 reg = <0x1000 0x1000>;
		 interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
	};

	sec_jr1: jr1@2000 {
		 compatible = "fsl,sec-v4.0-job-ring";
		 reg = <0x2000 0x1000>;
		 interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
	};

	sec_jr2: jr2@3000 {
		 compatible = "fsl,sec-v4.0-job-ring";
		 reg = <0x3000 0x1000>;
		 interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
	};
};

Sample boot log:
[    2.691119] caam 30900000.caam: device ID = 0x0a16040100000000 (Era 9)
[    2.697950] caam 30900000.caam: job rings = 3, qi = 0
[    2.703645] caam_jr 30901000.jr0: Entropy delay = 3200
[    2.709126] caam_jr 30901000.jr0: Entropy delay = 3600
[    2.784991] caam_jr 30901000.jr0: Instantiated RNG4 SH0.
[    2.855464] caam_jr 30901000.jr0: Instantiated RNG4 SH1.
[    2.881181] alg: No test for authenc(hmac(sha224),ecb(cipher_null)) (authenc-hmac-sha224-ecb-cipher_null-caam)
[    2.891777] alg: No test for authenc(hmac(sha256),ecb(cipher_null)) (authenc-hmac-sha256-ecb-cipher_null-caam)
[    2.902371] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-caam)
[    2.910989] alg: No test for echainiv(authenc(hmac(md5),cbc(aes))) (echainiv-authenc-hmac-md5-cbc-aes-caam)
[    2.933251] alg: No test for echainiv(authenc(hmac(sha1),cbc(aes))) (echainiv-authenc-hmac-sha1-cbc-aes-caam)
[    2.946711] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-caam)
[    2.956107] alg: No test for echainiv(authenc(hmac(sha224),cbc(aes))) (echainiv-authenc-hmac-sha224-cbc-aes-caam)
[    2.967791] alg: No test for echainiv(authenc(hmac(sha256),cbc(aes))) (echainiv-authenc-hmac-sha256-cbc-aes-caam)
[    2.978680] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-des3_ede-caam)
[    2.988204] alg: No test for echainiv(authenc(hmac(md5),cbc(des3_ede))) (echainiv-authenc-hmac-md5-cbc-des3_ede-caam)
[    2.999764] alg: No test for echainiv(authenc(hmac(sha1),cbc(des3_ede))) (echainiv-authenc-hmac-sha1-cbc-des3_ede-caam)
[    3.011477] alg: No test for echainiv(authenc(hmac(sha224),cbc(des3_ede))) (echainiv-authenc-hmac-sha224-cbc-des3_ede-caam)
[    3.023583] alg: No test for echainiv(authenc(hmac(sha256),cbc(des3_ede))) (echainiv-authenc-hmac-sha256-cbc-des3_ede-caam)
[    3.035376] alg: No test for authenc(hmac(md5),cbc(des)) (authenc-hmac-md5-cbc-des-caam)
[    3.044013] alg: No test for echainiv(authenc(hmac(md5),cbc(des))) (echainiv-authenc-hmac-md5-cbc-des-caam)
[    3.054668] alg: No test for echainiv(authenc(hmac(sha1),cbc(des))) (echainiv-authenc-hmac-sha1-cbc-des-caam)
[    3.065489] alg: No test for echainiv(authenc(hmac(sha224),cbc(des))) (echainiv-authenc-hmac-sha224-cbc-des-caam)
[    3.076658] alg: No test for echainiv(authenc(hmac(sha256),cbc(des))) (echainiv-authenc-hmac-sha256-cbc-des-caam)
[    3.087528] alg: No test for authenc(hmac(md5),rfc3686(ctr(aes))) (authenc-hmac-md5-rfc3686-ctr-aes-caam)
[    3.097680] alg: No test for seqiv(authenc(hmac(md5),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-md5-rfc3686-ctr-aes-caam)
[    3.109169] alg: No test for seqiv(authenc(hmac(sha1),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha1-rfc3686-ctr-aes-caam)
[    3.120670] alg: No test for authenc(hmac(sha224),rfc3686(ctr(aes))) (authenc-hmac-sha224-rfc3686-ctr-aes-caam)
[    3.131358] alg: No test for seqiv(authenc(hmac(sha224),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha224-rfc3686-ctr-aes-caam)
[    3.143393] alg: No test for seqiv(authenc(hmac(sha256),rfc3686(ctr(aes)))) (seqiv-authenc-hmac-sha256-rfc3686-ctr-aes-caam)
[    3.155198] caam algorithms registered in /proc/crypto
[    3.171662] caam_jr 30901000.jr0: registering rng-caam
[    3.616749] caam 30900000.caam: caam pkc algorithms registered in /proc/crypto

Chris Spencer (4):
  crypto: caam - fix detection of i.MX8 SoC
  crypto: caam - do not initialise clocks on the i.MX8
  crypto: caam - correct DMA address size for the i.MX8
  crypto: caam - use job ring for RNG instantiation instead of DECO

 drivers/crypto/caam/Makefile      |   2 +-
 drivers/crypto/caam/ctrl.c        | 587 ++++++------------------------
 drivers/crypto/caam/desc_constr.h |  27 +-
 drivers/crypto/caam/inst_rng.c    | 374 +++++++++++++++++++
 drivers/crypto/caam/inst_rng.h    |  18 +
 drivers/crypto/caam/intern.h      |   5 +-
 drivers/crypto/caam/jr.c          |  19 +-
 drivers/crypto/caam/pdb.h         |  49 +--
 drivers/crypto/caam/regs.h        |  21 +-
 9 files changed, 575 insertions(+), 527 deletions(-)
 create mode 100644 drivers/crypto/caam/inst_rng.c
 create mode 100644 drivers/crypto/caam/inst_rng.h

-- 
2.17.1

