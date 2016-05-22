From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 14/54] MAINTAINERS: Add file patterns for crypto device tree bindings
Date: Sun, 22 May 2016 11:05:51 +0200
Message-ID: <1463907991-7916-15-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 878e4b4634f87ecd..0079717d52e46222 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3292,6 +3292,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	Documentation/crypto/
+F:	Documentation/devicetree/bindings/crypto/
 F:	Documentation/DocBook/crypto-API.tmpl
 F:	arch/*/crypto/
 F:	crypto/
-- 
1.9.1
