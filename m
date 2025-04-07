Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760CC2EF
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 04:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001882; cv=none; b=c92TkUvhMjX3Xr1dha+PwwhbyTcfkrwU9N17tiiRHT8mmkSIrcJ0sz/z5y7OK8kGVtqHq5zWx6FjzxpcLxqU8fX4qoBLmBPmS7KIErRFSjM2PUHWv8cYuroWqpiWivc1rJE0F72y1o+PeXVyfvU7D4qZva+sPrwpJyaNI0ckuzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001882; c=relaxed/simple;
	bh=WBJqzB2NmNV9oHhh89FyjUf4XzjAjJAPnDM02eOitfg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VXBR3dSCvj6tOBSUQP0gEkfiq9VowIRFgZl/pn7XT3hqV6XfZ7tygt1KE9uLLD2SgQY2Mt/IzRF0NgSn92nkyEQEoEBxA/hL3fA+mz0ZaWw4IJU7YCZQLGWOwL5QgV3ygDrbx+CWrliBjuPRDLDrZrcr4WkreieyRkG2Ln/MjJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dAtXOppo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dAtXOppo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FTSumES0UaQSPDs9sh2NLCCoE3NjL2Fe1FRL3PQhBx0=; b=dAtXOppoHasFdGCNyOwljrzYow
	P6wD/gSG8QU6PfSYDMV8d8dnjEOp1vMZIbc/WJyklryTBK9Zhir82pZ3cm4I1v/HBZD01WzHxNoXE
	1cs6I1vjSJ8SzXh5twAfXHBL4fHZb66UeQFCbI/QcQMA8c07cMWMm+RCKbamn/xsd++AuY0FNHDPP
	UykIr6vlg3BCRozMDU3ccy3Vz2OrycAollMX2/8J6BUoze82EmpNA4zVADiLhFT3X7yAwNXQDzVh0
	FOUvKS5swYcIVETruzdrLhGyO+cvzB05evhjQ7tbhtJZ2eOlfU1fqQQWOBW7q7piekB5Qefz71/fp
	v+kih4rg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1eYU-00DN4K-0j;
	Mon, 07 Apr 2025 12:57:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 12:57:54 +0800
Date: Mon, 7 Apr 2025 12:57:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH] crypto: ccp - Silence may-be-uninitialized warning in
 sev_ioctl_do_pdh_export
Message-ID: <Z_NbUk4BkRLmdY5p@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The recent reordering of code in sev_ioctl_do_pdh_export triggered
a false-positive may-be-uninitialized warning from gcc:

In file included from ../include/linux/sched/task.h:13,
                 from ../include/linux/sched/signal.h:9,
                 from ../include/linux/rcuwait.h:6,
                 from ../include/linux/percpu-rwsem.h:7,
                 from ../include/linux/fs.h:34,
                 from ../include/linux/compat.h:17,
                 from ../arch/x86/include/asm/ia32.h:7,
                 from ../arch/x86/include/asm/elf.h:10,
                 from ../include/linux/elf.h:6,
                 from ../include/linux/module.h:19,
                 from ../drivers/crypto/ccp/sev-dev.c:11:
In function ‘copy_to_user’,
    inlined from ‘sev_ioctl_do_pdh_export’ at ../drivers/crypto/ccp/sev-dev.c:2036:7,
    inlined from ‘sev_ioctl’ at ../drivers/crypto/ccp/sev-dev.c:2249:9:
../include/linux/uaccess.h:225:16: warning: ‘input_cert_chain_address’ may be used uninitialized [-Wmaybe-uninitialized]
  225 |         return _copy_to_user(to, from, n);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/crypto/ccp/sev-dev.c: In function ‘sev_ioctl’:
../drivers/crypto/ccp/sev-dev.c:1961:22: note: ‘input_cert_chain_address’ was declared here
 1961 |         void __user *input_cert_chain_address;
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~

Silence it by moving the initialisation of the variables in question
prior to the NULL check.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 671347702ae7..c9ab4bd38d68 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1968,15 +1968,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 
 	memset(&data, 0, sizeof(data));
 
+	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
+	input_cert_chain_address = (void __user *)input.cert_chain_address;
+
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
 	    !input.pdh_cert_len ||
 	    !input.cert_chain_address)
 		goto cmd;
 
-	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
-	input_cert_chain_address = (void __user *)input.cert_chain_address;
-
 	/* Allocate a physically contiguous buffer to store the PDH blob. */
 	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
