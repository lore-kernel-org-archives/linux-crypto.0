From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 08/n]: Properly initialize ivsize for CBC modes
Date: Wed, 07 May 2008 14:36:24 +0200
Message-ID: <4821A248.7070905@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080909070509010002050100"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62804 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYEGMhE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:37:04 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080909070509010002050100
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Two questions regarding this patch:

- do OFB and CFB also need ivsize initialization?

- the HIFN documentation doesn't mention OFB and CFB (the
  values are marked reserved), do they actually work?



--------------080909070509010002050100
Content-Type: text/x-diff;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

commit d4ef6dd3f4e37a37c0823fd09c53657af63c8d88
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:56:18 2008 +0200

    [HIFN]: Properly initialize ivsize for CBC modes
    
    For combined modes like cbc(aes) the driver is responsible for
    initializing ivsize.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4027fa1..b28e8b1 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2377,6 +2377,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	{
 		.name = "cbc(des3_ede)", .drv_name = "cbc-3des", .bsize = 8,
 		.ablkcipher = {
+			.ivsize		=	HIFN_IV_LENGTH,
 			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
 			.setkey		=	hifn_setkey,
@@ -2421,6 +2422,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	{
 		.name = "cbc(des)", .drv_name = "cbc-des", .bsize = 8,
 		.ablkcipher = {
+			.ivsize		=	HIFN_IV_LENGTH,
 			.min_keysize	=	HIFN_DES_KEY_LENGTH,
 			.max_keysize	=	HIFN_DES_KEY_LENGTH,
 			.setkey		=	hifn_setkey,
@@ -2455,6 +2457,7 @@ static struct hifn_alg_template hifn_alg_templates[] = {
 	{
 		.name = "cbc(aes)", .drv_name = "cbc-aes", .bsize = 16,
 		.ablkcipher = {
+			.ivsize		=	HIFN_AES_IV_LENGTH,
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
 			.setkey		=	hifn_setkey,

--------------080909070509010002050100--
