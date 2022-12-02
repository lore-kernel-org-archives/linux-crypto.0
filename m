Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2213C4321E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 14:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiLBOnl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 09:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLBOnk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 09:43:40 -0500
Received: from mail.steuer-voss.de (mail.steuer-voss.de [85.183.69.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED860A8093;
        Fri,  2 Dec 2022 06:43:36 -0800 (PST)
X-Virus-Scanned: Debian amavisd-new at mail.steuer-voss.de
Received: by mail.steuer-voss.de (Postfix, from userid 1000)
        id A14142030; Fri,  2 Dec 2022 15:43:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.steuer-voss.de (Postfix) with ESMTP id 9D76B1FC9;
        Fri,  2 Dec 2022 15:43:29 +0100 (CET)
Date:   Fri, 2 Dec 2022 15:43:29 +0100 (CET)
From:   Nikolaus Voss <nv@vosn.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
cc:     Nikolaus Voss <nikolaus.voss@haag-streit.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: caam: blob_gen.c: warn if key is insecure
In-Reply-To: <94f5f20b-f7c9-b9b5-1b49-3c4366b47370@pengutronix.de>
Message-ID: <46085da-4dd4-f02e-1e1d-442cfceeeb15@vosn.de>
References: <20221121141929.2E36427E9@mail.steuer-voss.de> <94f5f20b-f7c9-b9b5-1b49-3c4366b47370@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2 Dec 2022, Ahmad Fatoum wrote:
> On 21.11.22 15:12, Nikolaus Voss wrote:
>> +	ctrlpriv = dev_get_drvdata(jrdev->parent);
>> +	moo = FIELD_GET(CSTA_MOO, ioread32(&ctrlpriv->ctrl->perfmon.status));
>
> Sorry for not having spotted this the first time, but ioread32 is not
> completely correct here as the CAAM may be big endian while the CPU is
> little endian.
>
> You should be using rd_reg32 here.

Ok.

Herbert, shall I spin v3 of the patch or patch against v2?

Niko
