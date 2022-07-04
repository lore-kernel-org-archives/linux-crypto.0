Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DF8C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jul 2022 07:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGDH0h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jul 2022 03:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiGDH0f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jul 2022 03:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362366574
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jul 2022 00:26:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB3CB80D26
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jul 2022 07:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133F3C3411E;
        Mon,  4 Jul 2022 07:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656919592;
        bh=c51pFXpuGQWYCtD4EDctZd4NRjVurEPLoayHs9RAZMs=;
        h=In-Reply-To:References:Subject:From:To:Date:From;
        b=kAksR6RdVrT8z3FDFPcbSJTAAVq5ZU+rNFU5KeUElJK0tyFIbVLHI7ZUu2F1q+03a
         dEVz6LkfDZLKX5lJoinjuFahuoT8NYVJOSuJoAgPTeUppvt8nKKgxIW1SSJKbjFjKw
         Gu7FjA4nLUN0cPZnmOegw2YUtCC5JlN02wFaItcXkgxHupfVZIZy48zoGrTUsyteYS
         LMsa48EyNCRKqcLJKNaF8oPtY3kCgyagrO5FfW1sudGo+nDeAQGfuZJOIkPJlLiR1M
         Gqv9lUueLvBYNfL/evoea+fuUrUq7Hy+ZsIQX3976sSaEkSTk0/nm2yl+1O/TU720e
         YWCEEWch/pLfw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220702071426.1915429-1-oferh@marvell.com>
References: <20220702071426.1915429-1-oferh@marvell.com>
Subject: Re: [PATCH] crypto: inside-secure: fix packed bit-field result descriptor
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, oferh@marvell.com
Message-ID: <165691958960.3764.6967842126015044710@kwain>
Date:   Mon, 04 Jul 2022 09:26:29 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ofer,

Quoting oferh@marvell.com (2022-07-02 09:14:26)
> From: Ofer Heifetz <oferh@marvell.com>
>=20
> When mixing bit-field and none bit-filed in packed struct the
> none bit-field starts at a distinct memory location, thus adding
> an additional byte to the overall structure which is used in
> memory zero-ing and other configuration calculations.
>=20
> Fix this by removing the none bit-field that has a following
> bit-field.
>=20
> Signed-off-by: Ofer Heifetz <oferh@marvell.com>

Nice catch!

Note: since those fields were not used before and IIRC the below result
struct size is set dynamically (the h/w doesn't expect a fixed size)
this doesn't need to be backported to stable trees. Can't test it on
real h/w though.

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/safexcel.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/ins=
ide-secure/safexcel.h
> index ce1e611a163e..797ff91512e0 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -497,15 +497,15 @@ struct result_data_desc {
>         u32 packet_length:17;
>         u32 error_code:15;
> =20
> -       u8 bypass_length:4;
> -       u8 e15:1;
> -       u16 rsvd0;
> -       u8 hash_bytes:1;
> -       u8 hash_length:6;
> -       u8 generic_bytes:1;
> -       u8 checksum:1;
> -       u8 next_header:1;
> -       u8 length:1;
> +       u32 bypass_length:4;
> +       u32 e15:1;
> +       u32 rsvd0:16;
> +       u32 hash_bytes:1;
> +       u32 hash_length:6;
> +       u32 generic_bytes:1;
> +       u32 checksum:1;
> +       u32 next_header:1;
> +       u32 length:1;
> =20
>         u16 application_id;
>         u16 rsvd1;
> --=20
> 2.25.1
>=20
