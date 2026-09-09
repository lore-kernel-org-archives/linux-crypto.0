Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A199548576
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954958; cv=none; b=o/ydJIH+yPtMLtDZLdRKk91y1iWHMFaMArwdbPh9OzAp970fWo1GcMuZ2Vs7qWVucyAeraaPQaVa546wdAD/XecaGNHO8HItfMLiTo0ZviLTIVtLqqmQNso+1F83vyJZqTDSoSC5fFyGIBpV1ytb7QrFt1QprjzM8yAX/pmBGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954958; c=relaxed/simple;
	bh=GNqEgrb/+sZ74TXSrcPeteUL+J+8OTzaBVlLilJkm0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDY03+D3sIUNgu0F1ARtFXLSW7qVPGJne0kLSLZJepQxfNLKY4mQp/AMUg7GD4de1PQKPkvrpW6mm8KVb1ZTLT72kpoo35bxPavgP6/URZxCAiu7KXWvC6bo1/wLpvppDjRSKqiexm7ENXOSWg6Fw5hDaSHITeHnSDN3XtdX5Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c8YHfd/0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c8YHfd/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788954956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzI3o5Wk9Ztm1nJZ2Q+wYHNX0B3JnIKhbrRiMd/8awY=;
	b=c8YHfd/0enRIm8KPJsPCD7ehuzpf1ywsaX/EgrXyuRqqVC/ce2/spTSJBB24oEbVJzvy1D
	dC+CPrhjU8k6b9Xs0SGNvLS2j8OER1JZxAEpldXdQD60azVQEf+n9cYi4n5EUpiGL5dobk
	3y/NWyWNRXx3TN0vFHfLHQ7qWZuDZJA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-NWfyhj1OPraS-1r2Ux0jCA-1; Wed,
 09 Sep 2026 07:55:51 -0400
X-MC-Unique: NWfyhj1OPraS-1r2Ux0jCA-1
X-Mimecast-MFC-AGG-ID: NWfyhj1OPraS-1r2Ux0jCA_1788954949
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B535F1955DDC;
	Wed,  9 Sep 2026 11:55:48 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A6D5B195608D;
	Wed,  9 Sep 2026 11:55:44 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 10/13] x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
Date: Wed,  9 Sep 2026 13:54:46 +0200
Message-ID: <20260909115455.157093-11-thuth@redhat.com>
In-Reply-To: <20260909115455.157093-1-thuth@redhat.com>
References: <20260909115455.157093-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

A subsequent patch will add #include <linux/string.h> to <crypto/sha2.h>
to use memzero_explicit() there. This will introduce a conflict with the
purgatory code: purgatory.c includes both, the <crypto/sha2.h> header and
the arch/x86/boot/string.h header. The latter provides its own prototypes
for a lot of string functions which clash with the fortified macros
from <linux/string.h>. To avoid the problem, compile the code in
purgatory.c with -D__NO_FORTIFY, so <linux/string.h> can properly be
included from <crypto/sha2.h> in the purgatory, too.

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

