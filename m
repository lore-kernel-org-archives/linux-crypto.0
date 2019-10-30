Return-Path: <SRS0=+Udk=YX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF6FCA9EC5
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Oct 2019 16:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B25842054F
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Oct 2019 16:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="ICsVkYM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfJ3QGY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Oct 2019 12:06:24 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40618 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ3QGY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Oct 2019 12:06:24 -0400
Received: by mail-lj1-f193.google.com with SMTP id u22so3300123lji.7
        for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2019 09:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nuru03JnuH9fx/0jdmmXx1/PTVnjDFz/0xAAwcHtc6M=;
        b=ICsVkYM1vIvPi88fM8Yr6EORt/Wl3EhfOLIJHPnVYeD6l9iL54sh/1DGGUvqQXm307
         OngRr94mQeBwVn1SpryjzNIPccTIcyyIK0s5cGJ+rvsJ3HLKHKCvMdlyT3bKA3xATulO
         gz2jNz0ipWmU4F7OLuBvvjuZYc5Df6rGdXr7GoWuFgmkKuWSCRFM2bWaSyuHK0b3TQTh
         fpC3f4GJzq6qm4N2fGA4j0yCU3R23PLw/MHKdU9dmmhIsJ9uWKuG3WLwLablVlyJTDMw
         e0pQb+olSBgfN8RexVMczn9oDn4RXuvwvLHCo9v/RCSWcLxIBMrGB9gO4rbSImhLsuhE
         91SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nuru03JnuH9fx/0jdmmXx1/PTVnjDFz/0xAAwcHtc6M=;
        b=pCkLaHSa9Rg6yDgoDLue4/F2RWTUvJiwy+aMlRLLIHOIcBLOCNn6SSTgK2u5uciYrV
         MuSOg9TVaR8tfkYGA+hiy4bciHbmO4FTbqiI++pLKGx1j4CxDWSKMcOCwAI8QOzXO4pO
         5baW5QpLugNRLKGIiJSby0YVFR0QrfIg4z89pOI6jcpO7b0Bp0qAzJET9ePtc3NotxXU
         n0RiszpEwincvb49/WNLgqnA+TXZglr2SPPE6Xv2B4zUrWc+X+8lEc/9R7LvC13agnWS
         YgA6vepv6yxKF3PxuJuaVukF2mDO1PffQdJ5mxoP3ZAaNeeUo57ftd5S2WOyY4G9T+D5
         Jqqw==
X-Gm-Message-State: APjAAAVttXM19uP91nNpBlhfEMn3w7Dcw/9k+t4OZbq1BAmmcnz/ukYz
        JNFtiMeIgxbYnjsq+FFAE9TnMQ==
X-Google-Smtp-Source: APXvYqzVM2Pfy2j/t89/o38T/MRIjQ0HVsIRoMn2xR+ftH7uTiq8+TOtzNgduXcB1glD8MEkeVf/Aw==
X-Received: by 2002:a2e:b0c9:: with SMTP id g9mr350704ljl.95.1572451582533;
        Wed, 30 Oct 2019 09:06:22 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a28sm155643ljn.16.2019.10.30.09.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 09:06:21 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Date:   Wed, 30 Oct 2019 09:05:42 -0700
Message-Id: <20191030160542.30295-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sk_msg_trim() tries to only update curr pointer if it falls into
the trimmed region. The logic, however, does not take into the
account pointer wrapping that sk_msg_iter_var_prev() does.
This means that when the message was trimmed completely, the new
curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
neither smaller than any other value, nor would it actually be
correct.

Special case the trimming to 0 length a little bit.

This bug caused the TLS code to not copy all of the message, if
zero copy filled in fewer sg entries than memcopy would need.

Big thanks to Alexander Potapenko for the non-KMSAN reproducer.

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
Daniel, John, does this look okay?

CC: Eric Biggers <ebiggers@kernel.org>
CC: herbert@gondor.apana.org.au
CC: glider@google.com
CC: linux-crypto@vger.kernel.org

 net/core/skmsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..c42c145216b1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = 0;
+		msg->sg.copybreak = 0;
+	} else if (msg->sg.curr >= i) {
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-- 
2.23.0

