From: David Miller <davem@davemloft.net>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
 64bit-ization
Date: Tue, 13 Nov 2007 19:49:52 -0800 (PST)
Message-ID: <20071113.194952.229187981.davem@davemloft.net>
References: <200711131534.33521.vda.linux@googlemail.com>
	<20071113.174104.224925773.davem@davemloft.net>
	<200711131947.09040.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39322
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757357AbXKNDtx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 22:49:53 -0500
In-Reply-To: <200711131947.09040.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 13 Nov 2007 19:47:08 -0700

> If CONFIG_CC_OPTIMIZE_FOR_SIZE is not an acceptable method,
> do you have other ideas?

Look at ways to make the code run faster without loop unrolling?
