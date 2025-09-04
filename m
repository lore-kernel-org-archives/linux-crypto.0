Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A99B23A98E;
	Thu,  4 Sep 2025 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001677; cv=none; b=GzIAWzuwAlQf+3CqFK8FKlR8Tyogt4mC6Vbe5lcf2Dgnt4Cpxq0dBSzDDAyUGeRdHZsVggs3tdeAsZUwkZTyjwrAf8C9IiLiNTW59E9Rm1lWv9V6gCvtYf2RLwT27RG2sDbiA+MtpBH0/7AVxB5FABZARPC1OfIgw9QiGgp1NWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001677; c=relaxed/simple;
	bh=u98f37ho2htAmvDBAdK4cf/UxpiiUnPNVbqMslPYKcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kRiUlxbuaQQxkPnWlKo/olvoAI4VJHCs9BjbgU8Vm5B9tIqK8kQYiTk/J59R8x1Bzk/cH3D7IpvwZdS0hs7H2VYrz0az/70FnsKGnn6vx+o4fK307b3xXdDVD6hKwft0coK5VgittNeXHPYFdh9z83iaW555E+Qo9GNN3LTlDFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IBpoCpwB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IBpoCpwB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmVT014916;
	Thu, 4 Sep 2025 16:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=FJjct
	W4+jaXoV8zG7Krm2cHp+g4qgBot3bEJNszkVGk=; b=IBpoCpwBU1az0WaQTVgRm
	4b2hRaUHiH5whp18lM0Fqpzo6YUYtMMVlCoIuailLGrj+wpALzlPoE/tNAe8XrSq
	YpBgF4D/kW6kl2u6h/iD51WUiD69rXZVwIvVVNvTG6XKmU4kDwkLsiQxCgd2I99N
	kL1tvuJKvdsdlbeB/Tx7q09dxg9Z/GEVXN27hSp1pCm/6XkTrx3GGr7zZpJDGSF6
	02HKQv9RA94WlXWjAXqCn0wqX+yW4hFD7JiBVgks0MXLfbF9g9mYAaJRmSDLdW0k
	fezgoHkiiDnM/Rqf7xpsEQuf2Fe9j2B09Oj7N85qALOrydrz3UxdrrbWTZz2GwEO
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0ckt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FM8Iq040108;
	Thu, 4 Sep 2025 16:00:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7o000707;
	Thu, 4 Sep 2025 16:00:58 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-92;
	Thu, 04 Sep 2025 16:00:58 +0000
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
Subject: [PATCH RFC 091/104] crypto: fips140: manual fixups for include/crypto/public_key.h
Date: Thu,  4 Sep 2025 17:52:03 +0200
Message-Id: <20250904155216.460962-92-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfXxR5maoddVcS0
 KAeGytTD4aScwvNeVxWtXUlZgII6PfI+WGEDMhN1eeoGKvv9dlo9OaUAQPIz4Y+mc/v24pzSfue
 rZNj/sr1dpOxvseoiJUzPdOS57LeTvGoJZoLGvZ2cjob1/evyyqZgBiIlKFe6WoteNMa5o7VaI+
 NfLARZNCSs50KHWukrpkCBHobUY+8pDHAHWsMbLmwFA6DljJ6Yr1a22pYv+bg1YIb3EVL6yQOkf
 GnVzghV46K2en13bn0thG/UG9BqWpqmmVrqNvoerCa0wkL9/lvRk1WFVWA01i+r+rOVIv8anR3e
 +8prtQlpTsg7xTF2jb384mpWNb+C0hes3nPhZmQc1WFzy0bUQEeKuylWjlvf+d0+r3cigRegdta
 koZ8acj3EpDr25A4rVXLqdgwAXTS3g==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7bd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=29rXXrdbV6PtDPAKsI8A:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: Vb_2L-axuBbrttKIR7otoLenYqVt9qWN
X-Proofpoint-ORIG-GUID: Vb_2L-axuBbrttKIR7otoLenYqVt9qWN

Define fips_/nonfips_ variants of public_key_subtype when the kernel is
configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/public_key.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index c8f30adbd655..b995644b0c92 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -58,6 +58,14 @@ DECLARE_CRYPTO_API(public_key_signature_free, void,
 	(struct public_key_signature *sig),
 	(sig));
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define public_key_subtype fips_public_key_subtype
+#else
+#define public_key_subtype nonfips_public_key_subtype
+#endif
+#endif
+
 extern struct asymmetric_key_subtype public_key_subtype;
 
 struct key;
-- 
2.39.3

