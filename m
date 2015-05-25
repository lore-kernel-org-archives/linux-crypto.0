From: "Imre Kaloz" <kaloz@openwrt.org>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Mon, 25 May 2015 12:44:44 +0200
Message-ID: <op.xy6tguug2s3iss@ecaz>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com> <1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com> <20150525075812.GA28689@gondor.apana.org.au> <20150525101016.252a1dc0@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "Arnaud Ebalard" <arno@natisbad.org>,
	"Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
	"Gregory CLEMENT" <gregory.clement@free-electrons.com>,
	"Jason Cooper" <jason@lakedaemon.net>,
	"Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
	"Andrew Lunn" <andrew@lunn.ch>,
	"Tawfik Bayouk" <tawfik@marvell.com>,
	"Lior Amsalem" <alior@marvell.com>,
	"Nadav Haklai" <nadavh@marvell.com>,
	"Eran Ben-Avi" <benavi@marvell.com>,
	"Rob Herring" <robh+dt@kernel.org>,
	"Pawel Moll" <pawel.moll@arm.com>,
	"Mark Rutland" <mark.rutland@arm.com>,
	"Ian Campbell" <ijc+devicetree@hellion.org.uk>,
	"Kumar Gala" <galak@codeaurora.org>, devicetree@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Boris Brezillon" <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52593 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbbEYKpE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 06:45:04 -0400
In-Reply-To: <20150525101016.252a1dc0@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Boris,

On Mon, 25 May 2015 10:10:16 +0200, Boris Brezillon  
<boris.brezillon@free-electrons.com> wrote:

<snip>

> Yep, I noticed that after submitting this version. I guess I only
> needed the import function for my test cases and thus forgot to
> implement the import function.
> Anyway, I just added the the import functions (they'll be available in
> my v4).

Given the driver is supposed to work on platforms up to 38x, could v4  
include the missing bindings for those platforms, too?


Thanks,

Imre
