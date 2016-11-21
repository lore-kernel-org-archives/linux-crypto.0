From: Patrick Steinhardt <ps@pks.im>
Subject: PROBLEM: unable to decrypt LUKS partition since v4.9-rc6 (bisected)
Date: Mon, 21 Nov 2016 07:56:38 +0100
Message-ID: <20161121065638.GA540@pks-pc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52618 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751019AbcKUG4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 01:56:41 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm using cryptsetup 1.7.2 via the kernel's crypto API. Since
version v4.9-rc6, I'm unable to decrypt my LUKS partitions
(aes-xts-plain64, sha512). cryptsetup simply aborts with the
message "No such passphrase available" after inputting the
passphrase.

After bisecting the issue, this points to commit a8348bc (crypto:
algif_hash - Fix NULL hash crash with shash, 2016-11-17). After
reverting this particular commit, everything works correctly
again.

Please let me know if you need additional information.

Regards
Patrick

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYMpqkAAoJEBF8Z7aeq/Es68MP/1mHeFd7JG4BKFRPrOpfDdQU
SdBxPNXDP9/WIvUBNAaipJGN7gN0CPuyEcls2cxlVXpXgvx3WJRjxqM4fy8IbLi8
/CeE2VRHKrYhMDPGJosBqqS+tn0/K5C4crcnAh1FcXffof9WoF8HpacoVoubSNOZ
KigIvtE0EkfliTLl6RaGUm8ZjSaE3L+sLYtSIKbADBtluQyngYu7d9czzuZI0Ics
mrEjWDYreAIfUlfy5//md8ikPd2AEtRGcPiHeGjpEFyGNPxz1Lkdcbsa1ksUy59N
TIs8gCunibVhz/QMKfwCrMCfyKt5F4lMhyievvGaBs6GXeJUkjgf5tA6q/RTTEX4
c4SYlihB1QY1nhq6QatF/pS3uryTfLBUM/cxMn0ompsYQ8vVZMRq3KdSvNGaUsgz
j1RZj9j9MXAKVfYPV/GQZ38J3++EN3udrrdT43KIHP7dFYjoxN4X440YWw7AVMrL
AgT4KaSOUlLgL/QgbwHIue0FckHD3cXlfwnIB0DpoPW2JHuyivIzNhfuw/sWUBZj
wq3mZkf7pe7jOt7FnMIZkoerrnfH7SliWWgxMvVzZU8E9Tox/k06PuEsl+On1mPW
aiTZSAFfmVr9YcROybbp31QVfOIR9UBFb8I7CVKPLGu6qLutwonx0xpkSKwo/dpz
hyer08ijvnIHSANhpBTY
=5eIS
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
