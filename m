From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH 5/7] crypto: marvell: Adding a complete operation for
 async requests
Date: Thu, 16 Jun 2016 15:41:54 +0200
Message-ID: <5762ACA2.3050703@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
 <1466018134-10779-6-git-send-email-romain.perier@free-electrons.com>
 <20160615225531.4e060f11@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47286 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079AbcFPNmN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 09:42:13 -0400
In-Reply-To: <20160615225531.4e060f11@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 15/06/2016 22:55, Boris Brezillon a =E9crit :
>> +
>
> Nit: not sure you should mix this cosmetic change with the other
> changes.

Ok


> You already have ivsize initialized.
>
>> +		memcpy_fromio(ablkreq->info, basereq->chain.last->data, ivsize);
>
> Use memcpy() here.

good catch, for both.

Thanks,
Romain
--=20
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
