From: Jiten Lulla <lullajd@hotmail.com>
Subject: testmgr: async hashes : _update and _final tests
Date: Thu, 17 Oct 2013 17:00:35 +0530
Message-ID: <BAY167-W54E1042059A766EEEE0143B9050@phx.gbl>
References: <BAY167-W139EE62712A2A261B4BAF09B9050@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bay0-omc1-s18.bay0.hotmail.com ([65.54.190.29]:64108 "EHLO
	bay0-omc1-s18.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab3JQLgl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Oct 2013 07:36:41 -0400
In-Reply-To: <BAY167-W139EE62712A2A261B4BAF09B9050@phx.gbl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

=A0This is regarding the following patch:
=A0http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04527.ht=
ml

=A0I am using 2.6.39.4.

=A01 question:

=A0Q1. [SHA1]When I try to run sha1 tests on a hardware, I see that the=
 tests are running from sha1_tv_template[].
=A0[A] 3 tests are supposed to be run using crypto_ahash_digest() for l=
engths 3 bytes, 56 bytes and 163 bytes. +
=A0[B] 3 more tests (3, 56, 163 bytes again) are supposed to be run usi=
ng crypto_ahash_init/_update and _final().

=A0What I am observing is that in the [B] set of tests, the first test =
(length 3 bytes) runs with _init/_update/_final but the reamining two t=
ests (of length 56 and 163 bytes) run with crypto_ahash_digest() instea=
d of _init/_update/_final().

=A0I could not figure out why this is happening?


=A0~Jitendra 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
