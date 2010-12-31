From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Thu, 30 Dec 2010 18:46:31 -0600
Message-ID: <4D1D27E7.7030301@lwfinger.net>
References: <4D1A8200.4010609@lwfinger.net> <20101229195440.GD5838@darkside.kls.lan> <4D1BD2B0.4020101@lwfinger.net> <20101230012003.GA2665@darkside.kls.lan> <4D1BF056.3060909@lwfinger.net> <20101230143406.GA23219@darkside.kls.lan> <4D1CD161.4040107@lwfinger.net> <20101230204522.GC23219@darkside.kls.lan> <4D1D0C61.9050800@lwfinger.net> <20101231003735.GA24101@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090805080501070202040206"
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0LaAqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Dec 2010 19:46:31 -0500
In-Reply-To: <20101231003735.GA24101@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090805080501070202040206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/30/2010 06:37 PM, Herbert Xu wrote:
> On Thu, Dec 30, 2010 at 04:49:05PM -0600, Larry Finger wrote:
>>
>> Do you see any problems in the code in drivers/net/wireless/b43/main.c or
>> drivers/char/hw_random/via-rng.c. As the latter seems to make b43 fail, I am
>> suspecting via-rng, but I have no proof.
> 
> My suspicion is that VIA's xstore is writing more than 4 bytes as
> the list pointer happens to lie immediately after rng->priv which
> is where xstore is writing to.
> 
> Harald, do you know whether this is documented or is this a known
> errata item?

The following patch should be able to test if xstore is overwriting the list
pointer.

Larry
---

Index: wireless-testing/include/linux/hw_random.h
===================================================================
--- wireless-testing.orig/include/linux/hw_random.h
+++ wireless-testing/include/linux/hw_random.h
@@ -38,6 +38,7 @@ struct hwrng {
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
 	unsigned long priv;
+	char junk[12];

 	/* internal. */
 	struct list_head list;



--------------090805080501070202040206
Content-Type: text/plain;
 name="hwrng_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hwrng_debug"

Index: wireless-testing/include/linux/hw_random.h
===================================================================
--- wireless-testing.orig/include/linux/hw_random.h
+++ wireless-testing/include/linux/hw_random.h
@@ -38,6 +38,7 @@ struct hwrng {
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
 	unsigned long priv;
+	char junk[12];
 
 	/* internal. */
 	struct list_head list;


--------------090805080501070202040206--
