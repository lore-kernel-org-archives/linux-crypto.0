From: Nicolas Brunie <nicolas.brunie@kalray.eu>
Subject: a few questions on AF_ALG specification (AEAD, socket/connection,
 ...)
Date: Tue, 26 Jul 2016 13:48:21 +0200
Message-ID: <57974E05.3030502@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra1.kalray.eu ([92.103.151.219]:45292 "EHLO
	zimbra1.kalray.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbcGZLsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 07:48:23 -0400
Received: from localhost (localhost [127.0.0.1])
	by zimbra1.kalray.eu (Postfix) with ESMTP id E1F7D280A24
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2016 13:48:21 +0200 (CEST)
Received: from zimbra1.kalray.eu ([127.0.0.1])
	by localhost (zimbra1.kalray.eu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id H1RxV2ty21rJ for <linux-crypto@vger.kernel.org>;
	Tue, 26 Jul 2016 13:48:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra1.kalray.eu (Postfix) with ESMTP id 87961280A3F
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2016 13:48:21 +0200 (CEST)
Received: from zimbra1.kalray.eu ([127.0.0.1])
	by localhost (zimbra1.kalray.eu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Hw9KZSnXjM5h for <linux-crypto@vger.kernel.org>;
	Tue, 26 Jul 2016 13:48:21 +0200 (CEST)
Received: from proetos.lin.mbt.kalray.eu (unknown [192.168.37.26])
	by zimbra1.kalray.eu (Postfix) with ESMTPSA id 73773280722
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2016 13:48:21 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,
    I am developping a driver for a crypto offloading solution which=20
uses the AF_ALG interface. I am trying to stay as close as possible to=20
the specification but apart from the kernel crypto source code and a fe=
w=20
documents (such as=20
https://www.kernel.org/doc/htmldocs/crypto-API/ch04s06.html ) I have no=
t=20
found a lot of details on AF_ALG specification and many points are not=20
very clear to me, it someone could point me towards reference to answer=
=20
the following questions it will be deeply appreciated.
*
**

Socket / Connection :

Is it legal to open multiple connections on an AF_ALG socket ? How is=20
the behavior defined

*From what I could test, at least for digests, multiple connections are=
=20
OK, but it seems odd to allow multiple connection to a cipher while=20
using a**shared key and multiple IVs. One of the use I could think of=20
will be parallelizing several encryption/decryption with the same=20
symmetric key.
*

Is it true that the key (defined via setsockopt) is common to all the=20
connections but the IV (defined through message control header) is=20
specific to each connection ?

*
*

Send/Recv interleaving

When computing a digest (e.g. sha256) it seems the recv call is=20
triggering the end of the digest accumulation, such a behavior can be=20
obtained by using/not using MSG_MORE flags, which *of the two*the=20
canonical way to compute a hash over several send messages ? It does no=
t=20
seem possible to compute a partial digest (through a recv call) and the=
n=20
continue accumulating through other send calls (apart from the security=
=20
risk of exposing a te*mporary digest, is there a reason why the recv=20
ends a digest computation ?)*.*

*

AES-GCM / AEAD

Does the aead_assoclen must be set once and for all for each stream or=20
is it a by message option ?

Option 0: set aead_assoclen during the first sendmsg and then stream=20
accross several sendmsg the full AAD and then the full plaintext/cipher=
text

Option 1: set aead_assoclen for each of the first sendmsg containing aa=
d=20
data. Once the aead_assoclen is strictly less than the msg=E2=80=99s da=
ta length=20
then the next messages must have aead_assoclen set to 0

*

best regards,
Nicolas Brunie
