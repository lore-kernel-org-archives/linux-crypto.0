Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB77D480DC4
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629046; cv=none; b=d2ugy0TtojUWcA3X0AXJSQIASyQDnOgXeL9kwQVSHHQXkv4Sy3IHpXdWxlsWddbUBQNVlHzRDdwa9wIIMC0LXlAFvVC3gg+xE+ORbJuzU2MuTiSMqgC0c+uYVpnLqXy94CCk7n6GFJnNB8s8yI/N4C0pPuwJ1RysqrtgpN62Y7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629046; c=relaxed/simple;
	bh=XgaO4VcBnXqnegcdzvYcbT+W/5cM5fHNPQJkvkvWHoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7hnh4Qj63OQ65M52ZLg2gtk43bAka2cyujRMh/Cm5qdy5Z6ifAEyFVx9kOba+p0p3iUK7pN6U9pHGVqzFYW+1j7asYpWDmRBfX8y9IwpkcxBSlZ/MtvQJiCpaVZ8zWG5Y+GJO/8DrOcdM1NPKPCcrDDdKfMM7dJC7klLl+uuGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eVQbiaIJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVQbiaIJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJFxwPC/lONIUC+gsyoHfrFegnGesCm7Wa4rIv9vDZA=;
	b=eVQbiaIJ0xKtJVr7jBkCHUKIHqW82U7192bDlLi4EU1Gdxn1cqRILHsXO8ahxofIohjZMN
	yQOufM18sl4XZo6Kzv3fvSFqe1GUI0wqnQUX0gpzQkoHGq1PUt1ouZ4U+pUy4FTRRzIe5f
	ZpoiFj07WNttOEpemKHWqXEinOUwzMU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-LrEbr0AyOE60wx5p1htHSQ-1; Thu,
 13 Aug 2026 09:50:39 -0400
X-MC-Unique: LrEbr0AyOE60wx5p1htHSQ-1
X-Mimecast-MFC-AGG-ID: LrEbr0AyOE60wx5p1htHSQ_1786629037
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8873818002F8;
	Thu, 13 Aug 2026 13:50:36 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F8691800348;
	Thu, 13 Aug 2026 13:50:31 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/11] x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
Date: Thu, 13 Aug 2026 15:49:48 +0200
Message-ID: <20260813134953.979481-11-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

purgatory.c includes both, the <crypto/sha2.h> header and the
arch/x86/boot/string.h header. The latter provides its own prototypes
for a lot of string functions which clash with the fortified macros
from <linux/string.h>.
The next patch will add #include <linux/string.h> to sha2.h to be able
to use memzero_explicit() there, so we have to compile the code in
purgatory.c with -D__NO_FORTIFY to avoid compilation problems in this
file.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 5ce1d42630000..9191e3cffc30b 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -12,6 +12,7 @@ $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 CFLAGS_sha256.o := -D__DISABLE_EXPORTS -D__NO_FORTIFY
+CFLAGS_purgatory.o += -D__NO_FORTIFY
 
 # When profile-guided optimization is enabled, llvm emits two different
 # overlapping text sections, which is not supported by kexec. Remove profile
-- 
2.55.0

