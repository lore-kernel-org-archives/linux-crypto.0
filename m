From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: Openssl/Openssh Offload to Linux Crypto
Date: Tue, 10 Mar 2009 19:46:34 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B0747FC81@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <herbert@gondor.apana.org.au>, "Loc Ho" <lho@amcc.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:48677 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZCKCqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2009 22:46:40 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am trying to use OpenSSH (which uses the Openssl lib with HW Offload =
crypto engine support). I am using the patched version of OpenSSL that =
I submitted. It uses the /dev/crypto interface that was provided by the=
 patch [1] submitted to Opensource.=20
       The interface is provided in such a way that one file descriptor=
 per session is opened. On this fd we set the session, do cipher/hash o=
perations and when done delete the session and close the fd. The proble=
m arises after running this iteration (open, session set, operation and=
 close) for several hundred times (over 500 times), the opening of file=
 /dev/crypto fails with error -2 (no such file). I tried looking at the=
 open system call implementation and found that =93inode =3D next.dentr=
y->d_inode=94 is NULL in routine =93__link_path_walk=94 in fs/namei.c =A0=
which is not the case when it is working.

Why would the opening of /dev/crypto fails only after several hundred i=
teration?=A0I verified the cryptodev driver functionality and looked at=
 the Openssl code but was not able to determine the cause of the proble=
m. This is with Linux 2.6.28.3.

Any thoughts/suggestions about what could be wrong would be highly appr=
eciated.

Thanks,
Shasi

[1] Add CryptoAPI User Interface Support Patch v6
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
