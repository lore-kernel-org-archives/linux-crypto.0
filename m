From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sat, 09 Jun 2007 21:15:52 -0400
Message-ID: <466B50C8.1090106@cs.cmu.edu>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <Pine.LNX.4.64.0706090931330.4353@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:49813 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXFJBQK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2007 21:16:10 -0400
In-Reply-To: <Pine.LNX.4.64.0706090931330.4353@fbirervta.pbzchgretzou.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jan Engelhardt wrote:
> On Jun 8 2007 17:42, Benjamin Gilbert wrote:
>> @@ -0,0 +1,299 @@
>> +/*
>> + * x86-optimized SHA1 hash algorithm (i486 and above)
>> + *
>> + * Originally from Nettle
>> + * Ported from M4 to cpp by Benjamin Gilbert <bgilbert@cs.cmu.edu>
>> + *
>> + * Copyright (C) 2004, Niels M?ller
>> + * Copyright (C) 2006-2007 Carnegie Mellon University
>=20
> UTF-8 please. Hint: it should most likely be an =C3=B6.

Whoops, I had thought I had gotten that right.  I'll get updates for=20
parts 2 and 3 sent out on Monday.

Thanks
--Benjamin Gilbert
