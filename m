Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074E4C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 08:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiITIDT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiITIBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 04:01:51 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFD263F3F
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 01:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663660908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pNBPv0dQlEqfnuQ+xyBze7MGqAgLe+XS5KX5aETiv/8=;
        b=Yr5i5f+6fqH6BFQbrokqjhBBLGd6SOZzU1JnESH/LxfSOZe/q4mIkaMgQOQK9MFUB2WACy
        aNef3Vcg1r917hYl1DrGO5upvmEZA+PpGTi3ZRwEsOTB5HZz0yEOC7b8PbSPLLYd8heWIo
        CHTgppWIwT85EjTpIs64/D0K/WgSolj+DCWzyctw2sewvhvgjgtqt92fHgMXd4ZLfUq6pI
        vg62i8i2cgIpoKH3tPjpD6ZHBW5CvHxI75QeIAgYsl7ZEJxdDP2mn4SvbRknq0VT24rjrW
        zNfEHFMryCyWSPKS79HCfY+7KpFwgArhOFrS3swzhlZbgYe55apZ+0tjFIRH8Q==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-235-S6_y53J2Oaq-rydOI-MWxA-1; Tue, 20 Sep 2022 04:01:43 -0400
X-MC-Unique: S6_y53J2Oaq-rydOI-MWxA-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 20 Sep 2022 01:01:40 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH 0/3] crypto: inside-secure: Add Support for MaxLinear Platform
Date:   Tue, 20 Sep 2022 16:01:36 +0800
Message-ID: <cover.1663658153.git.pliem@maxlinear.com>
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

Peter Harliman Liem (3):
  crypto: inside-secure - Expand soc data structure
  crypto: inside-secure - Add fw_little_endian option
  crypto: inside-secure - Add MaxLinear platform

 drivers/crypto/inside-secure/safexcel.c | 73 ++++++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h | 10 +++-
 2 files changed, 61 insertions(+), 22 deletions(-)

--=20
2.17.1

