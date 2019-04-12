Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C47DC10F14
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BB6D2184B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfDLE6b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 00:58:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:32104 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfDLE6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 00:58:31 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Apr 2019 21:58:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,340,1549958400"; 
   d="scan'208";a="133616340"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 11 Apr 2019 21:58:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hEoGi-000EcF-L8; Fri, 12 Apr 2019 12:58:28 +0800
Date:   Fri, 12 Apr 2019 12:57:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     kbuild-all@01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com, atul.gupta@chelsio.com
Subject: [RFC PATCH] crypto/chelsio/chtls: chtls_sock_release() can be static
Message-ID: <20190412045740.GA5515@lkp-wsm-ep2>
References: <20190409152441.11256-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409152441.11256-1-atul.gupta@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Fixes: c75f2018e89e ("crypto/chelsio/chtls: CPL for TLS client")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 chtls_cm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 25a23e7..ba8316c 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -51,7 +51,7 @@ static unsigned char new_state[16] = {
 	/* TCP_CLOSING     */ TCP_CLOSING,
 };
 
-void chtls_sock_release(struct kref *ref)
+static void chtls_sock_release(struct kref *ref)
 {
 	struct chtls_sock *csk =
 		container_of(ref, struct chtls_sock, kref);
@@ -1339,7 +1339,7 @@ static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb)
 	sock_put(sk);
 }
 
-void chtls_handshake_work(struct sock *sk)
+static void chtls_handshake_work(struct sock *sk)
 {
 	struct chtls_sock *csk = sk->sk_user_data;
 
@@ -1359,7 +1359,7 @@ void stop_hndsk_work(struct sock *sk)
 	}
 }
 
-void chtls_fix_pending_tx_buffers(struct sock *sk)
+static void chtls_fix_pending_tx_buffers(struct sock *sk)
 {
 	struct chtls_sock *csk = sk->sk_user_data;
 	struct tcp_sock *tp = tcp_sk(sk);
