Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCACC43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7FB821726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="KGnq7c9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfCaDPo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:15:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:37855 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbfCaDPm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:42 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id E2290605FC;
        Sun, 31 Mar 2019 05:15:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002138; bh=dBK1CDTkhiSe5esZt+L/V8OhCS6bAS+y/lpiCVaJawc=;
        h=From:To:Date;
        b=KGnq7c9C3uIXfpS38ZdZcZeTcTh9fCJzn7+QoxMF3Q7tqkC+w1iDGa/uKWohPeyvH
         QbAIGUrP4poZuMvISi7MtskMvVWYGE7UG407Hw8po7IFp8YKZgTLPgy3QBDk737i7f
         hdvIxp/Brvk+FNoGJDdK5DQd9Aj0xrdio+pq2BiE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Jassi Brar <jassisinghbrar@gmail.com>
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 0/6] Armada 37xx mailbox + Turris
Date:   Sun, 31 Mar 2019 05:15:31 +0200
Message-Id: <20190331031537.10626-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.99.2 at mail
X-Virus-Status: Clean
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

this is a resend, since I did not receive any reviews on the actual code,
only on the dt-binding.

This patchset applies to Linus' master branch.

This is the third version of my patches to add support for the rWTM mailbox
of Marvell A3700 compatible devices, this time also with turris-mox-rwtm
firmware driver, which provides a true random number generator and ECDSA
signature generation with private key burned into eFuses in the CPU.

I would like to ask you guys for reviews, since I didn't get any review
for the first patch (adding mailbox support) yet.

What's new in v3:
 - Three more patches, to add support for communicating with the secure
   firmware on the Turris Mox board. The driver for this firmware needs
   the mailbox driver to be able to communicate with the secure
   processor.

Changes since v2:
 - changed the mailbox driver not to fail when sending a message if the
   firmware reports that secure processor is not ready. The firmware on
   EspressoBin does not indicate that it is ready in the designated
   register, even if it answers to commands. Print only a warning if the
   ready flag is not set in the FIFO_STATUS register.
 - added Rob's Reviewed-by tag for the mailbox dt-binding patch

Marek

Marek Behún (6):
  dt-bindings: mailbox: Document armada-3700-rwtm-mailbox binding
  mailbox: Add support for Armada 37xx rWTM mailbox
  arm64: dts: marvell: armada-37xx: add mailbox node
  dt-bindings: firmware: Document cznic,turris-mox-rwtm binding
  firmware: Add Turris Mox rWTM firmware driver
  firmware: turris-mox-rwtm: Add sysfs documentation

 .../testing/sysfs-firmware-turris-mox-rwtm    |  60 +++
 .../firmware/cznic,turris-mox-rwtm.txt        |  19 +
 .../marvell,armada-3700-rwtm-mailbox.txt      |  16 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |   7 +
 drivers/firmware/Kconfig                      |  14 +
 drivers/firmware/Makefile                     |   1 +
 drivers/firmware/turris-mox-rwtm.c            | 508 ++++++++++++++++++
 drivers/mailbox/Kconfig                       |  10 +
 drivers/mailbox/Makefile                      |   2 +
 drivers/mailbox/armada-37xx-rwtm-mailbox.c    | 225 ++++++++
 include/linux/armada-37xx-rwtm-mailbox.h      |  23 +
 11 files changed, 885 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
 create mode 100644 Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt
 create mode 100644 Documentation/devicetree/bindings/mailbox/marvell,armada-3700-rwtm-mailbox.txt
 create mode 100644 drivers/firmware/turris-mox-rwtm.c
 create mode 100644 drivers/mailbox/armada-37xx-rwtm-mailbox.c
 create mode 100644 include/linux/armada-37xx-rwtm-mailbox.h

-- 
2.19.2

