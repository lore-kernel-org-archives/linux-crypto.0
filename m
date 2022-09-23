Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13325C6FA82
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 09:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiIWJXJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiIWJXG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 05:23:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9BE1092
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 02:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A263261154
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 09:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C6C433D7;
        Fri, 23 Sep 2022 09:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663924981;
        bh=jB8DTAANaELUsT1tbCAFnTi32ojGeoSINsTTOJtDBjE=;
        h=In-Reply-To:References:Cc:From:To:Subject:Date:From;
        b=AnX45GK1Vrv3vDD5huyof7y1iXSk1xU1++2hoAGQtJuyrUqwT9yhZxccgVUV7P0d5
         j+lbiwRSHT6DCLxM55DdQmwlrmbtChlMu1aF/GCSVG4PgWqk4CmEUDE9+BEIe1Jq/V
         urNPFCu8qkevuErcRibTWbCQQAar1tVvs4BtqXHsRUCcpPlEcjELNVQfZRuVBdL4rr
         a2IHvtzAJ52k7CQ92Tk+gAzvmneuSGFn/vd1bi/cF0jyA68F/PDyNTzTH4FVuJKJyB
         cN25NEkrHGYKWT5k8GtlLiy2GRsFIa5bmBYsRt4oZe4WhFp3Mtu7X3Z0u1N5cJmqV2
         XtO6iBHtOF4Iw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
References: <cover.1663660578.git.pliem@maxlinear.com> <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>,
        pvanleeuwen@rambus.com
From:   Antoine Tenart <atenart@kernel.org>
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 2/3] crypto: inside-secure - Add fw_little_endian option
Message-ID: <166392497841.3511.3731514363575087582@kwain>
Date:   Fri, 23 Sep 2022 11:22:58 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-20 10:01:38)
> This is to add fw_little_endian option, which can
> be used for platform which firmware is using little-endian
> (instead of big-endian).

That's surprising, releasing fw in various endianness.

Cc Pascal who might know.
