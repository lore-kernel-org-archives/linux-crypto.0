From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 02/13] crypto: Documentation - compile crypto API spec
Date: Wed, 12 Nov 2014 05:24:12 +0100
Message-ID: <1603144.FhPLRRlDmc@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	'Geert Uytterhoeven' <geert@linux-m68k.org>,
	"Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the crypto API documentation into the DocBook Makefile to allow it
being compiled

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bec0665..9c7d92d 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -15,7 +15,7 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
 	    tracepoint.xml drm.xml media_api.xml w1.xml \
-	    writing_musb_glue_layer.xml
+	    writing_musb_glue_layer.xml crypto-API.xml
 
 include Documentation/DocBook/media/Makefile
 
-- 
2.1.0
