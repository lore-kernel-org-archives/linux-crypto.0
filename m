Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EF5C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 12:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiKUMSu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 07:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiKUMSe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 07:18:34 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9B44F1AD
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 04:18:23 -0800 (PST)
Received: from mail.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170::5])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id E7C5DB0056A
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 13:18:21 +0100 (CET)
Received: from scapa.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id 81A129E
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 13:18:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corsac.net; s=2021;
        t=1669033096; bh=HRXD/vVZ59AEX+tvcO9x86W+D29X6hQg9+v1YxcH5RI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gR+4oSBSvS4CDSCX+qQBhDPT81F5QMDyW85k2mBGJypsyMaEDfAYqEULHuwQzhgCQ
         FlYvNnCW6no7nKk7YidnXb0usr0ezZ6YKHgn7SNI2uXESNLkUuJmvZ8dnWLf2muxl6
         Vsr5+R8BA7YuP6hQYOMVWLkAygpfTdg42oCIPQs3yqz9ZMfxIArASFs+GHrn/UOYbF
         RV+0NFuJE2RRjaTIWVllJM9WiLpGblo/eHAluTBTq3t/HTFlSajZAMkysYlQo+NDQj
         oEWIXJVPhcvweE+lnqKXwzLMrcVMaNQM0Rn8nqUdIWjhugQQ7PUS2P9pv/XicKmqFA
         ZZ+k2LqbDzT7A==
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a0052
        by scapa.corsac.net (DragonFly Mail Agent v0.13);
        Mon, 21 Nov 2022 13:18:16 +0100
Message-ID: <ec12c50a30400385e6180b53a4c17b2be82d10db.camel@corsac.net>
Subject: Re: crypto_alg_lookup() returning -80 (ELIBBAD)
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     linux-crypto@vger.kernel.org
Cc:     Tobias Brunner <tobias@strongswan.org>
Date:   Mon, 21 Nov 2022 13:18:10 +0100
In-Reply-To: <a378dcbc2a7ccb0353beb23b69039117ecbe8114.camel@corsac.net>
References: <a378dcbc2a7ccb0353beb23b69039117ecbe8114.camel@corsac.net>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.1-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Fri, 2022-10-07 at 18:17 +0200, Yves-Alexis Perez wrote:
> So there's definitely something fishy in my kernel and I'm unsure why.
>=20
> Would anyone have a clue about what is happening here, and any idea how t=
o
> debug further?

With some help from systemtap I managed to debug further and narrowed down =
the
problem to the RNG (and more specifically anssi_cprng).

When booting, first load of the module returns:

[    7.910500] alg: cprng: Failed to load transform for ansi_cprng: -2
[    7.917774] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)

But unloading/reloading the module afterwards only shows the second line an=
d
IPsec starts working again (whether the `ip xfrm state` lines or strongSwan
more generally).

I have yet to debug further but my feeling is that it might be TPM-related =
but
I'm unsure and have no clear debugging path for now. I'll let you know if I
find anything.

Regards,
- --=20
Yves-Alexis
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAmN7bIIACgkQ3rYcyPpX
RFsqdQgA62FGOagIAHKW000yQ/pm42+vO9DZFo7zJ17OHCsjintACME/bU3p3O+l
mmWz7yv1ib7GcCL19p1ZN/XX3ukORYwuvm3ixKy7mytRb1qwphKLKl1t08NeEceB
b7z2ZyjQAIPslkT0LL88fk5T3iOjelZg94fNTerUxDiGWCt6a8Oqz09jBUEK2yST
UgkOGVPlNQM5Frs/SUiC2HhkHQEmek/urwncKVBfBCcmJQcqaaGBKeAyZB+JEyCz
1h0HnrHhIhjWPj93SwdbaqjnT7eIOT+jQSQ67CatUWkQBEHT1FJgcyle/mzhb8hs
wGW4VaOtbfTOtdMVlXFyipNMszMG2g=3D=3D
=3D6MCJ
-----END PGP SIGNATURE-----
