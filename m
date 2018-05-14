From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH 0/5] build warnings cleanup
Date: Mon, 14 May 2018 16:30:54 +0530
Message-ID: <1526295659-29839-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Build warnings cleanup reported for
- using only 128b key
- wait for buffer in sendmsg/sendpage
- check for null before using skb
- free rspq_skb_cache in error path
- indentation

Atul Gupta (5):
  crypto:chtls: key len correction
  crypto: chtls: wait for memory sendmsg, sendpage
  crypto: chtls: dereference null variable
  crypto: chtls: kbuild warnings
  crypto: chtls: free beyond end rspq_skb_cache

 drivers/crypto/chelsio/chtls/chtls.h      |   1 +
 drivers/crypto/chelsio/chtls/chtls_hw.c   |   6 +-
 drivers/crypto/chelsio/chtls/chtls_io.c   | 104 +++++++++++++++++++++++++++---
 drivers/crypto/chelsio/chtls/chtls_main.c |   3 +-
 4 files changed, 98 insertions(+), 16 deletions(-)

-- 
1.8.3.1
