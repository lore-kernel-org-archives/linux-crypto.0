From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove include
 plat/cpu.h
Date: Tue, 09 Oct 2012 11:03:10 +0200
Message-ID: <5073E84E.4090408@ti.com>
References: <20121008173452.10603.53886.stgit@muffinssi> <20121008173557.10603.18539.stgit@muffinssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
	linux-omap@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Liam Girdwood <lrg@ti.com>,
	Deepak Saxena <dsaxena@plexity.net>,
	Chris Ball <cjb@laptop.org>, Matt Mackall <mpm@selenic.com>,
	Venkatraman S <svenkatr@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	linux-crypto@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:39778 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab2JIJBp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2012 05:01:45 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so4797963oag.19
        for <linux-crypto@vger.kernel.org>; Tue, 09 Oct 2012 02:01:44 -0700 (PDT)
In-Reply-To: <20121008173557.10603.18539.stgit@muffinssi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2012 07:35 PM, Tony Lindgren wrote:

> - omap-dma.c and omap-pcm.c can test the arch locally as
>   omap1 and omap2 cannot be compiled together because of
>   conflicting compiler flags

>  sound/soc/omap/omap-pcm.c         |    9 +++++++--

Tony: is this going to be included in 3.7?

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
