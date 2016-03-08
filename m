From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 1/3] crypto: authenc - add TLS type encryption
Date: Tue, 8 Mar 2016 08:49:55 -0800
Message-ID: <56DF02B3.1070006@intel.com>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
 <20160306012049.6369.99836.stgit@tstruk-mobl1>
 <AM4PR0401MB18766E17BCB4769B982ADFCBE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
 <56DD90CB.4080704@intel.com>
 <AM4PR0401MB1876F5088D4EC6BE577BC97CE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Cristian Stoica <cristian.stoica@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32795 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbcCHQyc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Mar 2016 11:54:32 -0500
In-Reply-To: <AM4PR0401MB1876F5088D4EC6BE577BC97CE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Cristian,
On 03/08/2016 12:20 AM, Cristian Stoica wrote:
> There is also a follow-up in the next paragraph:
> 
> "That pretty much sums up the new attack: the side-channel defenses that were hoped to be sufficient were found not to be (again). So the answer, this time I believe, is to make the processing rigorously constant-time."
> 
> The author makes new changes and continues instrumenting the code and still finds 20 CPU cycles (out of 18000) difference between medians for different paddings. This small difference was detected also on a timing side-channel - which is the point I'm making.
> 
> SSL/TLS is prone to this implementation issue and many user-space libraries got this wrong. It would be good to see some numbers to back-up the claim of timing differences as not being an issue for this one.

It is hard to get the implementation right when the protocol design is error prone.
Later we should run some tests on it and see how relevant will this be for a remote timing attack.
Thanks,
-- 
TS
