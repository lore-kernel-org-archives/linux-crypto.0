Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3B4C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A406206A1
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="awNk+bBw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgGAIGL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:06:11 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41798 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgGAIGK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 04:06:10 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 061861Aj107359;
        Wed, 1 Jul 2020 03:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593590761;
        bh=4hku0A5tBDgqawwdEc1QQb0MtMEaM5yVRqiNn1VxG/A=;
        h=From:To:CC:Subject:Date;
        b=awNk+bBwQFkOafvmkLbFmXiIiP7ZiP6J4VIedliSahTZwZbdxEsmuymxQUKf6SPwN
         s3M0mpSTeg0LM3wkbW9wbUpNQm3/cn1KBCeKhGyFXgY7l/edCHYJi/gfDtfow/M+H1
         tpVD7LfeqhWjeAAxqjn8L+OEtefz09jqFm46REPA=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 061861HK003244
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jul 2020 03:06:01 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 1 Jul
 2020 03:06:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 1 Jul 2020 03:06:00 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06185wUc078048;
        Wed, 1 Jul 2020 03:05:59 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <j-keerthy@ti.com>
Subject: [PATCHv5 0/7] crypto: sa2ul driver support
Date:   Wed, 1 Jul 2020 11:05:46 +0300
Message-ID: <20200701080553.22604-1-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This latest incarnation of the series has patch #3 re-written for the
hash init/update/final sequencing only. As the HW accelerator can't
properly handle split up hashes, nor can its state be exported out, we
use software fallback now for all cases of hashing, except for digest.

Applies on top of 5.8-rc1, testing done:
- Crypto manager self tests (pass)
- Crypto manager extra self tests (pass)
- Openssl testing via cryptodev (pass)
- Ipsec testing over UDP tunnel (pass)
- tcrypt.ko testing for hashing/cipher (pass)

-Tero


--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
