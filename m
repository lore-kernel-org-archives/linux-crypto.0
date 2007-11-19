From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 00/03]: RNG support v2
Date: Mon, 19 Nov 2007 19:25:25 +0100
Message-ID: <4741D515.3050900@trash.net>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain> <200711191919.42466.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Buesch <mb@bu3sch.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXKSSZt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 13:25:49 -0500
In-Reply-To: <200711191919.42466.mb@bu3sch.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Michael Buesch wrote:
> On Sunday 18 November 2007 22:32:52 Patrick McHardy wrote:
>> These patches add support for using the HIFN rng.
> 
> Acked-by: Michael Buesch <mb@bu3sch.de>
> 
> Patrick, can you send this patchset to Andrew for inclusion into -mm?


I think he already pulls from Herbert's cryptodev-2.6 tree
(otherwise the patches useless anyway since the HIFN driver
is only in that tree).
