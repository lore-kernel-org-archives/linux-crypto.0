Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD6C32D0FA
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763638184; cv=none; b=KbKWLNNQXeWsOdT1lbQuq93tlsm9Pz7e85M0cMc2sbwdhACng9W4+3eMSSam4HLTCMWZJq5KtEcBeuXZwKkSfXNSTLeN0/rB8rROVnYwLPJeDRDfa17mhbvynMkSdH8IcMOdLvRe4tsuIIhdqVfQOhWFwlGZrSZ7Or0RxGhs5OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763638184; c=relaxed/simple;
	bh=QjSfCyEgCm9RZqKzsWRhC8ZWodHwP1xXxgSlCdrHkCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NldB2fOqcdol8b9G9REykHtReRtamwpj/9yjGGZO0vJtNcDokZz18PFQ8NXAWc8ylc9Ct75X4Gi5VlcDGfp+uhcHb54fCDDQT0EL1lxCChBqiTZ7iD64SVu0La4NvLuzZ+dnsUIQ1S7qXzeNLUOBrqDeUzKZRc9IA4s5ESNeJbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lCH+K6tu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lCH+K6tu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763638182; x=1795174182;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QjSfCyEgCm9RZqKzsWRhC8ZWodHwP1xXxgSlCdrHkCk=;
  b=lCH+K6tuPXsjZBbOsTaYxQ8+Y7DeCAfy1DGlg/traMLjWwHG+bbrwJVv
   zXGJIW6bRoNlkYlkrYs8aOTtLejvN7gelS6BilCtLJqrvAy7A9JKAxEwS
   FVFnQ88lK/M6H6DaLGc4FJAQubRFRoKQgsRyZK9Wui7yTtiVyYwh/A0RE
   tIk1NGswBX8D0102xtHypopxRV2fRTN/2c2nrsvQXSM9clOOWgIXo2MaZ
   GHKpascwBy0pr0Kgzrnos8VT6EhSEiGMLyWz76Jcl0sbF/ER2+mX95GmH
   uhXxh+4aAKjLonQqkOVD5s3BsEj6Y8cRP3s6X9hnQubveysJzdyYilXbU
   Q==;
X-CSE-ConnectionGUID: OI7HAS1aTpGlnzxdl1bNaw==
X-CSE-MsgGUID: +CbjAbC8QQS8GMli6CiBMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="77062472"
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="77062472"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 03:29:41 -0800
X-CSE-ConnectionGUID: kOHz9mVjQDGFpoK3G8rICQ==
X-CSE-MsgGUID: BetUV0jbQQyAXWGMxCzJdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="190617729"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa010.jf.intel.com with ESMTP; 20 Nov 2025 03:29:41 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - fix warning on adf_pfvf_pf_proto.c
Date: Thu, 20 Nov 2025 16:30:46 +0000
Message-ID: <20251120163048.29486-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Building the QAT driver with -Wmaybe-uninitialized triggers warnings in
qat_common/adf_pfvf_pf_proto.c. Specifically, the variables blk_type,
blk_byte, and byte_max may be used uninitialized in handle_blkmsg_req():

  make M=drivers/crypto/intel/qat W=1 C=2 "KCFLAGS=-Werror" \
       KBUILD_CFLAGS_KERNEL=-Wmaybe-uninitialized           \
       CFLAGS_MODULE=-Wmaybe-uninitialized

  ...
  warning: ‘byte_max’ may be used uninitialized [-Wmaybe-uninitialized]
  warning: ‘blk_type’ may be used uninitialized [-Wmaybe-uninitialized]
  warning: ‘blk_byte’ may be used uninitialized [-Wmaybe-uninitialized]

Although the caller of handle_blkmsg_req() always provides a req.type
that is handled by the switch, the compiler cannot guarantee this.

Add a default case to the switch statement to handle an invalid req.type.

Fixes: 673184a2a58f ("crypto: qat - introduce support for PFVF block messages")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
index b9b5e744a3f1..af8dbc7517cf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
@@ -148,6 +148,16 @@ static struct pfvf_message handle_blkmsg_req(struct adf_accel_vf_info *vf_info,
 		blk_byte = FIELD_GET(ADF_VF2PF_SMALL_BLOCK_BYTE_MASK, req.data);
 		byte_max = ADF_VF2PF_SMALL_BLOCK_BYTE_MAX;
 		break;
+	default:
+		dev_err(&GET_DEV(vf_info->accel_dev),
+			"Invalid BlockMsg type 0x%.4x received from VF%u\n",
+			req.type, vf_info->vf_nr);
+		resp.type = ADF_PF2VF_MSGTYPE_BLKMSG_RESP;
+		resp.data = FIELD_PREP(ADF_PF2VF_BLKMSG_RESP_TYPE_MASK,
+				       ADF_PF2VF_BLKMSG_RESP_TYPE_ERROR) |
+			    FIELD_PREP(ADF_PF2VF_BLKMSG_RESP_DATA_MASK,
+				       ADF_PF2VF_UNSPECIFIED_ERROR);
+		return resp;
 	}
 
 	/* Is this a request for CRC or data? */

base-commit: 8faa5c4b47998c5930314a3bb8ee53534cfdc1ce
-- 
2.51.1

