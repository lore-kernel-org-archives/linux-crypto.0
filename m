Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E94C388F9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0EF821D41
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 19:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jAlyIsI5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829292AbgJ0TES (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:04:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1829285AbgJ0TES (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 15:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603825457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Lh9LpJ3xp/HEd5FTWkXTDeH3pzRCHbh41QZoY7qmsLY=;
        b=jAlyIsI5nolMSvILeTWMPZE0UMe9uwqMk5dZ9Wm3V4OnqNXk5negVxy+iViG+un7cyhk0j
        NKPTKxlqQSrShkU7l6QuR/XtV1hibuH3DIU5dgezD36fHQwHYsFD/TnLFobEn4kjJQpq9i
        SMMIcaXI0URGL3Cghs3drkwc7jTapKo=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-88iuZifcOM6sSbHPvZ3rVQ-1; Tue, 27 Oct 2020 15:04:13 -0400
X-MC-Unique: 88iuZifcOM6sSbHPvZ3rVQ-1
Received: by mail-ot1-f71.google.com with SMTP id e1so751840otb.21
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2020 12:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Lh9LpJ3xp/HEd5FTWkXTDeH3pzRCHbh41QZoY7qmsLY=;
        b=dBtZqGyx3hq5aMxfA+33dYsx5o2BW2kmwd+bCG+jXzhPZ6Ag6AUCgmu+p+drow+doi
         7CfAvLvN2aEOrDewiOYP6guCIqCMGss0eNfpDhIkjZ/qch7pghNYE+XQvEfOwrCofNGK
         1cYBRs8V6u++nHDtBIxChyJItzqVLM+pONdBTIoU9IgFaFbaKa0+/7Z9SM6pg6BfR4NA
         Aqhirx6/ajnc4SSGYobNYasbmrgcCts/VnxsT3XAO4dQH5aIddL/29VthXHwydscyRSD
         DixEK6hAJmoZ4bqrcktXbTNN2eIfXRch9wBNTWod7TdSx7XRbPfO+mCG1l6bGmPF9lQ6
         A+cQ==
X-Gm-Message-State: AOAM530UQ5CvNL0mq05/bJDgFPP7CgGhQyX2R3uBVezhnaAL0bP7fWCD
        xEA7U4Yr4Sti/3qpDB1BNo33vXS+U2HAGCot5XZlaeuvJGBU7g0fpJuga/HJNFBlNMvUjZj7gID
        IeW8UofBZoRilO3946toouauH
X-Received: by 2002:a4a:d8c1:: with SMTP id c1mr2914218oov.31.1603825453196;
        Tue, 27 Oct 2020 12:04:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvw7oDmX4Y9Qq+lv0BXLIdNWKnR8vgPIn4RzyZlnd2saiZ8H8D1LJGtyG5d3zxPaP61mcgtQ==
X-Received: by 2002:a4a:d8c1:: with SMTP id c1mr2914198oov.31.1603825452956;
        Tue, 27 Oct 2020 12:04:12 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q10sm1698690oih.56.2020.10.27.12.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:04:12 -0700 (PDT)
From:   trix@redhat.com
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, ebiggers@google.com,
        dominik.przychodni@intel.com, wojciech.ziemba@intel.com,
        mpatocka@redhat.com, geert+renesas@glider.be, ardb@kernel.org
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: qat: remove unneeded semicolon
Date:   Tue, 27 Oct 2020 12:04:07 -0700
Message-Id: <20201027190407.1587980-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c      | 2 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index d552dbcfe0a0..f5d890206e86 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -103,7 +103,7 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 		return ICP_QAT_HW_SHA512_STATE1_SZ;
 	default:
 		return -EFAULT;
-	};
+	}
 	return -EFAULT;
 }
 
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 846569ec9066..04f2cf769fc1 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -201,7 +201,7 @@ static unsigned long qat_dh_fn_id(unsigned int len, bool g2)
 		return g2 ? PKE_DH_G2_4096 : PKE_DH_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 static inline struct qat_dh_ctx *qat_dh_get_params(struct crypto_kpp *tfm)
@@ -577,7 +577,7 @@ static unsigned long qat_rsa_enc_fn_id(unsigned int len)
 		return PKE_RSA_EP_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 #define PKE_RSA_DP1_512 0x1c161b3c
@@ -606,7 +606,7 @@ static unsigned long qat_rsa_dec_fn_id(unsigned int len)
 		return PKE_RSA_DP1_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 #define PKE_RSA_DP2_512 0x1c131b57
@@ -635,7 +635,7 @@ static unsigned long qat_rsa_dec_fn_id_crt(unsigned int len)
 		return PKE_RSA_DP2_4096;
 	default:
 		return 0;
-	};
+	}
 }
 
 static int qat_rsa_enc(struct akcipher_request *req)
-- 
2.18.1

