From: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv2 1/2] crypto: updates omap sham device related platform
 code
Date: Thu, 8 Apr 2010 07:11:47 -0600 (MDT)
Message-ID: <alpine.DEB.2.00.1004080700300.14871@utopia.booyaka.com>
References: <cover.1269524804.git.dmitry.kasatkin@nokia.com> <9e97cb8f5ee608a70bb9c04bc2c22f0d6b749d98.1269524804.git.dmitry.kasatkin@nokia.com> <alpine.DEB.2.00.1003300334110.14474@utopia.booyaka.com> <4BBDD0BF.6050307@nokia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "tony@atomide.com" <tony@atomide.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from utopia.booyaka.com ([72.9.107.138]:49319 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab0DHNLs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 09:11:48 -0400
In-Reply-To: <4BBDD0BF.6050307@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 8 Apr 2010, Dmitry Kasatkin wrote:

> Hi,
> 
> BTW..
> 
> How will it work if those resource structures anyway conditionally compiled
> for OMAP2 or 3 or 4?
> only one structure will be compiled at once.

Hi Dmitry,

it is possible to build a kernel that will run on both OMAP2 and OMAP3 
(for example).  We call these kernels 'multi-OMAP' kernels.  In such a 
case, there will be multiple CONFIG_ARCH_OMAP* symbols defined, so 
multiple structure records will be included in the kernel image.  Also 
when this happens, the 'cpu_is_omap*' macros will be defined to something 
that is evaluated at kernel run-time, rather than compile-time (as would 
be the case with single-OMAP kernels). So then the appropriate structure 
can be passed at run-time to some device registration code.


- Paul
