Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A3627280A;
	Thu,  4 Sep 2025 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001366; cv=none; b=LleY1iA6kNtkiaZ/t07aiUI+lqx8c3ot+Rtt7bbfrot9UeP4UelCMUOxxL8pJtK3s6HiTcPn6FAMcMZXBk3d9LGkdrZ2xC7yquba2cKAAvytqhOJrj7smpFhl4TZNVN54rlKRSKPStl63HdUoIxP8B/090998p5/DLFvQkjtqtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001366; c=relaxed/simple;
	bh=++78EraiCElD9h6mi5QBymKuLUN4E1rP7JT4uuryxiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k1QzCs5Ka6WbzloU5uD2Z8mDhs+ikooMPMNNmwYA23l9lES60eeeV6FGGZvyn9lj99CYYRJ9nHCICm+Lbv+DYS/wdDqRLsYwubVHJ5L9wy/TCxkmirkjfliC+Rdn+WnykoDvWWQgoSauHnVf2+er21k5j5JFK82JNoSidJ9UMTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4edCfML; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4edCfML"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiTI009079;
	Thu, 4 Sep 2025 15:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=0qIEH
	F+NhReDiJ1KXwvvM7Zed2GFXrgFvub+NRuatRM=; b=c4edCfMLka72OCq6qLMUr
	CJ6a+HcQRtmL42m9mcDqRLsz/+IARRR0CANsY6mV45v2AnxS+3tap/XUPqezMody
	p+hqWAU+JqXKeMMqw1dBmeCYAZBkNZjxeV0mPaP6OcvEhQJQecIM7qziZDZPPGaV
	SL2xFslsqvo3vKcBSDqPWfz8DsOH6eimXNGx8RWXDipVWl35JbTCKl+LVBnr/aHn
	byTNmHiH8YGq8BWes/lZuokdvoEoXmaEGHbowMAJTEJn28i0qQXCRPcWn3WsS7KW
	ZZcbakGno/2DtBtb9WYixbOSLHe3JYN3m01r3Qqoz2pm/y6vNe1UTt79RzXo6x+c
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt002w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedo8040082;
	Thu, 4 Sep 2025 15:55:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:52 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5E000707;
	Thu, 4 Sep 2025 15:55:52 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-14;
	Thu, 04 Sep 2025 15:55:51 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 013/104] crypto/algapi.c: disable crypto_check_module_sig() for FIPS module
Date: Thu,  4 Sep 2025 17:50:45 +0200
Message-Id: <20250904155216.460962-14-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-ORIG-GUID: sFsbe0sB4QwAuwwh9-i69gRvcT2miBmg
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b689 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=mbqz-xmviEEbvSKi3aoA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX1E6xFQWNSkdo
 gkPZ1mrFw7cwCfAcLjNT3DgLiuSLYMZoQTmRazHsalu4UFZVyCjrPuvTzxgGVv+oUqE08QpZ24Z
 Rm6jAK7K+JOIpJ42Yrs2u/5uRoANh5cDZzoJrS/vX6DJwgVcVcFvGoPq96kJvinMpsrUrh6w3oB
 hySENOh88Eu+j0zxEzNzQFCYYSpzbcONZB+TJvxbj2fq97UMvR0vXyYVs2gOMSZUi7vsgnK5Ohn
 CZVJInyqNneanmZwB1qTAQ1YuK/JodjLfNf4RivEm9i77WZYWnzYDAhMOVg7FlvmqZCDP5SdRyJ
 SXpm0PXryE2Q/ZxOMap2upuiNzUueuoqkBcSXxFgZqYhuK7mupdmfHPytkNid+Z+BiH97l4i6yJ
 2LmHvEu83XX4Gw7dhJwfgirNAnV7Dw==
X-Proofpoint-GUID: sFsbe0sB4QwAuwwh9-i69gRvcT2miBmg

The FIPS module is assumed to be loaded from a trusted source (e.g. a
byte array embedded in vmlinux, which is already verified by the boot
loader). We can therefore ignore it for the purposes of module signature
verification in the crypto API.

(One could ask what the purpose of this check is in the first place,
given that modules can always fudge their alg->cra_module to bypass it
-- IOW, this isn't really an effective security check anyway, as far as
I can tell.)

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 09faecd47ea7..54b8d4acd651 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -24,7 +24,19 @@ static LIST_HEAD(crypto_template_list);
 
 static inline void crypto_check_module_sig(struct module *mod)
 {
-	if (fips_enabled && mod && !module_sig_ok(mod))
+#ifdef FIPS_MODULE
+	/*
+	 * The FIPS module should ignore its own signature as it was
+	 * loaded from a trusted source.
+	 */
+	if (mod == THIS_MODULE)
+		return;
+#else
+	if (!fips_enabled)
+		return;
+#endif
+
+	if (mod && !module_sig_ok(mod))
 		panic("Module %s signature verification failed in FIPS mode\n",
 		      module_name(mod));
 }
-- 
2.39.3

