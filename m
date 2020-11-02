Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DD3C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 11:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F08192076E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 11:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgKBLTE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Nov 2020 06:19:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:22909 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgKBLTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Nov 2020 06:19:04 -0500
IronPort-SDR: g19nmgtWmOvst89sfnf1tbL4BWUW+lKsXARijIctObK0DLQ8drASf1DRamNJo5umP3eZhTcS/m
 JwhObDxaNraw==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="253575769"
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="253575769"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 03:19:03 -0800
IronPort-SDR: exXf9gIIu47z4ZEa6YfCsbTywZw+0LyLQ/rMWrTwtDLwxiTLSn62U6Q5fDKZN8FpHUGAPgcitV
 5i121SeDZzhw==
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="527904799"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 03:19:01 -0800
Date:   Mon, 2 Nov 2020 11:18:53 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     trix@redhat.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, dominik.przychodni@intel.com,
        wojciech.ziemba@intel.com, mpatocka@redhat.com,
        geert+renesas@glider.be, ardb@kernel.org, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: remove unneeded semicolon
Message-ID: <20201102111853.GA693055@silpixa00400314>
References: <20201027190407.1587980-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027190407.1587980-1-trix@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 27, 2020 at 12:04:07PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A semicolon is not needed after a switch statement.
I rebased the patch on top of cryptodev-2.6/master as it didn't apply
after the latest patches to the qat driver and modified slightly the commit
message: /s/qat:/qat -/

----8<----
From: Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: qat - remove unneeded semicolon

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
[giovanni.cabiddu@intel.com: rebased and minor change to commit message]
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c      | 2 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index a38afc61f6d2..0fab8bb8ca59 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -105,7 +105,7 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 		return ICP_QAT_HW_SHA512_STATE1_SZ;
 	default:
 		return -EFAULT;
-	};
+	}
 	return -EFAULT;
 }
 
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index f112078be868..2c863d25327a 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -201,7 +201,7 @@ static unsigned long qat_dh_fn_id(unsigned int len, bool g2)
 		return g2 ? PKE_DH_G2_4096 : PKE_DH_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 static int qat_dh_compute_value(struct kpp_request *req)
@@ -572,7 +572,7 @@ static unsigned long qat_rsa_enc_fn_id(unsigned int len)
 		return PKE_RSA_EP_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 #define PKE_RSA_DP1_512 0x1c161b3c
@@ -601,7 +601,7 @@ static unsigned long qat_rsa_dec_fn_id(unsigned int len)
 		return PKE_RSA_DP1_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 #define PKE_RSA_DP2_512 0x1c131b57
@@ -630,7 +630,7 @@ static unsigned long qat_rsa_dec_fn_id_crt(unsigned int len)
 		return PKE_RSA_DP2_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 static int qat_rsa_enc(struct akcipher_request *req)
-- 
2.28.0

