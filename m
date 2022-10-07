Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F9AC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Oct 2022 16:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJGQSL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Oct 2022 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJGQSK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2022 12:18:10 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20820D7E3B
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 09:18:06 -0700 (PDT)
Received: from mail.corsac.net (unknown [82.66.73.9])
        by smtp2-g21.free.fr (Postfix) with ESMTPS id CB68C2003E0
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 18:18:03 +0200 (CEST)
Received: from scapa.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id 9752498
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 18:17:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corsac.net; s=2021;
        t=1665159478; bh=EIm0pn66qhkBTaobK+hjbKVLCyGkpJraC17Do5PJF8Q=;
        h=Subject:From:To:Cc:Date:From;
        b=A8YhAlAUf3PdB72DlqQdHOObFpP2BCSg7TFolsxRA0iXWVAbaU7SR1MBqcQYgVi6w
         pTERyOLopMznOq2cr/1Gc3MdSGg2A8flv5VVHyiLfTc15M6Gft4IrJRkqde1FF8AFd
         nOWM+D+ouCAd7Vq9mS2LJuJxPHi7gAWiOLHgVOTZbXRa/MxuS5kfvJhQOZQRQRPpLp
         bWhH7Y+SzL4+VPY+f1ia+GVBqSk+mV1gpn9v0OZsa1stLX4f5BAEQgNHOX9AM8TMf5
         5/u4DSci/ebQNq9IgzniFXYGS25Qso+oDtToBeAy6rohDYrSq4uDkil7AJcJtR596P
         hcOYKOuAc3KZQ==
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a0180
        by scapa.corsac.net (DragonFly Mail Agent v0.13);
        Fri, 07 Oct 2022 18:17:58 +0200
Message-ID: <a378dcbc2a7ccb0353beb23b69039117ecbe8114.camel@corsac.net>
Subject: crypto_alg_lookup() returning -80 (ELIBBAD)
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     linux-crypto@vger.kernel.org
Cc:     Tobias Brunner <tobias@strongswan.org>
Date:   Fri, 07 Oct 2022 18:17:53 +0200
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.44.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi list,

since some time (and I'm unsure exactly when) my strongSwan IKE/IPsec setup=
 at
home doesn't work anymore, with charon reporting
(https://pastebin.com/7tThD1B5):

received netlink error: Accessing a corrupted shared library (80)

This is on a Debian Bullseye machine running Debian kernel 5.10.140-1 (5.10=
.0-
18-amd64).

With some help from Tobias Brunner (from strongSwan project) I tried to deb=
ug
the issue (I was already fairly certain it was a local issue because if the
standard Debian kernel started misbehaving like that we would have a whole =
lot
more reports everywhere. Removing strongSwan from the equation, I tried to
inject directly an xfrm state with ip (the parameter are a bit bogus but I
don't think it matters at that point):

ip xfrm state add src 10.0.0.1 dst 10.0.0.2 proto esp spi 123456 sel src
10.0.0.3 dst 10.0.0.4 enc aes 0xabcdefabcdef
RTNETLINK answers: Accessing a corrupted shared library

I tried on a different Debian box and the output is:

ip xfrm state add src 10.0.0.1 dst 10.0.0.2 proto esp spi 123456 sel src
10.0.0.3 dst 10.0.0.4 enc aes  0xaabbccddee
RTNETLINK answers: Invalid argument

So there's definitely something fishy in my kernel and I'm unsure why.

Would anyone have a clue about what is happening here, and any idea how to
debug further?

Regards,
- --=20
Yves-Alexis
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAmNAUTEACgkQ3rYcyPpX
RFtDUAf/Vu0Ls/bNtEXp1JoxmJucztLoUBGZyaLs1fnxig5TzlLAohOF2OjV1ykh
U3m4fCRqM5JThpLLyISoch4PNBRnjMaR58l/fnvpeEgI7TmBXwJiA4IiVQuvfos/
jxrlp8tAQUvJCm1Se8NGeolBTi0a+SngHig+mW0ix4jde1NKOWdVJ6MZPQgcSIM9
eI8Rdvska6RToQ6VsyscjhjdM6HS6sk7/2me3CF4ezcn3atAJwTANMwLv1Y4CS0x
UeT/HVdWCqPptYUDgyLhcF6OC49wjQ79zTfZcQOGYHJTNh9Q3rXXsLqICYsRaTiU
SXzhPZzOaALKeTfY1jXw0LAFfSwdnQ=3D=3D
=3Dkv2/
-----END PGP SIGNATURE-----
