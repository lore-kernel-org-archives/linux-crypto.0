Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136DC21C174
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 23:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022141; cv=none; b=jkNT9eaxsMLi+Al1eH5MV9nLLhUh9GHCx/rAPthMjbVttwGMInoM+ZnXw2eM+/+OZO0zVEI+CB33T6owOjXb/zD/Tmkz5M52LjLpIuoNfVnIARSoACbTqE/U9xYEsuk1LFFOfT8mFd+2nd5+AGfbQSfmfPPae3APruJcqN52luA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022141; c=relaxed/simple;
	bh=GeMVM4Ec+fn//3H9389VcZZMcj62SCQA+XOQ+JtdlTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tsll0LI3IqZI4NW6mqP3fxBf9wejvDI7pAfXWt8TUVgyd9VGK6mCPDRVrF9N+B8KWIUk+8fhNin+yv4ZNzs93Ah7qp8mMz9kX/uEx4WE0gRuwiLAnvAYsgZXxR7KNqn+nB6CNujz/GTG3M0bREqKFveBzANd62v5FbQIW5dxDSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JX9FZUk/; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JX9FZUk/"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8901dff1so32237587b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 15:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731022138; x=1731626938; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/mtW86B3DSmlFKT0lotGzdj7a1N3s2uwCyGHDKQX9vU=;
        b=JX9FZUk/e6j59NxGLo6eMoMD/5JJ1GIZ6T4TqiczfVL7UibG3f1PN5pCvADJ4MhnjS
         GDJ3eg6ns0z2X2juoctL3TXICjhQNPE/Nayy+BmJS19l0BpAb5WK/9/Gf4ecgkpxV22n
         ER5LlqX24cy2DbAy8NBG7kLnvFeivLklM9M3HkJSb9txouWmN2I739qR11Hqj0u5FrNi
         3m3BccRQexo5+G77PYL4uVjiw1+7bWCnzLEVXttAOiWulXsWxveaAa9cVAZo/w/lIEjg
         VBPKC/Y+Xtq47hTQLijVBIdmKGTFjQ7DeEVMDvTDLlGPTIF8OdU+PsMkFWPYuUAfATzS
         HdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731022138; x=1731626938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/mtW86B3DSmlFKT0lotGzdj7a1N3s2uwCyGHDKQX9vU=;
        b=XAGXZ4PMouLEa3g82HQWef8QxW0n8N0sgVkVkE0tPPVqX+VzKx6NR0ObZFjmgW7l3k
         MUGyDV1zBew21HBaBx+xuwiasMWYx40XDiePzpLfVLIyiwxeR/3Be3lPrqMCUyn5UwvC
         /9mcngXD65pAFqC8TufxkhnxrfX02k8rz7BL2tSuDDDp6HzB+JH6xy1H09a721ZnT0Ss
         LTT4aNnXyqWrOmZzMPTXQ1krgyQrPCWnPspzXVMyI9WJvmRTw+KtLIO5wu3yRmrE/3b4
         tsky1xxE+UF4vfcGfM9P0v97DfU3sA3Xdd2usSkd1Dp30L38xGXMENWJNmyvaWw8nWGC
         q2zg==
X-Forwarded-Encrypted: i=1; AJvYcCULXKdPsu2mn5+3TMPVMyqqJUVQhwU4HPsVMj/CqR2g6LzTBvG7LbO5UmQMCyVbTM5Hw8oE0Cq30xqyIpM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4FeIIaFXkTkf9K9eqUhG+OlRdvWNOE7Zcc49f4fCZcQHMXZb3
	1l6lOo5nvLp4PSAWYUHI1TSKMXx7dAa1gPf9VV3AkaOeb2yuFzDdgPKWkRimLut2xyX8n+HMq+Y
	15QGE5KtDAn/6O4orK90WpQ==
X-Google-Smtp-Source: AGHT+IHrNNzZrarS/YQjs+xV1rDR0GePDAFsw74nsrSHNCOrLqUNJv5SPe4CSAD/IfeNYkWr5gdo2XMmDenU30uPTw==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:3501:b0:62c:f976:a763 with
 SMTP id 00721157ae682-6eaddd8b094mr187867b3.1.1731022138141; Thu, 07 Nov 2024
 15:28:58 -0800 (PST)
Date: Thu,  7 Nov 2024 23:24:47 +0000
In-Reply-To: <20241107232457.4059785-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107232457.4059785-8-dionnaglaze@google.com>
Subject: [PATCH v5 07/10] crypto: ccp: Add preferred access checking method
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

sev_issue_cmd_external_user is the only function that checks permissions
before performing its task. With the new GCTX API, it's important to
establish permission once and have that determination dominate later API
uses. This is implicitly how ccp has been used by dominating uses of
sev_do_cmd by a successful sev_issue_cmd_external_user call.

Consider sev_issue_cmd_external_user deprecated by
checking if a held file descriptor passes file_is_sev, similar to the
file_is_kvm function.

This also fixes the header comment that the bad file error code is
-%EINVAL when in fact it is -%EBADF.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++--
 include/linux/psp-sev.h      | 11 ++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 498ec8a0deeca..f92e6a222da8a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/file.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
@@ -2486,11 +2487,19 @@ static struct notifier_block snp_panic_notifier = {
 	.notifier_call = snp_shutdown_on_panic,
 };
 
+bool file_is_sev(struct file *p)
+{
+	return p && p->f_op == &sev_fops;
+}
+EXPORT_SYMBOL_GPL(file_is_sev);
+
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
-	if (!filep || filep->f_op != &sev_fops)
-		return -EBADF;
+	int rc = file_is_sev(filep) ? 0 : -EBADF;
+
+	if (rc)
+		return rc;
 
 	return sev_do_cmd(cmd, data, error);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index b91cbdc208f49..ed85c0cfcfcbe 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -879,11 +879,18 @@ int sev_platform_status(struct sev_user_data_status *status, int *error);
  * -%ENOTSUPP  if the SEV does not support SEV
  * -%ETIMEDOUT if the SEV command timed out
  * -%EIO       if the SEV returned a non-zero return code
- * -%EINVAL    if the SEV file descriptor is not valid
+ * -%EBADF     if the file pointer is bad or does not grant access
  */
 int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
 				void *data, int *error);
 
+/**
+ * file_is_sev - returns whether a file pointer is for the SEV device
+ *
+ * @filep - SEV device file pointer
+ */
+bool file_is_sev(struct file *filep);
+
 /**
  * sev_guest_deactivate - perform SEV DEACTIVATE command
  *
@@ -1039,6 +1046,8 @@ static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
 static inline int
 sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int *error) { return -ENODEV; }
 
+static inline bool file_is_sev(struct file *filep) { return false; }
+
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
 static inline void *snp_alloc_firmware_page(gfp_t mask)
-- 
2.47.0.277.g8800431eea-goog

