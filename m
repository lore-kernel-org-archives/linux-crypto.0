From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 23 Oct 2012 19:11:40 +0200
Message-ID: <20121023171139.GH9930@philter.vipri.net>
References: <20120620154131.GR9122@philter.vipri.net>
 <20120625134050.GB12294@philter.vipri.net>
 <4FE874BD.2020909@gmail.com>
 <4FE88C63.8010103@gmail.com>
 <20120625215928.GA3853@philter.vipri.net>
 <4FEEAC54.10503@gmail.com>
 <20120706153018.GB24676@philter.vipri.net>
 <4FF91CE7.7090205@gmail.com>
 <20120709125450.GB30493@philter.vipri.net>
 <5017CB92.9010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:36843 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab2JWRSg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2012 13:18:36 -0400
Content-Disposition: inline
In-Reply-To: <5017CB92.9010708@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

On Tue, Jul 31, 2012 at 08:12:02PM +0800, cloudy.linux wrote:
> Sorry for taking so long time to try the latest code. Just came back 
> from a vacation and tried several days to get a tight sleep.

My apologies for having a ~3months lag. Somehow I have totally forgotten
about your mail in my inbox and just recently found it again.

Luckily, I received testing hardware from a colleague a few days ago on
which I can reproduce the problems at hand. So for now, I can do the
testing on my own. Thanks a lot for yours!

I'll get back to you (probably via linux-crypto) as soon as I have some
useful progress. Could be that I have to implement bigger changes in
code flow for Orion, as the IDMA seems to lag this "Enhanced Software
Flow" functionality (how the Kirkwood datasheet calls it) I am relying
upon in my current code. Will see.

Best wishes, Phil
