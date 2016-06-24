From: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] hwrng: OMAP: Fix assumption that runtime_get_sync will
 always succeed
Date: Fri, 24 Jun 2016 11:54:52 -0500
Message-ID: <576D65DC.5050205@ti.com>
References: <1466787040-26184-1-git-send-email-nm@ti.com>
 <1466787040-26184-2-git-send-email-nm@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <s-anna@ti.com>,
	Paul Walmsley <paul@pwsan.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466787040-26184-2-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/24/2016 11:50 AM, Nishanth Menon wrote:
> pm_runtime_get_sync does return a error value that must be checked for
> error conditions, else, due to various reasons, the device maynot be
> enabled and the system will crash due to lack of clock to the hardware
> module.
> 


Oh crap! Apologies, please ignore the v1 patch which was unfortunately
reposted. Sorry for the spam - i was pretty sure I cleared out the old
patch, but looks I was wrong.

V2 of the patch is here: https://patchwork.kernel.org/patch/9197919/



-- 
Regards,
Nishanth Menon
