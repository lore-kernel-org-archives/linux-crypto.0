Return-Path: <SRS0=AT0s=ZU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F5BC43215
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 13:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1659A21774
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 13:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK1NAg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Nov 2019 08:00:36 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58291 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfK1NAg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Nov 2019 08:00:36 -0500
Received: from orion.localdomain ([95.117.37.214]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MKKER-1iEWnt3SjH-00LkPB; Thu, 28 Nov 2019 13:54:34 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     tim@buttersideup.com, james.morse@arm.com, rrichter@marvell.com,
        jdelvare@suse.com, linux@roeck-us.net, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, linux-crypto@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 3/6] mtd: maps: amd76xrom: use pci_get_device_by_id()
Date:   Thu, 28 Nov 2019 13:54:03 +0100
Message-Id: <20191128125406.10417-3-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191128125406.10417-1-info@metux.net>
References: <20191128125406.10417-1-info@metux.net>
X-Provags-ID: V03:K1:kHHWDalUVUqjlafRyIBDsEVrMDclpS6WFOcs2fJqalWicwdQghg
 xuEXtV526bjd5k4WcJfvLri5gHj3mTA2elZo05psIN/BL0IYjbsFx73zY7qOePNgjzjErsa
 kephRy+9U7L17Fjl1nNwmeDO5WtgjG4pSkuT9CawtD2JlPNhZQi26P0EcKRYUshBzobhF/h
 zCsfwx4mIUAImOjsQ+atw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HVNFLXUI8no=:Nc0GdKIXzMS7m180256uDy
 jCFDBRie3blvAsXX+pcsXjmc479xIx8f5/lZCyg8xMQZwTcIOZWWhVvaXcrSQvuRmCkDJD+yz
 xi13CUwqIUGbCnxDx4HwD1DwXt3UW1QH0SwM0mtzNFbWBVXXoUZTl7S1YyTqwCZZG/QqFEql/
 KXGfoEv7z711cgxYbuynC1dj5W0vcc0n1QSZSdcCUrm/7nnrD70V9hEa3FdmyJYpX+EA7FqaE
 NE4sdcvhdg/EW6OQOv2QINUEofKv0d/g9h9H/POzWr8oQ8WPf0iXEMfQOFFWr3mk76Nia1l/x
 GeKYo2M7k3h+Q11m34NEcm6hmwAqotrk7gGSW8ICDHj36cDjFYY3wB2QknwRAGp3ONoC9x44J
 2o3HnIhGKChll6830UJPp1xuG7bZZNiJO5apnFTK8lmlEgjSMPV/ynWGb0YGEATxI8bYUtSw8
 tD0Aycmup8cAkUGNFI3TrHtlg4sgYSRXHRcOCnbVqaBWmNwRmuXS4Q/fVvW0ayNZKcy8X274k
 GVDTQ8qX8E8RR5r8xEWtaFlh29j0UPWsJr1Afix5Yp/s2DiXQ/56GVkEDfp4nY7jx5dR9VP3C
 DdHyD7FXgrW5pPgGulBP5FOdKqCiTLdmlH+YcsrZY/6yh1MPvJWx9BLp5DaXAWdcQhj2vs3wf
 Cm5rWh57LhE43A/XHN6SSJGP0L7+u7PdHLWtYH36k/NFeXbeaTzR5e3311LdUauXeSht7/fNw
 lAJPgZfup5MeWPNT7Hq1tRVoC2apQG+jn70abCWQg/ybgXsLXerEWsCieft9hca8+V3btu1IW
 uu+dfpMkilp/WPQK1n86856jiB1m+wC896dZy8GvAM3YEA6yU3s9PHEIN7KIHE0+QKbKIaq8N
 SY+iucKAdtRbwvbTWAQw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new pci_get_device_by_id() helper in order to reduce
a bit of boilerplate.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/mtd/maps/amd76xrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 462fadb56bdb..07a402dbdf44 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -323,7 +323,7 @@ static int __init init_amd76xrom(void)
 	const struct pci_device_id *id;
 	pdev = NULL;
 	for(id = amd76xrom_pci_tbl; id->vendor; id++) {
-		pdev = pci_get_device(id->vendor, id->device, NULL);
+		pdev = pci_get_device_by_id(id);
 		if (pdev) {
 			break;
 		}
-- 
2.11.0

