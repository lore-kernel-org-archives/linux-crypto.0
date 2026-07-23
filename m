Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE348380A
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832415; cv=none; b=M5lidPsdK6RPte1QMPFLkq+tvLzpQpV+WkviXWlGiwNJT4YUSYtJetd8DKZvBoe/Zw99HU+TuQaZAMreu8jveWLp+FxDKlziFP1kLFwftiHn7P0BZ7uEPkktXX8PTBJ7qwLB2oO8oCD28/Vye/EhAJul+uOwCreesjz0Q8v1cQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832415; c=relaxed/simple;
	bh=2XerIORtjYT6lU/QCxj94nR/+mthwLJM8r1lYonXQgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7/DPocGh1db040beKbstWu8Y5br+R8ScSHexYCPMwQyPSqDXuhB80BhCNh5ld2QW3eLfzQoKRYGwEQu4J5Ffo+p3GUioJd6piKp1LHs3irYDM0DbnmiYLFmC47d2EHjQDP8nE4CSj0aCSymE370uQtsChNnsxoS80wHkHzvGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQvez56A; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQvez56A"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so917833a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 11:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832406; x=1785437206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MvMxjqNvpASivPiDAcPmI8PwBsKAarLbQdQ8wRHMWv0=;
        b=CQvez56A9PDOxPPkjW5dr+x5rcO2ncfLNjk2XekL77va8AYlax4uwKC+xoCZJFyldM
         9vXsoTXkWPSFVSM4MdfBePJi6fZvBAL5HmB5g1wE+uOXC9uE84R+lgGI5ZetHTHgdw/X
         r0iFOg1smVEQIxmlVQEjPpJabbo0FLkky0ntrUSTvgZzAN9dl/1EiOig0CvQ4nbcEwJs
         aun1+YDL2wPVMTrkRGSiprOEqbJMNZaq+vpIaGhrMMmUjKtqBLBd2uiRZO8OZxg5CnQ8
         6MRIol28m6RCnLrt0OwdUdIq1I4EEuqXcAVd3aYayTm5u8GSqCk+SkqQD2mUiU86TWTj
         gSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832406; x=1785437206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MvMxjqNvpASivPiDAcPmI8PwBsKAarLbQdQ8wRHMWv0=;
        b=XWwNENMuuKmk27/yN5rVBXXoRQsZ3gGOcUQvs7L/7mXinFqAhVtywGpZCHxbrDa5hz
         /duUvwOnHg80PL1QBTclTgw2KTUub1ezqcHfz2CQ3+sc8zfob9HzxMYXO2rbLbE16z57
         br6fwkomhC4ZIfXl95h5RgOW0+bbPcAelCMuG+Jwpgnwbwx/ngj0sEZwg//AwSu6MKSi
         3yfEG2pBalyauiJQdh86P5U3Y7qaAOzUWRQ9l9MCH0frcudXRASKeBdXRa/Gq+39c58j
         Z+oN2s9JIKw46CUXKIozEhT0cRkf8Q2kkNWlQvWwAMB7AXR7fghdiqFs/0axL3HLxo0g
         cDMw==
X-Forwarded-Encrypted: i=1; AHgh+RryQ1wVzBIl9cx+x0A/kHY2JMhNPvVbqx9VDWfCFhkJ4Yc3k+pCbI1y3vh+sr/RL6eD5lUHYgpDz+n5yZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGajujFsjppG7iTb8/LlLLPBXlMm33b2Q7uz7tAog15y74DLsW
	nwNjjKX24DvOB5WEdsTGhWqNy80gUHCptHqirXQJiAHid7fOTvZGLcJV
X-Gm-Gg: AR+sD13QMDVjZIBB2cLStRQ5jPcJHJQTxiV6wiQ8tckig2q4mCLkWmnEo/OH9nxOt3z
	8j4ZPH+0emBZwuCs+B91z+sVZXRrnEMRKPCe7JY5TkCaxDt5XOJK4PxP5+Ytwow69syRf2k7/f8
	6jxyHAvTk74jBUl1MIRdyUjqzTklgHvzSqggMBcVzfIprHrio8zPy2H4kCXZchsYXRvp8OmjaB6
	2DgCXtXH+FT1GhjHyfO47SxUQVTwczybdXlxo2GkCTjzholtbF+LtRhd6olTG0EfHNc3rljcQk1
	hk8mH2v91YV3fH86K6JQOWyst30uggYE3nct5f3IkRgPpigUK5587IJlb6HNBdqP6YbhmGWjI2S
	QVlbg59t2wgDXXH+AmPPDSIhji2H92Svbv3lr/0F5uC+U7BV3BCLKCIkVyR5olcP8EWBD9wGu
X-Received: by 2002:a17:90b:3904:b0:38e:584f:2515 with SMTP id 98e67ed59e1d1-38ec6aae88emr4263344a91.37.1784832406282;
        Thu, 23 Jul 2026 11:46:46 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:46:45 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: cocci@inria.fr,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 18/36] crypto: drivers - remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:20 +0900
Message-ID: <20260723184538.3888637-19-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen2_config.c   | 8 ++------
 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c | 7 +------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_config.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_config.c
index c27ff6d18e11..57025bffee73 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_config.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_config.c
@@ -155,12 +155,8 @@ static int adf_gen2_comp_dev_config(struct adf_accel_dev *accel_dev)
 	}
 
 	val = i;
-	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_DC,
-					  &val, ADF_DEC);
-	if (ret)
-		return ret;
-
-	return ret;
+	return adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					   ADF_NUM_DC, &val, ADF_DEC);
 
 err:
 	dev_err(&GET_DEV(accel_dev), "Failed to add configuration for compression\n");
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index 95f3de3a34eb..1542a110ba37 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -235,7 +235,6 @@ int otx2_cpt_lf_reset_msg(struct otx2_cptlfs_info *lfs, int slot)
 	struct otx2_mbox *mbox = lfs->mbox;
 	struct pci_dev *pdev = lfs->pdev;
 	struct cpt_lf_rst_req *req;
-	int ret;
 
 	req = (struct cpt_lf_rst_req *)otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
 							       sizeof(struct msg_rsp));
@@ -248,11 +247,7 @@ int otx2_cpt_lf_reset_msg(struct otx2_cptlfs_info *lfs, int slot)
 	req->hdr.sig = OTX2_MBOX_REQ_SIG;
 	req->hdr.pcifunc = 0;
 	req->slot = slot;
-	ret = otx2_cpt_send_mbox_msg(mbox, pdev);
-	if (ret)
-		return ret;
-
-	return ret;
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
 EXPORT_SYMBOL_NS_GPL(otx2_cpt_lf_reset_msg, "CRYPTO_DEV_OCTEONTX2_CPT");
 
-- 
2.43.0

