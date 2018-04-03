From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [crypto-chtls] Supicious code in chtls_io
Date: Tue, 3 Apr 2018 16:46:52 -0500
Message-ID: <20180403214652.GA31283@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Atul Gupta <atul.gupta@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

While doing some static analysis I came across the following piece of code at drivers/crypto/chelsio/chtls/chtls_io.c:1203:

1203                 if (!size)
1204                         break;
1205 
1206                 if (unlikely(ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND))
1207                         push_frames_if_head(sk);
1208                 continue;
1209 
1210                 set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
1211         }


The issue is that in the code above, set_bit is never reached due to the 'continue' statement at line 1208.

I wonder if the actual intention of the code was something like this:

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 5a75be4..a949a6c 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1203,9 +1203,10 @@ int chtls_sendpage(struct sock *sk, struct page *page,
                if (!size)
                        break;
 
-               if (unlikely(ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND))
+               if (unlikely(ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND)) {
                        push_frames_if_head(sk);
-               continue;
+                       continue;
+               }
 
                set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
        }


What do you think?

I can send a proper patch for this.

Thanks
--
Gustavo
