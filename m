From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: Add myself as the maintainer for the CPRNG
Date: Wed, 28 Jan 2009 10:28:52 -0500
Message-ID: <20090128152852.GA6990@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59426 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZA1P3D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 10:29:03 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Add myself as the maintainer for the CPRNG.  Herbert shouldn't deal with it
alone if (when?) it breaks :)
Neil
    
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


MAINTAINERS |    6 ++++++
1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57e0309..b488092 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1252,6 +1252,12 @@ L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 
+CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
+P:	Neil Horman
+M:	nhorman@tuxdriver.com
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
