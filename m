Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA806C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 08:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF3EC223A0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 08:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGv9BUqp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfGWIJF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 04:09:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41792 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfGWIJF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 04:09:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so18744662pff.8
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2019 01:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCvOR3nb19zpkJHPKREgguJngLbu4r1vMJhi29PVQzI=;
        b=WGv9BUqpMfwzTXVXFcO2czrxzQklaLondrp+6XMGSfFFlkcRy7MjxJCfzSoZpMFA8G
         XQMalWq3JRuiciWayBIF7+PaNOH3VvLEOVXYIjg9WmcHNXA0iaKIMNoD6lo49VyrsNgL
         Lmh3H3/ixkSoU2zSFUjk4VfS8irLbDlpP3SValNI5+sS1MBAecYmpiTfqPo0WwZdHjUA
         ZldUZzyCaCYsdVq12bejOC0Q7KJZhMynV6N9wHjaKuTazQ2icYAq58PlK9n/kI5ooUcO
         tkwtew4eLjbBJ/h+APh60yuHS0/jg2i2roTlobw6U8QFASghE+n0HiK30xhwIY/oWfl2
         mnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCvOR3nb19zpkJHPKREgguJngLbu4r1vMJhi29PVQzI=;
        b=lVXuFvvYLrOCjxQ8liH6VKrFtOUZ0Iv0jFns/EuzJlCW2r219IID0H/T/Y7BNZWfwi
         ZH/yQ5FsMEMxYRHfCeh60cMOU2zHj+3rjqu/tu49h0Lk0pne5V6rBx85E5q6J9IDC+Dz
         HgDIdoseH2ZAyCxVEyyAR3faQY58a9R82c2nC5tv7TeuIanbDbVNWBA22QIzliPwMG7J
         M0aVonxQ1MuSK0JdhW/Xq/4ujhLJLe/CjQDqtmVem83mgztnP/oO7E/ZTpVqW5ksfzmI
         1IqOYnR/9Ed2XkijDLaFQvIedqUuQ9rSrq+OIGFlITGdp1Q13KSME0mS886AUIAVMras
         UJQA==
X-Gm-Message-State: APjAAAViuD/AVbBOUqyVL7LM+xoKZqQ/p0uveAJQVLOU9ULdlIG5QXxD
        ClFn2h7SJzpGwOvXqYdZgH8=
X-Google-Smtp-Source: APXvYqxEYAuXO/sQuaFQMOeLEf/JsmUtSFxXIArrFjel5fHiRw0u8svDJL8+fPl+kPU/7EL/a++6XQ==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr82103517pjq.114.1563869344766;
        Tue, 23 Jul 2019 01:09:04 -0700 (PDT)
Received: from localhost.localdomain ([122.163.0.39])
        by smtp.gmail.com with ESMTPSA id j12sm32646534pff.4.2019.07.23.01.09.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 01:09:04 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     haren@us.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] crypto: nx: nx-842-powernv: Add of_node_put() before return
Date:   Tue, 23 Jul 2019 13:38:51 +0530
Message-Id: <20190723080851.7648-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Each iteration of for_each_child_of_node puts the previous node, but
in the case of a return from the middle of the loop, there is no put,
thus causing a memory leak. Add an of_node_put before the return.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index e78ff5c65ed6..c037a2403b82 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -1020,6 +1020,7 @@ static __init int nx842_powernv_init(void)
 		ret = nx842_powernv_probe_vas(dn);
 		if (ret) {
 			nx842_delete_coprocs();
+			of_node_put(dn);
 			return ret;
 		}
 	}
-- 
2.19.1

