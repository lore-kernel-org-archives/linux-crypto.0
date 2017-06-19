From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Mon, 19 Jun 2017 15:13:03 +0530
Message-ID: <CANc+2y4TUNDd0-7jQBTQkBJELDTSS=jNHF2zqHGtS58XU=TuAA@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
 <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
 <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
 <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com>
 <20170619041234.GA12984@gondor.apana.org.au> <CAAbOSckrApUs26m7+iGyex43tEaWthNOuuN2jjBu-apj-y-Rdw@mail.gmail.com>
 <20170619062115.GA13498@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@chromium.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35152 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdFSJnE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 05:43:04 -0400
Received: by mail-vk0-f67.google.com with SMTP id 19so6643970vkd.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2017 02:43:04 -0700 (PDT)
In-Reply-To: <20170619062115.GA13498@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19 June 2017 at 11:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Jun 18, 2017 at 10:00:17PM -0700, Mike Frysinger wrote:
>>
>> in order to make tpm-rng react in the way you're implying, the TPM
>> subsystem would need to add a notification chain for transitions from
>> none<->some devices, then tpm-rng could subscribe to that, and during
>> those transition points, it would call hwrng_register/hwrng_unregister
>> to make itself visible accordingly to the hwrng subsystem.  maybe
>> someone on the TPM side would be interested in writing all that logic,
>> but it sounds excessive for this minor usage.  the current tpm-rng
>> driver is *extremely* simple -- it's 3 funcs, each of which are 1
>> line.
>
> It's simple and it's broken, as far as the way it hooks into the
> hwrng is concerned.

*********************************************************************************************
diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
index d6d4482..4861b35 100644
--- a/drivers/char/hw_random/tpm-rng.c
+++ b/drivers/char/hw_random/tpm-rng.c
@@ -22,6 +22,10 @@
 #include <linux/tpm.h>

 #define MODULE_NAME "tpm-rng"
+#define MAX_RETRIES 30
+
+static struct delayed_work check_tpm_work;
+static int retry_count;

 static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
@@ -33,9 +37,27 @@ static struct hwrng tpm_rng = {
        .read = tpm_rng_read,
 };

+static void check_tpm_presence(struct work_struct *work)
+{
+       u8 data = 0;
+       if (tpm_get_random(TPM_ANY_NUM, &data, 1) > 0) {
+               hwrng_register(&tpm_rng);
+       } else {
+               if (retry_count < MAX_RETRIES) {
+                       retry_count++;
+                       schedule_delayed_work(&check_tpm_work, HZ * 10);
+               } else {
+                       pr_err("Could not find any TPM chip, not
registering rng");
+               }
+       }
+}
+
 static int __init rng_init(void)
 {
-       return hwrng_register(&tpm_rng);
+       INIT_DELAYED_WORK(&check_tpm_work, check_tpm_presence);
+       check_tpm_presence(NULL);
+
+       return 0;
 }
 module_init(rng_init);
*********************************************************************************************

Why not something like this? Patch is completely untested. If this
idea seems useful I can clean the code but would require help in
testing.

Regards,
PrasannaKumar
