Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF178C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 15:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiA1Pie (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 10:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiA1Pie (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 10:38:34 -0500
X-Greylist: delayed 327 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Jan 2022 07:38:33 PST
Received: from mail.pqgruber.com (mail.pqgruber.com [IPv6:2a05:d014:575:f70b:4f2c:8f1d:40c4:b13e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8100C061714
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 07:38:33 -0800 (PST)
Received: from workstation (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 7FE7CC2FBA4;
        Fri, 28 Jan 2022 16:33:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1643383984;
        bh=OITQFSeLoNTaXoQED/aKEaT2kE+25ScYSreXKHuTHfA=;
        h=Date:From:To:Cc:Subject:From;
        b=NbBf9e9rpPTm5HzXRBIwqfgxKRXpJXS3lroGug11DjQGS+/0o1GYLaP/+TwLDn9cd
         UueeXefUgAJHk1RhWYmbF6B9HpZ159DcyG5H5YCgS11nY29AGMTWGhqfnq80omiudv
         KP9B0c2DBPLS635qUi/LWIGxwZ+6qxZmRD3x/MwI=
Date:   Fri, 28 Jan 2022 16:33:00 +0100
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        linux-imx@nxp.com
Subject: caam: Possible caam-rng regression since enabling prediction
 resistance
Message-ID: <YfQMrBtwKd2Wa+AY@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I noticed that /dev/hwrng blocks indefinitely on our i.MX6Q (rev1.6)
boards in recent kernel versions.
As it did work before, I ran git bisect and found that reverting the
following commit fixes the issue:
358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG")

cat /dev/hwrng | rngtest looks good on Linux 5.15 with aforementioned
commit reverted.
U-Boot version is 2021.07 and the RNG is not instantiated there.

Any ideas what the problem could be with that commit and did you test
the changes on i.MX6 devices?

Let me know if you need more information / debug output / etc.

Best regards,
Clemens
