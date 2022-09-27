Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC0FC6FA82
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiI0DN1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiI0DMX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:12:23 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31DF1168
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NpIohj1MqrHMplpfuy2jBg+VW7xqrhYbAbLY0Hnptsk=;
        b=VA59UMoKCXKy4oCpAbacxcW59iT7KsjIG7B7uKHAKlv02frVMQtIv5URuLpBOwhOrqc11F
        4jbMsHfvMI2ZTUERHyBWJtYMA5ioQAvL4OlTpiv5MzbM/18JiJvKXDpkeRYU9/Jo9ZtqEn
        VfzL77z60atTbUp1zymQ3SMN4uIv3F/d3qpLk3qozJkmEokh7Ow7lLP5QGf0IVs+Pk0DWY
        woBMVv/7E+0j8jRkth9oGix8nSse0IiRb1v4fPvhmvwPjupTyko8Pz29YZ5VC47EX14jKv
        yjYrD4kXY7G0hV6L1WZSx9kMvBe9jS5CV0GZUkl+cCek89J2sbZB0Jw3r9jSjA==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-520-Dphtqy8RPreigSlUTNuIuw-1; Mon, 26 Sep 2022 23:10:18 -0400
X-MC-Unique: Dphtqy8RPreigSlUTNuIuw-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 26 Sep 2022 20:10:15 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        <pvanleeuwen@rambus.com>, Peter Harliman Liem <pliem@maxlinear.com>
Subject: [PATCH v2 0/3] crypto: inside-secure: Add Support for MaxLinear Platform
Date:   Tue, 27 Sep 2022 11:10:07 +0800
Message-ID: <cover.1664247167.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I have been utilizing inside-secure driver on MaxLinear
SoC platform (which has eip197 hardware inside).

One issue I found is that I needed to flip the endianness
in eip197_write_firmware() function, which for reason I am
not aware is using big-endian.
The firmware that I have is clearly using little-endian,
and unfortunately I do not have access to Marvell platform
to do more investigation or comparison there.
I have also tried to look for clues in Inside-Secure's
hardware/firmware documentation, without success.

Thus, assuming each vendor may use different endian format,
on these patch set I add support for little-endian firmware
(default remains big-endian). MaxLinear platform can then
utilize the option, which is implemented as soc data.

An alternative to this would be implementing the option
as a new device-tree property, but for now I assume we do
not need that since each platform endianness should be
fixed, and will not vary per board/hardware.

Please help review.

Thanks!

v2:
 Revert directory change for generic case.
 Add missing driver data change in pci_device_id.
 Rename data struct to safexcel_priv_data.
 Rework endianness selection code casting, to fix warning caught by kernel =
test robot.
 Rename mxl version string to eip197 'c'.

Peter Harliman Liem (3):
  crypto: inside-secure - Expand soc data structure
  crypto: inside-secure - Add fw_little_endian option
  crypto: inside-secure - Add MaxLinear platform

 drivers/crypto/inside-secure/safexcel.c | 69 ++++++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h | 10 +++-
 2 files changed, 59 insertions(+), 20 deletions(-)

--=20
2.17.1

