From: Marek Vasut <marex@denx.de>
Subject: [PATCH 4/4] crypto: geode: Weed out printk() from probe()
Date: Wed, 14 May 2014 11:36:41 +0200
Message-ID: <1400060201-11519-4-git-send-email-marex@denx.de>
References: <1400060201-11519-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Michal Ludvig <michal@logix.cz>,
	Varun Wadekar <vwadekar@nvidia.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-geode@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37899 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaENJhA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:37:00 -0400
In-Reply-To: <1400060201-11519-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: Eric B=C3=A9nard <eric@eukrea.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Michal Ludvig <michal@logix.cz>
Cc: Varun Wadekar <vwadekar@nvidia.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-geode@lists.infradead.org
---
 drivers/crypto/geode-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: Geode guys, can you please test this change ?

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 69e1b02..8e482ce 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -547,7 +547,7 @@ static int geode_aes_probe(struct pci_dev *dev, con=
st struct pci_device_id *id)
 	if (ret)
 		goto eecb;
=20
-	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled.\n");
+	dev_notice(&dev->dev, "GEODE AES engine enabled.\n");
 	return 0;
=20
  eecb:
@@ -565,7 +565,7 @@ static int geode_aes_probe(struct pci_dev *dev, con=
st struct pci_device_id *id)
  eenable:
 	pci_disable_device(dev);
=20
-	printk(KERN_ERR "geode-aes:  GEODE AES initialization failed.\n");
+	dev_err(&dev->dev, "GEODE AES initialization failed.\n");
 	return ret;
 }
=20
--=20
2.0.0.rc0
