Received: from mail02.rohde-schwarz.com (mail02.rohde-schwarz.com [80.246.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB417DA69;
	Thu, 15 Aug 2024 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.246.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723714732; cv=none; b=S7AM1J5ySEXmOPodfK/7KQqUwCAd5rgl8XK7p3tUaM+GXcc3yskZ+X6oJGEvnQGnLSZqYSL4STugQ3NzXmVV5oa/zQwjgV1x4Bvs2URbkGg+swx/stHlY1byKYU8ei8AOdHlItQXXkVnUdovxvRjwJ/mxDejFTaeMyjdNihsXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723714732; c=relaxed/simple;
	bh=exZPANPQYNHESUMA8nzYYPjJNdOMyxngR0lhlAm2x44=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nzGSl8SPhlGqPs3WxyIM6FkX54g9WemvKRduxJY8rYY81dID9cTO4aD4nu2qd73mLdg1/As7RF4VnBYPf+uLUsjKGcVbSZUyw3iBU0UfCsSDLdiTh0NhbgCrtc20Wg0zDZcPmRTMctqKL7IgpplKg90u0hOBEll55VK4dPCxwrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com; spf=pass smtp.mailfrom=rohde-schwarz.com; arc=none smtp.client-ip=80.246.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rohde-schwarz.com
Received: from amu316.rsint.net (10.0.19.27) by mail02.rohde-schwarz.com
 (172.21.64.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.34; Thu, 15 Aug
 2024 11:38:40 +0200
Received: from GMU452.rsint.net ([10.0.225.105])
          by amu316.rsint.net (Totemo SMTP Server) with SMTP ID 562;
          Thu, 15 Aug 2024 11:38:40 +0200 (CEST)
Received: from GMU504.rsint.net (10.0.225.36) by GMU452.rsint.net
 (10.0.225.105) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Thu, 15 Aug
 2024 11:38:40 +0200
Received: from GMU503.rsint.net (10.0.225.35) by GMU504.rsint.net
 (10.0.225.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Thu, 15 Aug
 2024 11:38:36 +0200
Received: from GMU503.rsint.net ([fe80::957e:76:e488:c60d]) by
 GMU503.rsint.net ([fe80::957e:76:e488:c60d%4]) with mapi id 15.02.1258.034;
 Thu, 15 Aug 2024 11:38:36 +0200
From: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>
To: "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
	"daniel.m.jordan@oracle.com" <daniel.m.jordan@oracle.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] padata: use integer wrap around to prevent deadlock on
 seq_nr overflow
Thread-Index: AQHa7vbmBiWPqu6VjE+ESlTCdwzyZg==
Date: Thu, 15 Aug 2024 09:38:36 +0000
Message-ID: <370458fcfbbd452381ad0f8787293455@rohde-schwarz.com>
References: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
In-Reply-To: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-IQAV: YES
thread-topic: [PATCH v2] padata: use integer wrap around to prevent deadlock on seq_nr overflow /ur/
X-rus_sensitivity: 10
msip_labels: MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Enabled=true; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SetDate=2024-08-15T11:38:40Z; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Method=Privileged; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Name=UNRESTRICTED; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SiteId=74bddbd9-705c-456e-aabd-99beb719a2b2; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ActionId=8b69e117-7756-4ef8-b52e-ebe0297deaf4; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ContentBits=1
X-GBS-PROC: dRCQSVjCk7Qx8mr9czr5fRjIHEA8CC2Wd/bFf6fJm7z9iHxUTaznMFWagZkg0fa7T4nn3F8HW+l+s4ohwJoZyUo4VtkbAmOKpGv0/+ElS0FNfJ1Dtx8w8uBSCLp8KGwQ
X-GBS-PROCJOB: buzKt0rMdTzr5vYVJ1GuM5uACJ2qtSjCglomb5PQhjZYlFR4NpLLPciCAWpdd5BO

When submitting more than 2^32 padata objects to padata_do_serial, the
current sorting implementation incorrectly sorts padata objects with
overflowed seq_nr, causing them to be placed before existing objects in
the reorder list. This leads to a deadlock in the serialization process
as padata_find_next cannot match padata->seq_nr and pd->processed
because the padata instance with overflowed seq_nr will be selected
next.

To fix this, we use an unsigned integer wrap around to correctly sort
padata objects in scenarios with integer overflow.

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")

Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
v2: include Fixes tag and Daniel's Acked-by tag
v1: https://lore.kernel.org/a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.=
com
 kernel/padata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 53f4bc912712..222bccd0c96b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -404,7 +404,8 @@ void padata_do_serial(struct padata_priv *padata)
 =09/* Sort in ascending order of sequence number. */
 =09list_for_each_prev(pos, &reorder->list) {
 =09=09cur =3D list_entry(pos, struct padata_priv, list);
-=09=09if (cur->seq_nr < padata->seq_nr)
+=09=09/* Compare by difference to consider integer wrap around */
+=09=09if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
 =09=09=09break;
 =09}
 =09list_add(&padata->list, pos);
--=20
2.34.1
