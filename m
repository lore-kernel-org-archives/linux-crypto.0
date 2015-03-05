From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH 1/3] crypto: caam: fix some compile warnings
Date: Thu, 5 Mar 2015 09:12:13 +0200
Message-ID: <54F801CD.7040706@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com>
	<20150303125953.8585904680288a9734566b42@freescale.com>
	<54F66EA3.7080506@windriver.com>	<54F6909D.8040002@windriver.com>
	<54F6CA60.5030905@freescale.com>
 <20150304123419.7baecac7320d5b3483449dab@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <horia.geanta@freescale.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:52147
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753924AbbCEHMW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 02:12:22 -0500
In-Reply-To: <20150304123419.7baecac7320d5b3483449dab@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/04/2015 08:34 PM, Kim Phillips wrote:

> I don't see how, e.g., for one, dma_map_sg is I/O TLB
> implementation-dependent.

I'll need some remedial classes on this topic, but for the moment I
don't see how this matters for mapping sg chains. Can you share some
pointers?

Thanks,

Cristian S.
