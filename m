From: Leo Yan <leoy@marvell.com>
Subject: Question About Asymmetric Crypto
Date: Wed, 9 Dec 2009 01:58:45 -0800
Message-ID: <EC64E4604C8024438259B683BB2514E10780B3A772@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dafu Lv <dlv@marvell.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43083 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZLIJ6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2009 04:58:42 -0500
Received: from maili.marvell.com (maili.marvell.com [10.68.76.51])
	by dakia2.marvell.com (Spam & Virus Firewall) with ESMTP id 804AA23DA92
	for <linux-crypto@vger.kernel.org>; Wed,  9 Dec 2009 01:58:48 -0800 (PST)
Received: from maili.marvell.com (maili.marvell.com [10.68.76.51]) by dakia2.marvell.com with ESMTP id lrn35CqaTQScQxFa for <linux-crypto@vger.kernel.org>; Wed, 09 Dec 2009 01:58:48 -0800 (PST)
Received: from MSI-MTA.marvell.com (msi-mta.marvell.com [10.68.76.91])
	by maili.marvell.com (Postfix) with ESMTP id 67F5580F88
	for <linux-crypto@vger.kernel.org>; Wed,  9 Dec 2009 01:58:48 -0800 (PST)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, all

Sorry for that I have to ask the question once more for asymmetric cryp=
to.=20
And another question is about FIPS.

My problem is our SOC chip is the application processor, and provide th=
e Crypto hardware engine with hash, symmetric crypto (aes, 3des, etc) a=
nd asymmetric crypto (PKCS-RSA, ECC, etc).=20

We want use the Linux CryptoAPI to enable the crypto engine. But now Li=
nux CryptoAPI has supported (a)hash and (a)blockcipher well, but can NO=
T support asymmetric crypto.

So question is: Does Linux CryptoAPI will be a general crypto engine ac=
celerator framework for Linux platform, or just only dedicated for Linu=
x Kernel?
Like the thread has discussed, http://osdir.com/ml/linux.kernel.cryptoa=
pi/2007/msg00307.html,
Some guys think that nobody wants to use RSA in the kernel, but if Linu=
x CryptoAPI wants support user space (As Herbert has mentioned it in th=
e September's conference), then the scenario is changing.
=46or example, if the browsers use the OpenSSL, and OpenSSL can call th=
e Linux CryptoAPI to get the HW acceleration, and eventually optimize i=
ts performance.

So I want get more clearly for this point. Any comment is appreciated. =
Thanks a lot.

=20
Best Regards,
Leo Yan

=A0
Best Regards,
Leo Yan
=A0
Ext: 24880
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
