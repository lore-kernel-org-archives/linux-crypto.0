Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D8C3F68F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 06:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B69B20848
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 06:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578290574;
	bh=5hxva25df32tAsqNh8cqFx9odnLgu5hRKNw8HZPCLjk=;
	h=In-Reply-To:References:Cc:To:Subject:From:Date:List-ID:From;
	b=R39Tz8YV5xtOgIS41eWG9hGnQPoH0gaWXx2ozT9qJOmO5sx7S2MnIow6q+4RVLsaC
	 GtQD209qaAalvFmjmGBEqebFl9dEZtu/MreJtxxkY1D9+OjMesDLKaK1fljZ7MxHus
	 ByonTfJzj8xHK9txO1qrMmcMIEmFYGkYz4S8wAJ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgAFGCr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 01:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgAFGCr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 01:02:47 -0500
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A5720848;
        Mon,  6 Jan 2020 06:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578290566;
        bh=5hxva25df32tAsqNh8cqFx9odnLgu5hRKNw8HZPCLjk=;
        h=In-Reply-To:References:Cc:To:Subject:From:Date:From;
        b=eJpHhyL6Zn+jn0TWh26dV/uWPfkkWmsibBqQhvb21LVcA6A7krW1p2EYvzXNOKOcK
         ZHOPLcOkOfPCnDSxRNQ3b9pxbUrX2wYkH4wWSFdwiASwgMB9KVTYbGmcU+0aeg6ay6
         vV9ndySbUZQE22ipz4z55cTxtK2FyQVvBOuHX2Vk=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
References: <20200106045833.1725-1-masahiroy@kernel.org>
Cc:     Julia Lawall <julia.lawall@lip6.fr>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code check
From:   Stephen Boyd <sboyd@kernel.org>
User-Agent: alot/0.8.1
Date:   Sun, 05 Jan 2020 22:02:45 -0800
Message-Id: <20200106060246.49A5720848@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Masahiro Yamada (2020-01-05 20:58:33)
> 'PTR_ERR(p) =3D=3D -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
>=20
> The semantic patch that generates this commit is as follows:
>=20
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) =3D=3D - error_code)
> +PTR_ERR(ptr) =3D=3D - error_code
> // </smpl>
>=20
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---

For

>  drivers/clk/clk.c                    | 2 +-

Acked-by: Stephen Boyd <sboyd@kernel.org>

