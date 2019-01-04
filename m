Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfADGqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 01:46:42 -0500
Date: Fri, 4 Jan 2019 09:46:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        Gadam Sreerama <sgadam@cavium.com>,
        "Nagadheeraj, Rottela" <Rottela.Nagadheeraj@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: cavium/nitrox - Use after free in
 process_response_list()
Message-ID: <20190104064611.GA30627@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We free "sr" and then dereference it on the next line.

Fixes: c9613335bf4f ("crypto: cavium/nitrox - Added AEAD cipher support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index e34e4df8fd24..fe070d75c842 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -567,10 +567,10 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 
 		/* ORH error code */
 		err = READ_ONCE(*sr->resp.orh) & 0xff;
-		softreq_destroy(sr);
 
 		if (sr->callback)
 			sr->callback(sr->cb_arg, err);
+		softreq_destroy(sr);
 
 		req_completed++;
 	}
-- 
2.17.1
