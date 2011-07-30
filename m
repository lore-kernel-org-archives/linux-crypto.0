From: Jonathan Nieder <jrnieder@gmail.com>
Subject: [PATCH] crypto: padlock-aes - Make module loading even quieter when
 hardware is missing
Date: Sat, 30 Jul 2011 13:50:12 +0200
Message-ID: <20110730115011.GA2837@elie>
References: <201107281403.27224.ralfjung-e@gmx.de>
 <20110730061307.GA24394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ralf Jung <ralfjung-e@gmx.de>, linux-crypto@vger.kernel.org,
	katzj@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>, 485070@bugs.debian.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1G3Lud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jul 2011 07:50:33 -0400
Received: by fxh19 with SMTP id 19so3042573fxh.19
        for <linux-crypto@vger.kernel.org>; Sat, 30 Jul 2011 04:50:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20110730061307.GA24394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When loading aes via the module alias, a padlock module failing to
load due to missing hardware is not particularly notable.  With
v2.6.27-rc1~1107^2~14 (crypto: padlock - Make module loading quieter
when hardware isn't available, 2008-07-03), the padlock-aes module
suppresses the relevant messages when the "quiet" flag is in use; but
better to suppress this particular message completely, since the
administrator can already distinguish such errors by the absence of a
message indicating initialization failing or succeeding.

This avoids occasional messages in syslog of the form

	padlock_aes: VIA PadLock not detected.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Herbert Xu wrote:
> Ralf Jung <ralfjung-e@gmx.de> wrote:

>> With current Debian testing (Kernel 2.6.39), I am getting this error on each 
>> boot:
>> FATAL: Error inserting padlock_sha (/lib/modules/2.6.39-2-
>> amd64/kernel/drivers/crypto/padlock-sha.ko): No such device
[...]
> That message comes from user-space and needs to be fixed there.

Thanks.  Indeed, I was sloppy when reading the original report and
thought he was talking about a different message.  Sorry for the
noise.

 drivers/crypto/padlock-aes.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index db33d300..29b9469f 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -508,10 +508,8 @@ static int __init padlock_init(void)
 	int ret;
 	struct cpuinfo_x86 *c = &cpu_data(0);
 
-	if (!cpu_has_xcrypt) {
-		printk(KERN_NOTICE PFX "VIA PadLock not detected.\n");
+	if (!cpu_has_xcrypt)
 		return -ENODEV;
-	}
 
 	if (!cpu_has_xcrypt_enabled) {
 		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
-- 
1.7.6
