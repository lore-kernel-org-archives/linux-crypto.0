From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] Kconfig: move CRYPTO to the "Cryptographic options" menu
Date: Sun, 13 Aug 2006 23:01:49 +0200
Message-ID: <20060813210149.GR3543@stusta.de>
References: <20060813012454.f1d52189.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:10510 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751475AbWHMVBv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Aug 2006 17:01:51 -0400
To: Andrew Morton <akpm@osdl.org>, herbert@gondor.apana.org.au,
	davem@davemloft.net
Content-Disposition: inline
In-Reply-To: <20060813012454.f1d52189.akpm@osdl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 13, 2006 at 01:24:54AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.18-rc3-mm2:
>...
>  git-cpufreq.patch
>...
>  git trees
>...

This patch moves the CRYPTO option to the "Cryptographic options" menu
(it was the only option directly in the toplevel menu).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 crypto/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.18-rc4-mm1/crypto/Kconfig.old	2006-08-13 21:13:38.000000000 +0200
+++ linux-2.6.18-rc4-mm1/crypto/Kconfig	2006-08-13 21:14:24.000000000 +0200
@@ -2,6 +2,8 @@
 # Cryptographic API Configuration
 #
 
+menu "Cryptographic options"
+
 config CRYPTO
 	bool "Cryptographic API"
 	help
@@ -9,8 +11,6 @@
 
 if CRYPTO
 
-menu "Cryptographic options"
-
 config CRYPTO_LOWAPI
 	tristate
 
@@ -402,6 +402,6 @@
 
 source "drivers/crypto/Kconfig"
 
-endmenu
+endif	# if CRYPTO
 
-endif	# if CRYPTO
+endmenu

