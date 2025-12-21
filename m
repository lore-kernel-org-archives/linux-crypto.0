Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC17A1519B4
	for <linux-crypto@vger.kernel.org>; Sun, 21 Dec 2025 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766319934; cv=none; b=b4jiLHlZc2XQgjc9qwDEBg++Za/TWMXXZ3LuyBuYbTTr5SshSQZIFolVugPI0FSNbFln7vAj84smPhjpCLrnv2R1XJo466MIFWJ69TYLbyR+ooh8oElsOOlJ1LdtCSbtie8LPw9ISkZHyH3lkT3c7o1bVq9HyoovvW+YFLCh1E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766319934; c=relaxed/simple;
	bh=4ORBV5KWOw9Y2/mgrGm/QhUHcV7rwlhW3S0pV7wcz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZMpt2ENAlgshy3ztCIneE/KDSlj1VbDvvvIQUWhERzVymE5sKIw0NcPZh/1LuW7qjLWp77X5tRWmPhDUvFKMIn3ze9uX0dSRd+YAd1NqnnA4XZjw0VRw30xBnBYm975OsGB31ib2uqjq6Au/q4Ek73W4iXF2hyfklQEMaHH9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GRYVNoE7; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRYVNoE7"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a102494058so20773105ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 Dec 2025 04:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766319932; x=1766924732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sSkLf1/fv9+TgjsnrXVtOOidaMEhVYizYDiVfueF948=;
        b=GRYVNoE7tLRlbGUv1nZducPNECu9mv7potQHJ/5wLpPVrSd37cilKJojMMA0Gjh4DJ
         jbUDQ4z69Pe1XBRNX43Xnb/SSQyqh8wypc8BWSGCLFuRNWvmTLsyD8+xFR9ESZ6n3MjV
         jhUQEzxGb87WQr52u85SInAKVnNEHdrPWFZvxqlD1pW9kzbUKv739O8K1jj+7HDf8K5g
         erflav2IBCrVl6JYpBYTRLts/0t5xCVZ+aVSI0eyUjVi8ni9aNjV0Zs7IAZwmmButjKD
         zWwAeVSC2DqQ0kORtZiK0O0NPSKtmE2kTZBi9qTPozanXIYDe1h8Xw4lD2kIpybkQRkl
         dNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766319932; x=1766924732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSkLf1/fv9+TgjsnrXVtOOidaMEhVYizYDiVfueF948=;
        b=FFyjX1lE3M5BbHa37I9hDVy8ViE7+jwMkHa3O3Sz7gec+XdkqoKmjH4EsGrro9iAY1
         D6ObAVOkYhKUsQB/bcNG7I704lY39FIT0dUo6JuUTh1EANCFt0YdPBxAE+kxtdVkg7Wp
         TyyySAUFLRh/NA4wvanIyQ/RVpFmIHfRUplKk17uUU5KB+QHI2Tg4efrVm+DK5C4uXd/
         H1Rjfxsqn1XFBbEY5es1Vr6jfrt8TxLC+GGIzHCLd5l0gM/ulu80BDFA3b9ZqKAxY3ad
         l36/3yoISX+BTHXqKCWQ00mtodQMoa+ZOv8NhkxCiN5kRYGPNHbBjXa5c8E7+/CvPz85
         7Qhg==
X-Forwarded-Encrypted: i=1; AJvYcCWmckrCCXPBYadk8azp5oFtefULPBehXQrnrWa+/FiSe7RRFWPfESOR87dRCrmLRfjSzldf09MxWx0xZLA=@vger.kernel.org
X-Gm-Message-State: AOJu0YysGEsnmuuXXPcrKxkDDk7Gk36SdKWuGJ8RrqzNqswQHxfroCjx
	MSLtGlhftUF26kv/mRTFxcPYEvMYaef07pqXLuEipWphq484ZbeyKhiK
X-Gm-Gg: AY/fxX5cz6bWpBr2zKWNveQ+38yPgNDnjNXInhy8RUAI0PT8Pxbs6ODSs19oGuRrxj0
	SdhogJ4un3Dud7Htr/a+odPgOxsZjpv2Hs8t40JJWobsYcBipvhA0YcMe/BCl4zOk8lbZ3M7jZX
	mBPY3MSd4VtW6z/ZaDEHHtWXMqINZbXVsITXQAttph88qeBcM8JzQwplRAloPro/Z0UTs5mgK9o
	ycoTKLwZpv7Mi9zPpNnvQQMQaSFvwj8olXarD2n6BBILHicHxNHoCLWAAI3WHj+F5ZB/7/AOhII
	8YpvUo6QAfdK7hjSyeF2uOsM35K5dKnDpkMQw67KA+dVlFIkcIsg8nlXXn/x4ixKmI8P4yEQdf2
	qmbW926o58hP/R8ICyXLCXFicYpj7WQYHcBKndQk2ORLXcu0V1sUTR2bt6H138VgslqjyTtxUTL
	KZgbU/D8PQXB0hznGWesWEPEhIyxAZuCLMS92ixZI=
X-Google-Smtp-Source: AGHT+IESOhuqCxPbVlg7SeTOcbMMUAB63kD6TCBDApyknqScrZdKyUEp+E1X6xForQnkT7sT/ZbSng==
X-Received: by 2002:a17:902:ce92:b0:295:99f0:6c65 with SMTP id d9443c01a7336-2a2cac808c8mr121055385ad.30.1766319931802;
        Sun, 21 Dec 2025 04:25:31 -0800 (PST)
Received: from kator.lab-gw2.os.ecc.u-tokyo.ac.jp ([133.11.33.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e7729b04dsm4623837a91.6.2025.12.21.04.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:25:30 -0800 (PST)
From: Lianjie Wang <karin0.zst@gmail.com>
To: Olivia Mackall <olivia@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianjie Wang <karin0.zst@gmail.com>
Subject: [PATCH] hwrng: core - fix racing condition when stopping hwrng_fill
Date: Sun, 21 Dec 2025 21:24:48 +0900
Message-ID: <20251221122448.246531-1-karin0.zst@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, hwrng_fill is not cleared until the hwrng_fillfn() thread
exits. Since hwrng_unregister() reads hwrng_fill outside the rng_mutex
lock, a concurrent hwrng_unregister() may call kthread_stop() again on
the same task.

Besides, if the hwrng_unregister() call happens immediately after a
hwrng_register() before, the stopped thread may have never been running,
and thus hwrng_fill remains dirty even after the hwrng_unregister() call
returns. In this case, further calls to hwrng_register() may not start
new threads, and hwrng_unregister() will also call kthread_stop() on the
same task, causing use-after-free and sometimes lockups:

refcount_t: addition on 0; use-after-free.
WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
Call Trace:
 <TASK>
 kthread_stop+0x181/0x360
 hwrng_unregister+0x288/0x380
 virtrng_remove+0xe3/0x200
WARNING: ... at kernel/fork.c:735 __put_task_struct+0x287/0x3d0
Call Trace:
 <IRQ>
 ? __pfx___put_task_struct_rcu_cb+0x10/0x10
 rcu_core+0xa30/0x1ab0
 ? __pfx_rcu_core+0x10/0x10
 ? hrtimer_interrupt+0x527/0x710
 handle_softirqs+0x14b/0x470

This patch fixes this by protecting the global hwrng_fill inside the
rng_mutex lock. hwrng_unregister() calls kthread_stop() on the copied
pointer after releasing the lock, ensuring each hwrng_fillfn() thread is
stopped only once, and hwrng_fillfn() itself only clears hwrng_fill on
the error path.

In this case, since hwrng_fill is cleared before the thread exits,
hwrng_register() may start another thread while one is being stopped, so
rng_fillbuf has to be moved to the private stack of hwrng_fillfn() to
avoid races.

Fixes: be4000bc4644 ("hwrng: create filler thread")
Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
---
 drivers/char/hw_random/core.c | 39 ++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 96d7fe41b373..69ed503b50bb 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -36,12 +36,12 @@ static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs */
 static LIST_HEAD(rng_list);
-/* Protects rng_list and current_rng */
+/* Protects rng_list, current_rng and hwrng_fill */
 static DEFINE_MUTEX(rng_mutex);
-/* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
+/* Protects rng read functions, data_avail and rng_buffer */
 static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
-static u8 *rng_buffer, *rng_fillbuf;
+static u8 *rng_buffer;
 static unsigned short current_quality;
 static unsigned short default_quality = 1024; /* default to maximum */
 
@@ -484,16 +484,24 @@ static int hwrng_fillfn(void *unused)
 	size_t entropy, entropy_credit = 0; /* in 1/1024 of a bit */
 	long rc;
 
+	/* Use a private buffer to avoid races with dying threads */
+	u8 buffer[RNG_BUFFER_SIZE];
+
 	while (!kthread_should_stop()) {
 		unsigned short quality;
 		struct hwrng *rng;
 
 		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
+		if (IS_ERR(rng) || !rng) {
+			/* Clear hwrng_fill on the error path */
+			mutex_lock(&rng_mutex);
+			if (hwrng_fill == current)
+				hwrng_fill = NULL;
+			mutex_unlock(&rng_mutex);
 			break;
+		}
 		mutex_lock(&reading_mutex);
-		rc = rng_get_data(rng, rng_fillbuf,
-				  rng_buffer_size(), 1);
+		rc = rng_get_data(rng, buffer, sizeof(buffer), 1);
 		if (current_quality != rng->quality)
 			rng->quality = current_quality; /* obsolete */
 		quality = rng->quality;
@@ -515,10 +523,9 @@ static int hwrng_fillfn(void *unused)
 			entropy_credit = entropy;
 
 		/* Outside lock, sure, but y'know: randomness. */
-		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
+		add_hwgenerator_randomness((void *)buffer, rc,
 					   entropy >> 10, true);
 	}
-	hwrng_fill = NULL;
 	return 0;
 }
 
@@ -570,6 +577,7 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 void hwrng_unregister(struct hwrng *rng)
 {
 	struct hwrng *new_rng;
+	struct task_struct *to_stop;
 	int err;
 
 	mutex_lock(&rng_mutex);
@@ -585,10 +593,11 @@ void hwrng_unregister(struct hwrng *rng)
 	}
 
 	new_rng = get_current_rng_nolock();
-	if (list_empty(&rng_list)) {
+	if (list_empty(&rng_list) && hwrng_fill) {
+		to_stop = hwrng_fill;
+		hwrng_fill = NULL;
 		mutex_unlock(&rng_mutex);
-		if (hwrng_fill)
-			kthread_stop(hwrng_fill);
+		kthread_stop(to_stop);
 	} else
 		mutex_unlock(&rng_mutex);
 
@@ -664,15 +673,8 @@ static int __init hwrng_modinit(void)
 	if (!rng_buffer)
 		return -ENOMEM;
 
-	rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
-	if (!rng_fillbuf) {
-		kfree(rng_buffer);
-		return -ENOMEM;
-	}
-
 	ret = misc_register(&rng_miscdev);
 	if (ret) {
-		kfree(rng_fillbuf);
 		kfree(rng_buffer);
 	}
 
@@ -684,7 +686,6 @@ static void __exit hwrng_modexit(void)
 	mutex_lock(&rng_mutex);
 	BUG_ON(current_rng);
 	kfree(rng_buffer);
-	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
 
 	misc_deregister(&rng_miscdev);
-- 
2.52.0

