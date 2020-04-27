Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55587C54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 05:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A8C206B6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 05:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgD0FmA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 01:42:00 -0400
Received: from foss.arm.com ([217.140.110.172]:56590 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgD0FmA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 01:42:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A74EB31B;
        Sun, 26 Apr 2020 22:41:59 -0700 (PDT)
Received: from ssg-dev-vb.arm.com (E111385.Arm.com [10.50.65.54])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADCE03F73D;
        Sun, 26 Apr 2020 22:41:56 -0700 (PDT)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hadar Gat <hadar.gat@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: [PATCH 0/3] hwrng: cctrng kconfig updates
Date:   Mon, 27 Apr 2020 08:41:36 +0300
Message-Id: <1587966099-28139-1-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some fixes in Kconfig for cctrng:
 + add missing dependency on OF
 + change default to 'n'
 + improve inaccurate help description

Hadar Gat (3):
  hwrng: cctrng - Add dependency on OF
  hwrng: cctrng - change default to n
  hwrng: cctrng - update help description

 drivers/char/hw_random/Kconfig | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.7.4

