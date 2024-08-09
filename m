Received: from mail02.rohde-schwarz.com (mail02.rohde-schwarz.com [80.246.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE833CD1;
	Fri,  9 Aug 2024 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.246.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723185423; cv=none; b=TOU53fkpNbF8VSHRjQ9dCJp7dPs0jxNHV74vuajYJxroVAOzFogLRRb/1cqH6PdbQxQEFBeXMdTRVe7a7DWm7a7gWdkFJEAyQkqJLu0z5jb43zFOPT5hrN7J4Zug/TtSfFQzkMR60c7w8c7USabdN43ZUvYdl+FOGlhJTn/BJvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723185423; c=relaxed/simple;
	bh=btnCYBy8fSiBo6Ja4Y9AjKiE/n6TsvQiaVI7wf0/wiE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KCRESiZmKyX08aW8OaO5GBpUnHuMSOaa/b70cDmtb1CqAr5JL3NC7yqzEiCLmfSxjI+ofDtQthuafOw+mPNeEtHpPWyFP+GcOEan9Kql3nfZ51AC2Eotz64tgOJSi4u2fPRAnLG7y8/yISgDuXGIxDbzG3haT8DcpmPG7MEFHEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com; spf=pass smtp.mailfrom=rohde-schwarz.com; arc=none smtp.client-ip=80.246.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rohde-schwarz.com
Received: from amu316.rsint.net (10.0.19.27) by mail02.rohde-schwarz.com
 (172.21.64.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.34; Fri, 9 Aug
 2024 08:21:49 +0200
Received: from GMU452.rsint.net ([10.0.225.105])
          by amu316.rsint.net (Totemo SMTP Server) with SMTP ID 277;
          Fri, 9 Aug 2024 08:21:49 +0200 (CEST)
Received: from GMU504.rsint.net (10.0.225.36) by GMU452.rsint.net
 (10.0.225.105) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 9 Aug
 2024 08:21:48 +0200
Received: from GMU503.rsint.net (10.0.225.35) by GMU504.rsint.net
 (10.0.225.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 9 Aug
 2024 08:21:42 +0200
Received: from GMU503.rsint.net ([fe80::957e:76:e488:c60d]) by
 GMU503.rsint.net ([fe80::957e:76:e488:c60d%4]) with mapi id 15.02.1258.034;
 Fri, 9 Aug 2024 08:21:42 +0200
From: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>
To: "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
	"daniel.m.jordan@oracle.com" <daniel.m.jordan@oracle.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] padata: use integer wrap around to prevent deadlock on
 seq_nr overflow
Thread-Index: AQHa6iREKZgToXN2E0GdhZ5E20hE+w==
Date: Fri, 9 Aug 2024 06:21:42 +0000
Message-ID: <a16995232eda4d39812f4bd94d9fb846@rohde-schwarz.com>
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
thread-topic: [PATCH] padata: use integer wrap around to prevent deadlock on seq_nr overflow /ur/
X-rus_sensitivity: 10
msip_labels: MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Enabled=true; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SetDate=2024-08-09T08:21:47Z; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Method=Privileged; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Name=UNRESTRICTED; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SiteId=74bddbd9-705c-456e-aabd-99beb719a2b2; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ActionId=8b69e117-7756-4ef8-b52e-ebe0297deaf4; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ContentBits=1
X-GBS-PROC: dRCQSVjCk7Qx8mr9czr5fVWuzofEHd7V+RhQ/Y7Zecbuxv749wSCLVxZbl5czdTdeFA5ceQaQVuWU7793zSJBnWsGbu6ROVIh05CyE4GVG90v/UYyRSNaGFBqwCsFZuu
X-GBS-PROCJOB: 8RUqtwpcqIC8nP5iRs1uDv2NSD0TL+fTUb+Ii6+YTEpoR7oUyw5w+xIWyuWMb0Ln

When submitting more than 2^32 padata objects to padata_do_serial, the
current sorting implementation incorrectly sorts padata objects with
overflowed seq_nr, causing them to be placed before existing objects in
the reorder list. This leads to a deadlock in the serialization process
as padata_find_next cannot match padata->seq_nr and pd->processed
because the padata instance with overflowed seq_nr will be selected
next.

To fix this, we use an unsigned integer wrap around to correctly sort
padata objects in scenarios with integer overflow.

Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
---
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
