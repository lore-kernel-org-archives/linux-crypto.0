From: Nils Rennebarth <Nils.Rennebarth@web.de>
Subject: Long pause when using pcrypt
Date: Thu, 22 Apr 2010 10:57:24 +0200
Message-ID: <4BD00F74.9030102@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41616 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0DVI50 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Apr 2010 04:57:26 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate01.web.de (Postfix) with ESMTP id B5DA01574EF01
	for <linux-crypto@vger.kernel.org>; Thu, 22 Apr 2010 10:57:24 +0200 (CEST)
Received: from [84.56.142.139] (helo=[192.168.1.2])
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #4)
	id 1O4sDs-00047i-00
	for linux-crypto@vger.kernel.org; Thu, 22 Apr 2010 10:57:24 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

As parallel encryption of ipsec is now in the official kernel, I tried =
to use
it, and to actually make ipsec connections use it, I did

  $ modprobe tcrypt alg=3D'pcrypt(authenc(hmac(sha1),cbc(aes)))' type=3D=
3

This works, but the computer pauses for about 60s when running the modp=
robe,
and appears to be completely idle in the meantime. Why is that necessar=
y?

Is there another recommended way to instantiate pcrypt, e.g. via netlin=
k?
I searched for a while, by browsing the sources, but found nothing appr=
opriate.

- --
                                     ______
                                    (Muuuhh)
Global Village Sau  =3D=3D>        ^..^ |/=AF=AF=AF=AF=AF
(Kann Fremdsprache) =3D=3D>        (oo)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkvQD3QACgkQqgAZ+sZlgs43DgCg43ehtSAai1A+v8c2vuIuuIxO
dloAn0TeB/Ur+b/mUI6dUhA1UCZpGCmp
=3DSLiY
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
