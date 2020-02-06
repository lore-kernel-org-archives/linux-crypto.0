Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44900C3B187
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 15:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9C020838
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581001911;
	bh=i30whJ7D2bpvmToMc489B2VfCm0FjpxIYAYkHNRm1/k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=PsG9NM7A6mFOp3TH/XfFdBPuMh52mLEXCV5AceCavLtEx8TaO7egKyLGDZsNjiH82
	 JCLfXH9g1b1DzhtxBnPiRrxRnfLcbPhTs3YS7H62u/MH3ZYqwlaFqiMMXtdWqUO+d3
	 pS6NHYTdCVib3b+lcu1r4fT2ioFzgkneZeDwQtas=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBFPLt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:11:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgBFPLn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 10:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=bJ6PILGfUOQthYtbZN3ove/bOTHIs1fSUTSyIzy3I3s=; b=Sef8CK/oc5vfowAvrz0puPQxZS
        3pQTIUt14KlxR/ipQqYeok30cNc070WFIlyNjf7QPepexT9TtKJyhAr7vi+jUOzdSLNwVOOFYiW3W
        0Ux486wUblaP4/DyDEqsvG5fnhzIrUe6h4Uvvj9FmIoRJXTzqWxb22F+YmvZfAI3NMGovBXDPW/H2
        SbMtEk1qWe0qufiTx1oOJ5GKvQmdNeCP3ioiSvUs7Iry8RGyRASwZNW5BdmeEa1NaYaw0xqzZJpz+
        Lsh3zeo56Hc1hm9TdZauCL6VJSKwjrUreM5Qtt6Fzq2nOq4s83fAUIEjikevO1CqUyCSgiItFSWH4
        cCEPbHMw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izioc-000434-UW; Thu, 06 Feb 2020 15:11:42 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1izioV-002oMj-Lo; Thu, 06 Feb 2020 16:11:31 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Javi Merino <javi.merino@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        David Howells <dhowells@redhat.com>,
        Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        keyrings@vger.kernel.org
Subject: [PATCH 00/11] Manually convert  thermal, crypto and misc-devices to ReST
Date:   Thu,  6 Feb 2020 16:11:19 +0100
Message-Id: <cover.1581001737.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Manually convert some files from thermal, crypto and misc-devices
to ReST format.

This patch is against linux-next 20200204 tag.

Mauro Carvalho Chehab (11):
  docs: thermal: convert cpu-idle-cooling.rst to ReST
  docs: crypto: convert asymmetric-keys.txt to ReST
  docs: crypto: convert api-intro.txt to ReST format
  docs: crypto: convert async-tx-api.txt to ReST format
  docs: crypto: descore-readme.txt: convert to ReST format
  docs: misc-devices/spear-pcie-gadget.txt: convert to ReST
  docs: misc-devices/pci-endpoint-test.txt: convert to ReST
  docs: misc-devices/pci-endpoint-test.txt: convert to ReST
  docs: misc-devices/c2port.txt: convert to ReST format
  docs: misc-devices/bh1770glc.txt: convert to ReST
  docs: misc-devices/apds990x.txt: convert to ReST format

 .../crypto/{api-intro.txt => api-intro.rst}   | 186 +++++++------
 ...symmetric-keys.txt => asymmetric-keys.rst} |  91 +++----
 .../{async-tx-api.txt => async-tx-api.rst}    | 253 +++++++++++-------
 ...{descore-readme.txt => descore-readme.rst} | 152 +++++++----
 Documentation/crypto/index.rst                |   5 +
 .../driver-api/thermal/cpu-idle-cooling.rst   |  18 +-
 Documentation/driver-api/thermal/index.rst    |   1 +
 .../{ad525x_dpot.txt => ad525x_dpot.rst}      |  24 +-
 .../{apds990x.txt => apds990x.rst}            |  31 ++-
 .../{bh1770glc.txt => bh1770glc.rst}          |  45 +++-
 .../misc-devices/{c2port.txt => c2port.rst}   |  58 ++--
 Documentation/misc-devices/index.rst          |   6 +
 .../misc-devices/pci-endpoint-test.rst        |  56 ++++
 .../misc-devices/pci-endpoint-test.txt        |  41 ---
 .../misc-devices/spear-pcie-gadget.rst        | 170 ++++++++++++
 .../misc-devices/spear-pcie-gadget.txt        | 130 ---------
 16 files changed, 747 insertions(+), 520 deletions(-)
 rename Documentation/crypto/{api-intro.txt => api-intro.rst} (70%)
 rename Documentation/crypto/{asymmetric-keys.txt => asymmetric-keys.rst} (91%)
 rename Documentation/crypto/{async-tx-api.txt => async-tx-api.rst} (55%)
 rename Documentation/crypto/{descore-readme.txt => descore-readme.rst} (81%)
 rename Documentation/misc-devices/{ad525x_dpot.txt => ad525x_dpot.rst} (85%)
 rename Documentation/misc-devices/{apds990x.txt => apds990x.rst} (86%)
 rename Documentation/misc-devices/{bh1770glc.txt => bh1770glc.rst} (83%)
 rename Documentation/misc-devices/{c2port.txt => c2port.rst} (59%)
 create mode 100644 Documentation/misc-devices/pci-endpoint-test.rst
 delete mode 100644 Documentation/misc-devices/pci-endpoint-test.txt
 create mode 100644 Documentation/misc-devices/spear-pcie-gadget.rst
 delete mode 100644 Documentation/misc-devices/spear-pcie-gadget.txt

-- 
2.24.1


