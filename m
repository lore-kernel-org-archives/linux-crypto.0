Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC72C636CD
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 03:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBJDcy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 22:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBJDcy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 22:32:54 -0500
X-Greylist: delayed 390 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 19:32:51 PST
Received: from psionic.psi5.com (psionic.psi5.com [IPv6:2a02:c206:3008:6895::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70035BA52
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 19:32:51 -0800 (PST)
Received: from [IPV6:2a02:8106:18:4800:9e5c:8eff:fec0:ee40] (unknown [IPv6:2a02:8106:18:4800:9e5c:8eff:fec0:ee40])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by psionic.psi5.com (Postfix) with ESMTPSA id 057003F073
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 04:26:18 +0100 (CET)
Message-ID: <d9c58a67-b254-5a42-ca3d-38a0b504de83@hogyros.de>
Date:   Fri, 10 Feb 2023 04:26:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Language: en-US
From:   Simon Richter <Simon.Richter@hogyros.de>
Subject: ahash with hardware queue
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YkjKqQBGyWQHEW0Dt0tyHj6E"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YkjKqQBGyWQHEW0Dt0tyHj6E
Content-Type: multipart/mixed; boundary="------------5qrdSKszuquK7bIE9MsqV7b7";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Message-ID: <d9c58a67-b254-5a42-ca3d-38a0b504de83@hogyros.de>
Subject: ahash with hardware queue

--------------5qrdSKszuquK7bIE9MsqV7b7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCkkgaGF2ZSBhIFNIQTI1NiBpbXBsZW1lbnRhdGlvbiBpbiBhbiBGUEdBIHRoYXQg
a2VlcHMgdGhlIGhhc2ggc3RhdGUgaW4gDQppbnRlcm5hbCByZWdpc3RlcnMsIGFuZCB1c2Vz
IERNQSB0byByZWFkIGlucHV0IGRhdGEgYW5kIHJldHVybiB0aGUgaGFzaCANCm91dHB1dC4N
Cg0KRmlyc3Qgb2YgYWxsLCB0aGUgcmVzdWx0IG9mIHRoZSBoYXNoIGlzIGluYWNjZXNzaWJs
ZSBieSBETUEsIHNvIEkndmUgaGFkIA0KdG8gYWRkIGEgc2VwYXJhdGUgcmVzdWx0IHF1ZXVl
IHdpdGggYW4gaW50ZXJydXB0IGJvdHRvbSBoYWxmIGhhbmRsZXIgDQp0aGF0IGNvcGllcyB0
aGUgcmVzdWx0IGJhY2sgaW50byB0aGUgcmVxdWVzdC4gSXMgdGhlcmUgYSBiZXR0ZXIgd2F5
IHRvIA0KZG8gdGhpcywgZS5nLiBhIGZsYWcgSSBjYW4gc2V0IHRvIGdldCBhIERNQSBhY2Nl
c3NpYmxlIHJlc3VsdCBidWZmZXI/DQoNClNlY29uZCwgdGhlIGltcG9ydC9leHBvcnQgQVBJ
cyBzZWVtIHRvIGJlIHN5bmNocm9ub3VzLiBJJ2QgbGlrZSB0byBydW4gDQp0aGVzZSB0aHJv
dWdoIHRoZSBub3JtYWwgcmVxdWVzdC9yZXN1bHQgcXVldWVzIGFsb25nIHdpdGggb3RoZXIg
DQpyZXF1ZXN0cywgYnV0IG9idmlvdXNseSByZXR1cm5pbmcgLUVJTlBST0dSRVNTIGZyb20g
ZXhwb3J0IGlzIGEgYmFkIGlkZWEuDQoNCkNhbiBJIG1ha2UgbXkgZXhwb3J0IGZ1bmN0aW9u
IHN5bmNocm9ub3VzIGJ5IHNsZWVwaW5nIHVudGlsIHRoZSANCmNvbXBsZXRpb24gaW50ZXJy
dXB0IGFycml2ZXMsIG9yIGlzIHRoYXQgYSBiYWQgaWRlYT8NCg0KSSBjb3VsZCBwb3NzaWJs
eSBpbXBsZW1lbnQgYSBzeW5jaHJvbm91cyBpbnRlcmZhY2UgYnkgYWx3YXlzIHJldHVybmlu
ZyANCnRoZSBjdXJyZW50IGhhc2ggc3RhdGUgaW4gdGhlIHJlc3VsdCBxdWV1ZSBmb3IgZWFj
aCBhc3luY2hyb25vdXMgDQpvcGVyYXRpb24gYW5kIHVwZGF0aW5nIHRoZSByZXF1ZXN0IGlu
IGNhc2UgYW4gZXhwb3J0IHJlcXVlc3QgY29tZXMgDQphbG9uZywgaXMgdGhhdCByZWFsbHkg
dGhlIGJlc3Qgb3B0aW9uPw0KDQogICAgU2ltb24NCg==

--------------5qrdSKszuquK7bIE9MsqV7b7--

--------------YkjKqQBGyWQHEW0Dt0tyHj6E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmPluVkACgkQfr04e7CZ
CBHTtAf/WnMdrw9Tx5FgI9W737MNAWSeh1SeCm/eSccUoj72mr3g2QXCRVZG650G
5XWorTcpqm4Ab7Zz1q/45YwuEuXF3R312QimrclogESQdEcoiLgCa342Bz7qZAwF
QCUUTNpSrxBo3MeF1JFwUyAN/6DaV5hniHTid7lBEU702qksLxiUL1zh4T7TEFbc
BhxEvk0NIKZMpX14f3pHcVu3dwXAL1iH1gNmFpRg6ensebvAcRaaOtG+c5krVlQH
1PfzOcc6wUSmdDd8TFm0VDkNTS0GSaxpMFiXrljZvAxZqERGh5DKYjKjMXMWWScU
nLtqKeflesJZeQQN51jtG63eblZ0fQ==
=FPuS
-----END PGP SIGNATURE-----

--------------YkjKqQBGyWQHEW0Dt0tyHj6E--
