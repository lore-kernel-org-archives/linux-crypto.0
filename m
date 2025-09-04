Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5520B283FF8;
	Thu,  4 Sep 2025 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001726; cv=none; b=AvEl+4vcEo4hjWy9JHq2gm/hsmAJiIYXLEWdqk8di0hF6oYHVmZRMwo7yjA7S1XRbVT2TeE0rRAbOpxk+CPLsgulEx+2PM0oTJ11il09xhdf/iD8HfEF5K4RMY1KkrLH4LyaqfrcigVYgh2Ma4iPnM6y2SeHE/9vJXJMqZxVw24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001726; c=relaxed/simple;
	bh=lMvTfcV5vruLyTd9beQ8fzOvORovIlOMalb+f3ZjF7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZzCXXT3SthP6rmj1QqZfsFg+RsKyi6D1pBcnXWqv2FLIGPxUf9Y6lMPRRwW6C413RFYGA+vfB8JMoN8/Rt1B4BZRPzjp2HGVy9RJqyXF+hSHFRxQ/+I/A8ZCyxZD1odUuqnlmAuVN3pU+HYm4Bd/30y3U2QP9pfptD6m7AUTDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V7Xbyn9m; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7Xbyn9m"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fulw6004103;
	Thu, 4 Sep 2025 16:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vU8Md
	Rs4p62Jp2ovFUXgWd8jo2RmWlrKkCij1V3CZlI=; b=V7Xbyn9m7j+AnCBwCAA9i
	O86CZLYOZe7BZfiqVxLnELLVABm0mTlP3dyNKfz8qDcqRpWrUzdZ1A+Vq6NjtTpE
	kWmvRId/QYVulpXjyw4C8bKIuLHu3TxCd9ZjyKFXfUevwxMNC6PVNqDhxI4JIVjl
	zUJKw01RRi0IQyN89l/BFSAB0pugvgL8S8WsFfekSIwZkjV/Cxf4nLSQKS0Fujfn
	aKSbtykX1Pv0YWdAGF4WWhBQy0fMljX5GA8hIeeYw0mWUcG59PC3Y1XE2uYH3983
	FumeSYk47jKmVIXehBgF0wzzhmfx3DrTvXqEvnrBL+NJjaWwOQVDScK2wRda2su3
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun00by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG61h040116;
	Thu, 4 Sep 2025 16:01:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtuef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx8G000707;
	Thu, 4 Sep 2025 16:01:49 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-105;
	Thu, 04 Sep 2025 16:01:49 +0000
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
Subject: [PATCH RFC 104/104] MAINTAINERS: add myself as FIPS140 standalone module maintainer
Date: Thu,  4 Sep 2025 17:52:16 +0200
Message-Id: <20250904155216.460962-105-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: 5uMIJN015mzg6iQ-_bWL_8GIN3xvc8Jx
X-Proofpoint-GUID: 5uMIJN015mzg6iQ-_bWL_8GIN3xvc8Jx
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b7ee b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=FNyBlpCuAAAA:8 a=J1Y8HTJGAAAA:8 a=VwQbUJbxAAAA:8
 a=UGG5zPGqAAAA:8 a=yPCof4ZbAAAA:8 a=z673ita4JYlaY3I04V4A:9
 a=RlW-AWeGUCXs_Nkyno-6:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=17ibUXfGiVyGqR_YBevW:22
 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX66AgRkCvn3WU
 dwt743xlRjt/xjhedWOp5RHFVxjQqcZ7pR51PDTA1zTJu38THoTkO91u1n1X3vIVEQviUUcRTqH
 rVBPlcZtBAjg9Z4z9E7u/N1TcEsIu6Xzg065spLi5DOVHCxGyMki5uxzJX6fWEKJty+REMhtb3H
 1Zm7wd0+28fJ9SWcVt93CadQFJ9LvKhyy+rGRD+J9LqpHcPIjtxKAyJMb5b7bU7BjSXlJgIRA96
 RJcEBdfUNLDK1qElJPmteDiKU25dxtPw5c9GUljm6qow3U9a+wJd8OEZMbRe3kLgH5Fxf5VRsvZ
 m5an5nzlXZ/oUgcKbz2zCWw1elCvujH2dtHNppvp/1YF8INWULrgm5gD94X9z6QWLqa1zTnht+9
 bdtvs4EIkbWrCyCTIcGg3c2ML6zHww==

As a gesture of accepting responsibility for the FIPS140 code, add
myself to MAINTAINERS. This is not meant to override or supersede
crypto maintainers and in fact I'd expect any FIPS140-related patches
to still go through the crypto tree(s). I encourage others with an
interest in the long term maintenance of the FIPS140 code to add
themselves to this entry as well.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index daf520a13bdf..655c32f47343 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9467,6 +9467,16 @@ L:	linux-can@vger.kernel.org
 S:	Maintained
 F:	drivers/net/can/usb/f81604.c
 
+FIPS 140 STANDALONE MODULE SUPPORT
+M:	Vegard Nossum <vegard.nossum@oracle.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	crypto/fips140*
+F:	fips140/
+F:	include/crypto/api.h
+F:	scripts/extract-fips140
+F:	Documentation/crypto/fips140.rst
+
 FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET STREAMING ENGINE
 M:	Clemens Ladisch <clemens@ladisch.de>
 M:	Takashi Sakamoto <o-takashi@sakamocchi.jp>
-- 
2.39.3

