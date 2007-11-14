From: David Miller <davem@davemloft.net>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
 64bit-ization
Date: Tue, 13 Nov 2007 17:41:04 -0800 (PST)
Message-ID: <20071113.174104.224925773.davem@davemloft.net>
References: <20071113.150702.628183529.takamiya@po.ntts.co.jp>
	<20071113.152545.859492002.takamiya@po.ntts.co.jp>
	<200711131534.33521.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51276
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXKNBlF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 20:41:05 -0500
In-Reply-To: <200711131534.33521.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 13 Nov 2007 15:34:33 -0700

> My preferred solution is to make loop unrolling conditional on
> CONFIG_CC_OPTIMIZE_FOR_SIZE - and this is what is done in my
> (first) patch (see attached). This part:

The default build is going to be CONFIG_CC_OPTIMIZE_FOR_SIZE
basically for everyone, this is what people get by default
and this is what every distribution uses.

Therefore %99.9999 of folks will get the slowdown.

So in my book this is not an acceptable way to deal with
this problem.
