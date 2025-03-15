Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ADD192B8F
	for <linux-crypto@vger.kernel.org>; Sat, 15 Mar 2025 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742028649; cv=none; b=jV5b90/vhyJpSM+HQO/iTdSU57AdGmbD+V5xnUaeXXFBPMmjqqmNsUhR/bjfJ/FAgbwfW9/pUJSqWyHBzfFsl3Q4xvUBIlWHKDhkx3GBq8oiM3FGK7JH5z7CWLYtxAcm6bDhZst2lAPASIvS4OgA0OOeY4bt1A4jcccd/HR1/1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742028649; c=relaxed/simple;
	bh=Nx7gKDaqz/DACd76LjUwGeILNxxobbwHG4gpYHMrq40=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GOjK/AZTQ6EgNMnhHK7GJSuWMOox7I87xLmQ+/Ug3WWfwwR0XwJJD6aPXdX49xzlefsfZ6O5DWog9SLNg7xFYcHdR45KiJRRqD8CBtKEX8gO8FAccpeuTuGo+EjnV/rvMVtoHcffLHAyx/SxHfevvU5DJ8fmEGJJo56173htdCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AZoTah2s; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AZoTah2s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6eYK+wBwjkxoVbgleuq0INJrlF7qXyrJeT70VtdwxJ0=; b=AZoTah2sWbMWrHGQfGuS6c1xQb
	sPHsUdw8oOfbDeZxuZFAVPmwJ36Tqj/V8Yqd+f4LKlVqOf1kVcJa+Dd4/FXwWrxlxARwuDyxY//2a
	RtCYpqRgcyXOOrYlhPQNA/ok+7pYXwRpgaeUm7P3LOPIvtRvvT+0o91NHWCOdtkKNJtQXNgKj0GPK
	q1FBMe46F+8m96mUu8RvNYtEMvrufZLbgRP54Sfxx3ZF/bkeu1cHG8hEkEfVRXM0F66zAEXFokin5
	3ouiNuVx4Ys68DTQrrkuWg4blRpDk7a4jz3nV199S+xqWaBwQy3bBDTHCmreNQ90v64811Lx+5P18
	4HUKgMcQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNEA-006nko-0t;
	Sat, 15 Mar 2025 16:50:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 16:50:42 +0800
Date: Sat, 15 Mar 2025 16:50:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Haren Myneni <haren@us.ibm.com>
Subject: [PATCH] crypto: nx - Fix uninitialised hv_nxc on error
Message-ID: <Z9U_Yu4yWxJGTk0T@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The compiler correctly warns that hv_nxc may be used uninitialised
as that will occur when NX-GZIP is unavailable.

Fix it by rearranging the code and delay setting caps_feat until
the final query succeeds.

Fixes: b4ba22114c78 ("crypto/nx: Get NX capabilities for GZIP coprocessor type")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 1660c5cf3641..56129bdf53ab 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1145,6 +1145,7 @@ static void __init nxcop_get_capabilities(void)
 {
 	struct hv_vas_all_caps *hv_caps;
 	struct hv_nx_cop_caps *hv_nxc;
+	u64 feat;
 	int rc;
 
 	hv_caps = kmalloc(sizeof(*hv_caps), GFP_KERNEL);
@@ -1155,27 +1156,26 @@ static void __init nxcop_get_capabilities(void)
 	 */
 	rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES, 0,
 					  (u64)virt_to_phys(hv_caps));
+	if (!rc)
+		feat = be64_to_cpu(hv_caps->feat_type);
+	kfree(hv_caps);
 	if (rc)
-		goto out;
+		return;
+	if (!(feat & VAS_NX_GZIP_FEAT_BIT))
+		return;
 
-	caps_feat = be64_to_cpu(hv_caps->feat_type);
 	/*
 	 * NX-GZIP feature available
 	 */
-	if (caps_feat & VAS_NX_GZIP_FEAT_BIT) {
-		hv_nxc = kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
-		if (!hv_nxc)
-			goto out;
-		/*
-		 * Get capabilities for NX-GZIP feature
-		 */
-		rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
-						  VAS_NX_GZIP_FEAT,
-						  (u64)virt_to_phys(hv_nxc));
-	} else {
-		pr_err("NX-GZIP feature is not available\n");
-		rc = -EINVAL;
-	}
+	hv_nxc = kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
+	if (!hv_nxc)
+		return;
+	/*
+	 * Get capabilities for NX-GZIP feature
+	 */
+	rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
+					  VAS_NX_GZIP_FEAT,
+					  (u64)virt_to_phys(hv_nxc));
 
 	if (!rc) {
 		nx_cop_caps.descriptor = be64_to_cpu(hv_nxc->descriptor);
@@ -1185,13 +1185,10 @@ static void __init nxcop_get_capabilities(void)
 				be64_to_cpu(hv_nxc->min_compress_len);
 		nx_cop_caps.min_decompress_len =
 				be64_to_cpu(hv_nxc->min_decompress_len);
-	} else {
-		caps_feat = 0;
+		caps_feat = feat;
 	}
 
 	kfree(hv_nxc);
-out:
-	kfree(hv_caps);
 }
 
 static const struct vio_device_id nx842_vio_driver_ids[] = {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
