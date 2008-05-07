From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 09/n]: Fix max queue length value
Date: Wed, 07 May 2008 14:38:31 +0200
Message-ID: <4821A2C7.9070100@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060108000802040005040709"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62854 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYEGMjM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:39:12 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060108000802040005040709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------060108000802040005040709
Content-Type: text/x-diff;
 name="09.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.diff"

commit 21b18f9b22c7aa0a458c3f93fc1771a5eb5e70c8
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 13:00:10 2008 +0200

    [HIFN]: Fix max queue length value
    
    All but the last element of the command and result descriptor rings can be
    used for crypto requests, fix HIFN_QUEUE_LENGTH.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index b28e8b1..7d19b15 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -371,7 +371,7 @@ static atomic_t hifn_dev_number;
 
 #define HIFN_D_DST_DALIGN		4
 
-#define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-5
+#define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-1
 
 #define AES_MIN_KEY_SIZE		16
 #define AES_MAX_KEY_SIZE		32

--------------060108000802040005040709--
