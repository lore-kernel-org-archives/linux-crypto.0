From: Dave Jones <davej@redhat.com>
Subject: Re: GPF in aesni_xts_crypt8 (3.10-rc5)
Date: Tue, 11 Jun 2013 15:17:46 -0400
Message-ID: <20130611191746.GA31945@redhat.com>
References: <20130611172624.GA20496@redhat.com>
 <51B773ED.9080308@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	herbert@gondor.hengli.com.au,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3FKTSB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Jun 2013 15:18:01 -0400
Content-Disposition: inline
In-Reply-To: <51B773ED.9080308@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 11, 2013 at 10:01:01PM +0300, Jussi Kivilinna wrote:
 > Hello,
 > 
 > Does attached patch help?
 > 
 > crypto: aesni_intel - fix accessing of unaligned memory

It does, thanks for the quick turnaround! 

	Dave
