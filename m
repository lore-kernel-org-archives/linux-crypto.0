Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F6DC388F3
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 12:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F84121855
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 12:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfI3MPs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 08:15:48 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52461 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfI3MPr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 08:15:47 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MqapC-1hjvMD2Xwm-00meW0; Mon, 30 Sep 2019 14:15:25 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: inside-secure - Fix a maybe-uninitialized warning
Date:   Mon, 30 Sep 2019 14:14:33 +0200
Message-Id: <20190930121520.1388317-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LInyj3Ud0A8wB1lffm2V4xf1mZe/8J3moJ6KlLFoXVopMJiU/KM
 KxE4gKuqXvHz5qvY0skfX00Qf9wBYigW3dERcUECUQk5t+w48wwHyk5tQnjQRvHg1s9vw1H
 cZ/9oBe3xJSdpS21GHrrqvAXp6zEoKW/PvheWvOURr3TQe8FHkaIuu0vfdLDy+QlRH18qie
 mrXaPorGX3+Eyn5xcLY5w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U0vHL9TV2yo=:DiIHi5HDqbjDn+66lvh3os
 nzMF3Fp3UmCEhUte/68ClyljDSx7vzyaqqEWEK3TFQFqaUO2OKOiHG0v6QQruDYfewn3wNCFb
 u0efen0ljbb7ev/Hvu+rImGYZJ7aqaKAzCjzkZy68VBBUBnNE0DdNP9vrnIGYW5wDTDCMjqDg
 0ZqHMVq/Fy6f2gXJdK1aQNMCWlldAia81jFNbJhs4IaHSpci+Gj4N5ERBVQqNYAUJnssRxxei
 3+NaFM59fS8mxFIts/r+X3tzUFBalDZdjaaXLcHp5qL+EbwGiouWMl7AxfbJxN4FsJwBLpZVt
 j5n5Mpvh4AQijN+RYpzFl+hdyCfnL8vLJZLMGAgK9NZidxC1ItinGxHu/0SpprSCPSOxvc/i2
 7o1VYme52Tde7KRHrfjkztgJO5MFe3LZbwe/iud14AEaAa59E4zgopDXjsAb5bz4H3d+LFwnL
 ICLYRkOIgrUuL1mTHukqdBtvE/9Lx6vABqUHymuQwwrshX9eDV/7FhAKiDh5NjOh0Mj+nTsVN
 JR2pmX9WvGVGppUySihKW8s1qDKKKedwhkHJyjaNDTiXxWd77ljwYX49JM8YwQf8Mp6qSWB/4
 DQjNrWV11MDtCBBywbalwJl1VQ7UoVTItdfE1+PaVrsOpEB6x5cSyHMQgJu5T+ZP5ubybNd9J
 A0rOoVnBkAThUKeVo1NAgWtYKh6zi3bfHTyag29X2COSv1jLQzo6+CtD0791oNuOKo0ZLMtcb
 J1chSZt5iADXu6VIZoNlrC7b8UpGYQX8w1opW9fD8t5bhta/o9Kf3TjexUzssMFRtWKH1Qf0e
 tMk1goSf9Lb6jP/p+i6aXWyDLSf2kN5TD0VGDF8yUnptoPoMyijB7YRj2d+1zBN67mm10fYhJ
 EQZdIIA3eBVUy4Js3uXQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A previous fixup avoided an unused variable warning but replaced
it with a slightly scarier warning:

drivers/crypto/inside-secure/safexcel.c:1100:6: error: variable 'irq' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]

This is harmless as it is impossible to get into this case, but
the compiler has no way of knowing that. Add an explicit error
handling case to make it obvious to both compilers and humans
reading the source.

Fixes: 212ef6f29e5b ("crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4ab1bde8dd9b..311bf60df39f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1120,6 +1120,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 				irq_name, irq);
 			return irq;
 		}
+	} else {
+		return -ENXIO;
 	}
 
 	ret = devm_request_threaded_irq(dev, irq, handler,
-- 
2.20.0

