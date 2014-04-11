From: Fan Du <fan.du@windriver.com>
Subject: Why care about signal when instantiate an crypt template
Date: Fri, 11 Apr 2014 15:37:53 +0800
Message-ID: <53479BD1.3050508@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:50059 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaDKHeF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Apr 2014 03:34:05 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
	by mail.windriver.com (8.14.5/8.14.5) with ESMTP id s3B7Y4gP011713
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2014 00:34:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I recently bump into a issue, ike daemon got interrupted(EINTR),
after looking at the code, it seems there are places in crypto code
where returning EINTR when current tasks has signal pending.

=46or example:
crypto_alloc_base and crypto_alloc_tfm

435 err:
436                 if (err !=3D -EAGAIN)
437                         break;
438                 if (signal_pending(current)) {
439                         err =3D -EINTR;
440                         break;
441                 }
442         }

I can't understand why the codes here needs to care about signals?

Thanks a lot for any explanations.

--=20
=E6=B5=AE=E6=B2=89=E9=9A=8F=E6=B5=AA=E5=8F=AA=E8=AE=B0=E4=BB=8A=E6=9C=9D=
=E7=AC=91

--fan
