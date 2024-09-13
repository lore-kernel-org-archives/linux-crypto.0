Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3288E1BAED2;
	Fri, 13 Sep 2024 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726236584; cv=none; b=bIESxudG2ItyIrNCCZA7jczOwdgjHjFMDnFI8KfiDFkWj2P9nLpk61FtaVhqneJ8bQSE2KXo/pGF5eo+kv3WtUuVonJ/Bw0kbl75TBmLY+AVW6+gtJP4ipHOAosfJTZEZHKlrF1TyTYcp6jesgmp7JD80Evowz7O/bvKX/VaLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726236584; c=relaxed/simple;
	bh=nqo68CPwAeNTVOVaefx2dhA5D1MSpDN47SUiXsxpTLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=elFSeSaAChW+lG5hIjm0zgL795t/Zk56zDHff3C6xHYDsyCUcJ5tYEOuY1tEh2kbczCNmLZfszM4bzSCTnfwjk0LBo+03UD6Ot8tYn+weqmtm+o6Vu2SpqKqTulAsNYeIDwHTBGFU6HKzhkX0aYXRSnLmMBZTqWNn2ajfEvqFto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DLWyAYUa; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DLWyAYUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2XYm+
	sihFrep2cxVYONJkXmPAq6DNiuqhawRHHOXt/Y=; b=DLWyAYUaMdRMAR9XV5qrv
	IkA27P4Wvmc4y/a9doo9KKoc+VCof0FlFJTFzhvNoSZb71+vZ0R4EHpCBHcapDGX
	39YhXQztIjTQMQXS99WiAJJ5Xw3tA9aK4+hzAJEAKzMHNbA/6aBsrguQciyPFObr
	kW11Wb9Hevu8fIDK1ZJwt0=
Received: from localhost.localdomain (unknown [58.243.42.99])
	by gzga-smtp-mta-g2-1 (Coremail) with SMTP id _____wD3321oR+RmyEEhFw--.58616S2;
	Fri, 13 Sep 2024 22:08:41 +0800 (CST)
From: Qianqiang Liu <qianqiang.liu@163.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qianqiang Liu <qianqiang.liu@163.com>
Subject: [PATCH] crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue
Date: Fri, 13 Sep 2024 22:07:42 +0800
Message-Id: <20240913140741.5944-1-qianqiang.liu@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3321oR+RmyEEhFw--.58616S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFyUtr17GFyrZr47JFykuFg_yoWxZrg_GF
	9YgF10qr10yrW0qr4rKFW2yr4I9r4fWrWrK3WxGryUKasFyrZxuFnrXr1qqF98urWSqF43
	ZwsIya45Ar13AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRiubyJUUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiLwlZamVOGURLQgAAsq

The "err" variable may be returned without an initialized value.

Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
 lib/crypto/mpi/mpi-mul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
index 892a246216b9..7e6ff1ce3e9b 100644
--- a/lib/crypto/mpi/mpi-mul.c
+++ b/lib/crypto/mpi/mpi-mul.c
@@ -21,7 +21,7 @@ int mpi_mul(MPI w, MPI u, MPI v)
 	int usign, vsign, sign_product;
 	int assign_wp = 0;
 	mpi_ptr_t tmp_limb = NULL;
-	int err;
+	int err = 0;
 
 	if (u->nlimbs < v->nlimbs) {
 		/* Swap U and V. */
-- 
2.34.1

