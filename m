Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED579C54FD0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAEAD20728
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vaduqBPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDXQpC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:45:02 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36500 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXQpB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 12:45:01 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03OGipKm125914;
        Fri, 24 Apr 2020 11:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587746691;
        bh=UFAZuZOFMTb8IXoTM322zKhgW1j96v9ZEMarM751rl8=;
        h=From:To:Subject:Date;
        b=vaduqBPCAyi8yOr8FUJGUmCqOlKplc13fZlX0q41CmEook1IJV01f4CbJviFgLr5U
         a8uDs/pKuudVMnwNaOLYx2++AzKY4mZZ1rdRBdwiidpcwxglcLltV71PYSVMklEeGu
         70yQsX8QzClf2Lj8CS/xJmC68XAMgNiM1Vyyt2b8=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03OGipvK105539
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Apr 2020 11:44:51 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 24
 Apr 2020 11:44:51 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 24 Apr 2020 11:44:51 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03OGinT5033554;
        Fri, 24 Apr 2020 11:44:50 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCHv2 0/7] crypto: TI SA2UL crypto accelerator support
Date:   Fri, 24 Apr 2020 19:44:23 +0300
Message-ID: <20200424164430.3288-1-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This is 2nd revision of the series [1] Keerthy posted quite a while back,
I've sort of adopted the series for now. Compared to v1, there has been
pretty major re-design I've done across the driver to fix any review
comments, fix any bugs I've encountered, and get the full crypto
self-test suite working with the driver, including the extra tests.
I've also tested the driver with tcrypt and IPSec suite just to root out
any issues. This series applies on top of 5.7-rc1 also and has no
dependencies. The DTS patches are provided for reference here only, and
should be merged separately via ARM SoC tree once the driver is ready.

There is maybe one aspect of the driver I am somewhat uncertain myself,
and that is the init/update/final handling with the hash algorithm
support, or the caching part of it actually. If someone calls the device
with init+update sequences never finalizing the data, we end up with
memory leaks. Any thoughts on that how to handle it? I could maybe add
some timeout to purge stale buffers or alternatively just drop to SW
fallback completely for non-digest type hashing, but that would prevent
openssl/devcrypto from using the crypto accelerator completely; it uses
init+update+final sequence heavily.

-Tero

[1] https://patchwork.kernel.org/cover/11021337/


--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
