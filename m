From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] crypto: lrw - Fixes for the 'create()' function
Date: Sun,  8 Oct 2017 11:39:48 +0200
Message-ID: <cover.1507445539.git.christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The first patch is the same as the one committed for crypto/xts.c applied a
few days ago.
(commit 5125e4e867ab ("crypto: xts - Fix an error handling path in 'create()'")
in /git/herbert/crypto-2.6.git)

The 2nd one is a pure speculation from me.
The create function in 'crypto/xts.c' and 'crypto/lrw.c' look very
similar.
However, there is one more sanity check in xts. This patch proposes to
add the same test in lrw. Not sure at all if correct!
I just send it for consistency.

Christophe JAILLET (2):
  crypto: lrw - Fix an error handling path in 'create()'
  crypto: lrw - Check for incorrect cipher name

 crypto/lrw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.11.0
