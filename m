Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18341C5DF61
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C10222C1
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cfxn590q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389850AbfKEPOJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:09 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43421 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389837AbfKEPOI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:08 -0500
Received: by mail-pf1-f194.google.com with SMTP id 3so15651412pfb.10;
        Tue, 05 Nov 2019 07:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+V9U/kgqliJ0JjR1q9YS5WvnKS2tKemStnCe92kSlvk=;
        b=Cfxn590qqeWUo+j4bZrh9/whULdSKwb9U/vupga1h+vwWxsLJkDH27emfnI6gDNjv7
         YjBA+xouJrES7HOOeSkl/54A/wXL8JdQjEcwBa9R6o9Hib3F0OrdEEdY070ReSX5kTz1
         PTKl6xMJn2ro0FNWzulPYQMpX1MaKJ2W6S5emAPV/ICLVZUObPXSvlDZqvLrxjuZZbO/
         EbjWeV6VqASPHHcO89QqpnyPklvGJ9sUxZMKx9kjit5X0x001mnEy8y/hn3HzKHvIYdq
         H0D+xbX+wUnKRfhGJaCzBaA4BYvwOltURj+b7nOsGFPXgGceK0+iEZKdDzQ8XixojdAI
         EC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+V9U/kgqliJ0JjR1q9YS5WvnKS2tKemStnCe92kSlvk=;
        b=TI/zVR9d5hWCFQcijVmjOtKpJ1Vyv5FKABDx7yNQ33bUYZZQ4VUuPMi0ICVuZ/2XPf
         mBFhf6JNex8+f+fonuXDVxcN8FrdkY7cWkgcGJB7SFP7TE01qpHK/z+68wUMOn+HM7NZ
         B1M8jYk+uaK9s6vEjCyQH4rkh0/bhbN2ThP5sJJJB5HqspCmB1+Ho94RU5lYO6DHMAI8
         ELKzEW3kcJnei/pa0ojqJD2nCG/ilNlNS/7kVHQAco5x9K6DXaVVBS0kg9R6h0qzzENS
         S6Uzg2DsKhYPoJt8Dc9e0e/2UKiZ7DqHBA0ObQumNmksGDDONFF+dbniSYy9RU+5ateS
         WKuQ==
X-Gm-Message-State: APjAAAU8+m75mh3FxsN1Giu/80FownSVZ8zoV5pbgb4vrPHnEOLor5X2
        xo0NSkvmonN2P100fG6+cvEkbb4b
X-Google-Smtp-Source: APXvYqxXmJawm6N8va4MaMzR8P7XqNje/7s+J33Z9iWrsXZxI2CJmv2bnRLnDHUKgfuhO4OY/GwW5A==
X-Received: by 2002:a63:d802:: with SMTP id b2mr37083755pgh.414.1572966846743;
        Tue, 05 Nov 2019 07:14:06 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:14:05 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] crypto: caam - disable CAAM's bind/unbind attributes
Date:   Tue,  5 Nov 2019 07:13:53 -0800
Message-Id: <20191105151353.6522-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Exposing bind/unbind attributes for CAAM device allows user to
circumvent module use counter and remove underlying device even while
it is still in use by crypto API. The problem can be easily reproduce
using the following sinppiet:

$ openssl speed -evp aes-128-cbc -engine afalg &
$ echo 30900000.crypto > /sys/bus/platform/drivers/caam/unbind
[  164.797687] ------------[ cut here ]------------
[  164.802320] kernel BUG at crypto/algapi.c:412!
[  164.806771] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  164.812260] Modules linked in: crct10dif_ce caam caamhash_desc caamalg_desc error btusb btbcm btintel
[  164.821506] CPU: 1 PID: 2170 Comm: sh Not tainted 5.4.0-rc1 #30
[  164.827428] Hardware name: ZII i.MX8MQ Ultra Zest Board (DT)
[  164.833091] pstate: 20000005 (nzCv daif -PAN -UAO)
[  164.837897] pc : crypto_unregister_alg+0xe4/0xf0
[  164.842520] lr : crypto_unregister_alg+0x8c/0xf0
[  164.847138] sp : ffff8000130f3b20
[  164.850454] x29: ffff8000130f3b20 x28: ffff0000f1131a80
[  164.855771] x27: 0000000000000000 x26: 0000000000000000
[  164.861087] x25: ffff0000fa147ea0 x24: 0000000000000020
[  164.866404] x23: ffff8000130f3c58 x22: ffff8000130f3b58
[  164.871721] x21: ffff800012b787c8 x20: ffff800012be7ef0
[  164.877037] x19: ffff800008ad7300 x18: 000000000000002b
[  164.882353] x17: 0000000000000000 x16: 0000000000000000
[  164.887670] x15: ffff800012b8f4d0 x14: 55980d468eb0c075
[  164.892987] x13: 4375a0958c16498f x12: 27cb4484db878b3d
[  164.898304] x11: c3bdc615f6902956 x10: e030849201295489
[  164.903620] x9 : 00a97e1a31855afa x8 : 00000000000014a5
[  164.908937] x7 : ffff800008ad7310 x6 : ffff8000130f3a60
[  164.914253] x5 : ffff8000130f3af8 x4 : ffff800008ad7310
[  164.919570] x3 : 0000000000000000 x2 : 0000000000000000
[  164.924886] x1 : ffffffffffffffff x0 : 0000000000000002
[  164.930202] Call trace:
[  164.932656]  crypto_unregister_alg+0xe4/0xf0
[  164.936932]  crypto_unregister_skcipher+0x20/0x30
[  164.941662]  caam_algapi_exit+0x84/0xa0 [caam]
[  164.946124]  caam_jr_remove+0x54/0xd0 [caam]
[  164.950401]  devm_action_release+0x20/0x30
[  164.954501]  release_nodes+0x1c8/0x240
[  164.958255]  devres_release_all+0x3c/0x60
[  164.962272]  device_release_driver_internal+0x10c/0x1c0
[  164.967501]  device_driver_detach+0x28/0x40
[  164.971689]  unbind_store+0x94/0x100
[  164.975269]  drv_attr_store+0x40/0x60
[  164.978938]  sysfs_kf_write+0x5c/0x70
[  164.982605]  kernfs_fop_write+0xf4/0x1f0
[  164.986534]  __vfs_write+0x48/0x90
[  164.989941]  vfs_write+0xb8/0x1d0
[  164.993261]  ksys_write+0x74/0x100
[  164.996668]  __arm64_sys_write+0x24/0x30
[  165.000598]  el0_svc_handler+0x94/0x100
[  165.004439]  el0_svc+0x8/0xc
[  165.007329] Code: aa1403e0 97f2d52e 12800020 17fffff5 (d4210000)
[  165.013428] ---[ end trace 11587fd1ef597dd6 ]---
[  165.018138] note: sh[2170] exited with preempt_count 1
[  165.024146] ------------[ cut here ]------------
[  165.028786] WARNING: CPU: 1 PID: 0 at kernel/rcu/tree.c:569 rcu_idle_enter+0x7c/0x90
[  165.048977] Hardware name: ZII i.MX8MQ Ultra Zest Board (DT)
[  165.054640] pstate: 200003c5 (nzCv DAIF -PAN -UAO)
[  165.059435] pc : rcu_idle_enter+0x7c/0x90
[  165.063450] lr : do_idle+0x218/0x2b0
[  165.067027] sp : ffff800012e1bf20
[  165.070343] x29: ffff800012e1bf20 x28: 0000000000000000
[  165.075663] x27: 0000000000000000 x26: 0000000000000000
[  165.080983] x25: 0000000000000000 x24: ffff800012b78884
[  165.089045] x21: ffff800012b78860 x20: 0000000000000002
[  165.094362] x19: ffff800012b787e8 x18: 0000000000000010
[  165.099678] x17: 0000000000000000 x16: 0000000000000001
[  165.104995] x15: ffff0000ff789170 x14: 0000000000000001
[  165.110311] x13: ffff0000ff7a8170 x12: ffff0000fa996cd4
[  165.115628] x11: ffff0000fa996cd4 x10: 0000000000000970
[  165.120945] x9 : ffff800012e1bea0 x8 : ffff0000fa9aa450
[  165.126261] x7 : 0000000000000001 x6 : ffff800012e1bee0
[  165.131577] x5 : 0000000000000001 x4 : ffff800012cc61a8
[  165.136894] x3 : 4000000000000002 x2 : 4000000000000000
[  165.142210] x1 : ffff800012b6edc0 x0 : ffff0000ff789dc0
[  165.147526] Call trace:
[  165.149978]  rcu_idle_enter+0x7c/0x90
[  165.153644]  do_idle+0x218/0x2b0
[  165.156876]  cpu_startup_entry+0x2c/0x50
[  165.160806]  secondary_start_kernel+0x164/0x180
[  165.165339] ---[ end trace 11587fd1ef597dd7 ]---

Remove bind/unbind attributes of CAAM device, so that the only way to
remove it during runtime would be to remove underlying kernel module.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 0fb39bcf638a..e0c16cd2ce1a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -920,6 +920,7 @@ static struct platform_driver caam_driver = {
 	.driver = {
 		.name = "caam",
 		.of_match_table = caam_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe       = caam_probe,
 };
-- 
2.21.0

