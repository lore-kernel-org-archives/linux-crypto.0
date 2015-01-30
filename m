From: Conor O'Gorman <i@conorogorman.net>
Subject: Re: [PATCH v1 0/3] SHA256 for PPC/SPE
Date: Fri, 30 Jan 2015 12:02:42 +0000
Message-ID: <54CB72E2.1030101@conorogorman.net>
References: <5ad377b3-e491-4c35-8b89-de1dfd0749a6__44574.29146064$1422133918$gmane$org@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org
To: Markus Stockhausen <stockhausen@collogia.de>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fep26.mx.upcmail.net ([62.179.121.46]:37494 "EHLO
	fep26.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563AbbA3MSj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2015 07:18:39 -0500
In-Reply-To: <5ad377b3-e491-4c35-8b89-de1dfd0749a6__44574.29146064$1422133918$gmane$org@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/01/15 21:10, Markus Stockhausen wrote:
> [PATCH v1 0/3] SHA256 for PPC/SPE
>
> The following patches add support for SIMD accelerated SHA256
> calculation on PPC processors with SPE instruction set. The

Nice boost.

Many of the SoCs with e500 core have crypto hardware accelerators. How 
does this compare?

Thanks,
Conor
