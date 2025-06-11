Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.124.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC52253A7;
	Wed, 11 Jun 2025 02:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.124.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749610551; cv=none; b=UwsWHcxEWgL+sP2x02D+ver+gturnlVoi0HrK1FnMCOsjbVSyMnf7D1BGpV1zlI0SdNovkn5wxG7hppG70sb05AJ4Nn/rhdCcuJ48S1lhxAHaFdcPNCiaxJR8s3eYlNnlGe0d14PbW87I5G6LNTYjKdhQns0dwY9AtL4Op0FhCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749610551; c=relaxed/simple;
	bh=1SfWLNL/FC1rT/iKltN1seHXevO1sVSorCDWux9W8hI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l5PaWIFcQtN5aVF50D9mV+Aiv5yLJm0JMcMZh3JIY4xJyFP00ZDLJ83TnV/vTbXc3ZbPenVRswua45HhlqsuGRH0yJPZl/ZqhSZAj9Nyw0+NRFERUXpqXsy/2tUSAhWNCvKT0Zj1la+a1YZ44HrHJIBmely3fiZCdb78L72pkjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fJcYlftp; arc=none smtp.client-ip=114.132.124.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fJcYlftp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1749610214;
	bh=+SFJe2eZwTIqWqiWQneNj9pXOnIVJCo/JcdPa2LLTRY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=fJcYlftpoXMfdzfUi272cJ4A7rPJ1yGCml3/M/9dUFAFFvBGej3YSgUjOw1eJf6+s
	 xIFwwVrcxmBNZR5W0eWSTxRdrJSOAxjGfdNWydJl6wgVEoFUb27/4ugRSNgV233Xbu
	 N22/w5BPh9soipi1YTzZ7mXJ/IB36wUFExVpzqJg=
X-QQ-mid: zesmtpip2t1749610195t49310972
X-QQ-Originating-IP: FI7qULpZDG4vLjdo4DIGoUAzm3pRyCVa+SRomc+ednE=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 11 Jun 2025 10:49:53 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1616921945040750328
EX-QQ-RecipientCnt: 11
From: =?UTF-8?q?=E2=80=9CChengZhenghan=E2=80=9D?= <chengzhenghan@uniontech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	ChengZhenghan <chengzhenghan@uniontech.com>
Subject: [PATCH] x86_coco_sev: Fix build warnings about export.h
Date: Wed, 11 Jun 2025 10:49:51 +0800
Message-Id: <20250611024951.21791-1-chengzhenghan@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: Nz/pxMdGViHbxnsdkpAwYubfzaOyYNAVye809nRgq/vXnsvMxOtTfanf
	1XOLRbDRrxpC7OCFxVUTK/fZGuc2oGi0i6c8OaFVg5azw2w/B7S22bR5farGXvOyJdmtqKu
	ZIGDMufk+KKdlywBx7y08dGUqIl+bhhkinS/NLXjdzXYsCg3HjERAhqKvgWaPdXSDxPcaDC
	Qd8ziPKYf9Rg0fzB1K9Wa2S/gnMnkQyX26KvFqgImOwFGvcSHJgLHlKYQtKca21m6VRuo8G
	dt8P4SxkZpT50GD80ZmX7Z2WVWJRgHUwLHHJ8eOnAjiPtio75eFku979a97ffs2sGBPOq0f
	QRUKDKaOJcVuFoXbZtuOWChfH8MouRJ1xGj988Wm7AJrUvfu8QBHHJAGAutchk09LA5kpFJ
	QO8auvEXTBNOhVhxp4kyYW0IQWA1Rn66o1VWVRKEcxFOcgvmyUtkYjahfoboUWMn/H1/1Ie
	tvWKjrTa4ST420P8qukNenQT9/3b/v/cIx/Vv+SJoIfjnOGfCU/Gth0/6+d76clueBgKci9
	S7WDhngwxwiEYXpXT5Di204nzMseQWC6d0YaN9Gf1Z1ow9DmfzMU0k0OLQEYiT6lhfE0uEi
	mXObafgJ9AZl7wBSI6Iw+2VFyj5GutL/s6h1k9eICsXEvra+wdV2TA9naeuWqtHhbgq0Hvo
	jUVeBNBDx4qoAZLb5mRhECoAixbOZWrJM9N/hyQ52uHDZLTibP3Io2zPV1ZKXUz0sLLGQ1u
	pCxFxloy+JDyC3qXIIiL+Rgn1E1QkXpqsSDr/EjMdANJ+c00DaJQRoAvzJFQGequACTujdZ
	uOnAfly1XQ04AHKeSRzMnePyVHrQrusWHUeLWncNP/URVJRJNVtZWCnE9D5NZTE5at+1/nB
	dyVsVWRkgcvpfgTbhfhgBBCRkJWZvu4QsJtIINNEBT8KO1kX8JAruirirv6SIOJivJ3fVaS
	ezbPFzLidbNsG0EDGNTm1tTFhs+aUEnaVy/7bsr/tFvqPc5v6a7JAQMTe3n90uLSr7ANpOS
	uux4kbdq71kyx/JAMRmRi40bxl2U8=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

From: ChengZhenghan <chengzhenghan@uniontech.com>

I got a build warning with W=1:
arch/x86/coco/sev/core.c:
warning: EXPORT_SYMBOL() is used,
but #include <linux/export.h> is missing
so I fixed the build warning for x86_64.

Signed-off-by: ChengZhenghan <chengzhenghan@uniontech.com>
---
 arch/x86/coco/sev/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index b6db4e0b936b..4b5d41bdd58d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/cpumask.h>
 #include <linux/efi.h>
+#include <linux/export.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/psp-sev.h>
-- 
2.47.2


