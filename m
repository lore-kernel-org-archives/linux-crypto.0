From: <yanjiang.jin@windriver.com>
Subject: [PATCH] crypto: rsa: rename two rsa key files
Date: Fri, 4 Nov 2016 14:13:37 +0800
Message-ID: <1478240017-23117-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <jinyanjiang@gmail.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Yanjiang Jin <yanjiang.jin@windriver.com>

This is to eliminate the below compile error:

crypto/rsa_helper.c:19:29: fatal error: rsaprivkey-asn1.h: No such file or directory
 #include "rsaprivkey-asn1.h"
                             ^
compilation terminated.

Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
---
 crypto/{rsaprivkey.asn1 => rsaprivkey.asn1.h} | 0
 crypto/{rsapubkey.asn1 => rsapubkey.asn1.h}   | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename crypto/{rsaprivkey.asn1 => rsaprivkey.asn1.h} (100%)
 rename crypto/{rsapubkey.asn1 => rsapubkey.asn1.h} (100%)

diff --git a/crypto/rsaprivkey.asn1 b/crypto/rsaprivkey.asn1.h
similarity index 100%
rename from crypto/rsaprivkey.asn1
rename to crypto/rsaprivkey.asn1.h
diff --git a/crypto/rsapubkey.asn1 b/crypto/rsapubkey.asn1.h
similarity index 100%
rename from crypto/rsapubkey.asn1
rename to crypto/rsapubkey.asn1.h
-- 
2.9.3
