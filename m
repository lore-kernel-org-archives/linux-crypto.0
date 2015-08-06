From: Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH] crypto: doc - make URL into hyperlink
Date: Thu,  6 Aug 2015 14:49:00 -0700
Message-ID: <1438897740-51513-1-git-send-email-computersforpeace@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35300 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbHFVtQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 17:49:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The HTML output works a little nicer that way.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 Documentation/DocBook/crypto-API.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 0992531ffefb..7643646713dd 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1101,7 +1101,7 @@ kernel crypto API            |       Caller
     </para>
 
     <para>
-     [1] http://www.chronox.de/libkcapi.html
+     [1] <ulink url="http://www.chronox.de/libkcapi.html">http://www.chronox.de/libkcapi.html</ulink>
     </para>
 
    </sect1>
@@ -1661,7 +1661,7 @@ read(opfd, out, outlen);
     </para>
 
     <para>
-     [1] http://www.chronox.de/libkcapi.html
+     [1] <ulink url="http://www.chronox.de/libkcapi.html">http://www.chronox.de/libkcapi.html</ulink>
     </para>
 
    </sect1>
-- 
2.5.0.rc2.392.g76e840b
