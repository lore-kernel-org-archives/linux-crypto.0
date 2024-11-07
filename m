Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DED21A706
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 23:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022132; cv=none; b=CaTjttzKFs/016GYJed5lWqU1h4+M6hbQvkVIeBK+vRPWQmu/461j3g8lXviDvktG1cPDDQHyX4D9GkTqoKC7tERtHdHQg8p6JRdGDcM/5zA4EiSAW18j8yi5OADriq07nY0H6qMItEP1KYxcxL3AaiUVv3Tr18Eu0AtEbXShQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022132; c=relaxed/simple;
	bh=lRBqf5twuEZRlunb4SU7u4RsPEMFdFwbD7rStcI1GVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VptRA9vBrJsjruACE/Ixe7BFHGR3KY8Womh5W+v44eqiVT/146xHLg3VOfk9ZqrEvEEmrwF3TPlfp9JdOBWRJWpFXvALq5oLH31Uxgc0mmSeQ5STtHY3B+bUzz53VrRNWc0T7Rp3NJklrcKnL0isyQaSbveIQd5ZnYiliPo6Tq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4n13qEW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4n13qEW"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e3d74e5962so1602215a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 15:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731022130; x=1731626930; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R5GIXxcbWN8I/ZRWs7VNYRYcdtYl9gfySVnkJreof1o=;
        b=W4n13qEWTYMhqiAtXZTIu4lR1YVqxww1mxu7pRQDLV5immugt3hFPFjHFfjnZe82TC
         UnOjXKsa/0Onv4LCmcQ/l809Py5VastJp24n5VoHc7LXOfFyqBZTc/Ou9wUXsLGtU8c7
         WbRt+AX/ZATpyij5HWZsWqFYw8gImUCsH8O+HFMEJKqzfAHac8XheJXNHhTHyjYPaORw
         UPJ0a8V2/N5eBuycUE3jOklKfLshTRmU5g6W/Fh/dxFY6z3WLSA95TPHp/DCb/K0h0Tx
         Frbo7vJB5r33Eka8aiVkP1ND4ZAWhjbje5amaOiQ61UtslOc2IgdONeaQDryx730LoUr
         clEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731022130; x=1731626930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5GIXxcbWN8I/ZRWs7VNYRYcdtYl9gfySVnkJreof1o=;
        b=GE0wy0NMJ/dRtPPEOjcEUFPU+fMNfaL8KAGTFLD/jbWRl0/tidHs3eKnFL5dFsYetT
         vSF/Yme4osalRykeR1PRd38Y/lz2+AkvVrdkQWSYQPJruBZy/GWU8i/62WJ9a30PTWbS
         l0JiwAWpC9AiHu5lT5DOsVBhvz16uerDyj2ri0vm11dYAplJHnFeHOHt6m9TsN64M4Nn
         6G2eMqTpohXluDM+9JKaGnYxtsqegUV/xAIRYPaZb63d65AyEBPYPkvJVn6ZKyf2hb61
         td5/qbiz3HL0xLG+EU0QF5gRzBH+u4tLj0+tj93Tmhvi47u7pemdgTPYDqhEqac/Qj98
         lvSA==
X-Forwarded-Encrypted: i=1; AJvYcCWPKeeLRP14mX9bQc0Ns0NqW6W4OBY9O/stOrEWxQXOQA256KJfFWd2916H+J1e5fjSESW5ulNdj4RhaOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR7cwbF3EMQObyJfELPYXciIBMPKekU3B40GP1EVO32oLv+OCa
	9T4oWwl5dZ/cjbxBDEToTK/bVbVFBF8sSlU+KLePlxv4NlUUg4VmqKcWxeUdTHakp9cKAD0uG5T
	dJ6vBiFUFxGA5qfJh3+m1UQ==
X-Google-Smtp-Source: AGHT+IEwOfZDI4F3jRslzGIEdwn06Xqt2NhOKADKScJCrSFXrWa8oRKCWk++dR3cp8p6tEK54xsId3Hhy6ePNZyFVA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90a:39c3:b0:2e0:a07d:1e61 with
 SMTP id 98e67ed59e1d1-2e9b16e7a8emr6234a91.2.1731022130343; Thu, 07 Nov 2024
 15:28:50 -0800 (PST)
Date: Thu,  7 Nov 2024 23:24:44 +0000
In-Reply-To: <20241107232457.4059785-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107232457.4059785-5-dionnaglaze@google.com>
Subject: [PATCH v5 04/10] crypto: ccp: Fix uapi definitions of PSP errors
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, stable@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Additions to the error enum after the explicit 0x27 setting for
SEV_RET_INVALID_KEY leads to incorrect value assignments.

Use explicit values to match the manufacturer specifications more
clearly.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")

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
CC: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 include/uapi/linux/psp-sev.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 832c15d9155bd..eeb20dfb1fdaa 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -73,13 +73,20 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
-	SEV_RET_INVALID_KEY = 0x27,
-	SEV_RET_INVALID_PAGE_SIZE,
-	SEV_RET_INVALID_PAGE_STATE,
-	SEV_RET_INVALID_MDATA_ENTRY,
-	SEV_RET_INVALID_PAGE_OWNER,
-	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
-	SEV_RET_RMP_INIT_REQUIRED,
+	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
+	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
+	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
+	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
+	SEV_RET_AEAD_OFLOW                 = 0x001D,
+	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
+	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
+	SEV_RET_BAD_SVN                    = 0x0021,
+	SEV_RET_BAD_VERSION                = 0x0022,
+	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
+	SEV_RET_UPDATE_FAILED              = 0x0024,
+	SEV_RET_RESTORE_REQUIRED           = 0x0025,
+	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
+	SEV_RET_INVALID_KEY                = 0x0027,
 	SEV_RET_MAX,
 } sev_ret_code;
 
-- 
2.47.0.277.g8800431eea-goog

