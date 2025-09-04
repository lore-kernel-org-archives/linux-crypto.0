Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515F31F4262;
	Thu,  4 Sep 2025 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001682; cv=none; b=tTwZmG7xdlGUyG5bgNLlTbdUoF9d9gnutUH7bDZ9bfHW1vcS1uFS07lTSqhy9h6Z7d+cgG3oFn+zR75AZlv/ZuT/p9+C7HdBSBUkOYSNOE+nPzOU6VkcfAJ19lexTnMIKVRvcVvoEznTdgy50REIPgZvgcCzDsTFBcWXNPBVGQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001682; c=relaxed/simple;
	bh=TpldjCqKmkbzAau3eAh8dk/9F9/dhCv8nTaLxqrdruE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lHD6aB3gQ5CM4ZJ/6I1j6JBWhSzqTJJXx3jpx1ZM1Na9mcTc52gq2pOc/NhJoxKOvsn3pLCtnY0dxxjd6s68/mNtVSXf7PmVGtjOI//WRobbUodVrQnRreBkQmEoxg9xx1ttAbofyuhXx2VXzlulFrQVkOBQibmNALFWpEs0Jd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KzF2qrJY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KzF2qrJY"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftmk0014920;
	Thu, 4 Sep 2025 16:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=21jWU
	s/rkVbvbvDvhfNI7i4eNB9i75TDGLUff35veBY=; b=KzF2qrJYnCcOCNty4nNKv
	ZC0j+OJRkYeYoYLn8gGYeaozDLzPc6vfKgoTP7rkBpznjnGQfWMUEyUUmbh+qQ7y
	ZMZP+3V+G9A0m7yd1RM6HfVTZXflqwc1v/tlApjLh//9yZF0e84LXobQ6BU+9KU7
	IbibqA9bHzHKJ/IQOtbKdHKxsGqXvGzPLT3FgT2CiWZkTw3qH0nxuIIszUxMCN/O
	pwxxRn6LAKblGj+qYoLz/j0BiVlaQxH6Jkc72U2HQjOvqko9pVySQmFA+eZA7MO3
	1RH2DbRwXI3VJf3kFYArS1ZNi2cqGNXlQjIkxlyCSnNwR7yeBwUdjEwI7+Gz5jKC
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG615040116;
	Thu, 4 Sep 2025 16:01:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:03 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7q000707;
	Thu, 4 Sep 2025 16:01:02 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-93;
	Thu, 04 Sep 2025 16:01:02 +0000
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
Subject: [PATCH RFC 092/104] crypto: fips140: manual fixups for include/crypto/aes.h
Date: Thu,  4 Sep 2025 17:52:04 +0200
Message-Id: <20250904155216.460962-93-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX3ZpSJRqVpRpd
 c4NTb06TAQyBdEXTom3QVVxs/731iw0LhVbhLqYlUXEDiKMlyuU5lZtyBCHboz93ctyh43hUE+K
 DosjisHNzuE/0oA54ZPZMtsfQ6Yt4VrhVZ2VdT4BOA59C5ZHnFz3TT321rqdYxUvKXmO96X9prR
 +KLAgGFBk9CWOkA0BcIeiPN5KYp+UxkRZy7CZUUn8xsBDksZw8Vpnyv/yDcgZOnSnmCwaEko/3U
 91R1CjlU9mdfPCtYSB9ZXSd9X/LTrwBYLkYqfNtB6VbI2FK80kLV7NkR7zjntLpK8T0hVVNGVM5
 UCenH0uN8QXPg1RSnqallEXHcP1fuRkTVjtu9z36cxM/BdcdmEeg5TM+P1+Fz/SwZDj/dZxtycF
 h3lGqkLWhm/91e/8GpY86106hmR/pw==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7c1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=ifZSoDu5pcwbtJZEpGIA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: VyR-CH7QOS6wrZsvfXbl-bHl82SshJUN
X-Proofpoint-ORIG-GUID: VyR-CH7QOS6wrZsvfXbl-bHl82SshJUN

Define fips_/nonfips_ variants of crypto_*_tab when the kernel is
configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/aes.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 6a732ea5ee1b..77f5515c49c9 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -29,6 +29,16 @@ struct crypto_aes_ctx {
 	u32 key_length;
 };
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define crypto_ft_tab fips_crypto_ft_tab
+#define crypto_it_tab fips_crypto_it_tab
+#else
+#define crypto_ft_tab nonfips_crypto_ft_tab
+#define crypto_it_tab nonfips_crypto_it_tab
+#endif
+#endif
+
 extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
 extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
 
-- 
2.39.3

