From: "Imre Kaloz" <kaloz@openwrt.org>
Subject: Re: [PATCH v3 14/16] ARM: marvell/dt: enable crypto on armada-xp-gp
Date: Tue, 26 May 2015 11:22:45 +0200
Message-ID: <op.xy8j7ryh2s3iss@ecaz>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com> <1432301642-11470-15-git-send-email-boris.brezillon@free-electrons.com> <55633B6D.7080307@free-electrons.com> <20150526105936.25db3afb@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "Arnaud Ebalard" <arno@natisbad.org>,
	"Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
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
To: "Gregory CLEMENT" <gregory.clement@free-electrons.com>,
	"Boris Brezillon" <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [78.24.191.176] ([78.24.191.176]:38178 "EHLO arrakis.dune.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbEZJXp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 05:23:45 -0400
In-Reply-To: <20150526105936.25db3afb@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 26 May 2015 10:59:36 +0200, Boris Brezillon  
<boris.brezillon@free-electrons.com> wrote:

<snip>

>> As the crypto engine really depend on the SoC itself and not of the  
>> board,
>> what about updating the dts of the other board using an Armada XP?
>
> But that means introducing changes I haven't tested. Are you okay with
> that ?

Well, worst case send it as a separate patch as RFC - I'm sure people will  
test and report back.


Cheers,

Imre
