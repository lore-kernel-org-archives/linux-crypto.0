From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v2 0/2] Propagate fallback bit for cbc and ctr
Date: Mon, 27 Feb 2017 09:38:24 -0300
Message-ID: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Hebert,

For v2:

- fixed the memory leakage in cbc.
- included crypto/algapi.h in crypto/cbc.c for crypto_requires_off();
- ERR_CAST instead PTR_ERR in ctr.
- Also propagated the fallback bit for rfc3686.

Marcelo Henrique Cerri (2):
  crypto: cbc - Propagate NEED_FALLBACK bit
  crypto: ctr - Propagate NEED_FALLBACK bit

 crypto/cbc.c | 15 +++++++++++++--
 crypto/ctr.c | 23 ++++++++++++++++++-----
 2 files changed, 31 insertions(+), 7 deletions(-)

-- 
2.7.4
