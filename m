From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] [RFC] crypto/testmgr: add null test for 842 algorithm
Date: Mon, 13 Jul 2015 17:05:58 -0700
Message-ID: <20150714000558.GB38815@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224119.GF1712@linux.vnet.ibm.com>
 <20150704072453.GC6153@gondor.apana.org.au>
 <20150714000536.GA38815@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34490 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbGNAGE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 20:06:04 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Mon, 13 Jul 2015 18:06:03 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 985393E4003F
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2015 18:06:00 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6E05GfB38207720
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2015 17:05:16 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6E05x02016703
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2015 18:06:00 -0600
Content-Disposition: inline
In-Reply-To: <20150714000536.GA38815@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13.07.2015 [17:05:36 -0700], Nishanth Aravamudan wrote:
> On 04.07.2015 [15:24:53 +0800], Herbert Xu wrote:
> > On Thu, Jul 02, 2015 at 03:41:19PM -0700, Nishanth Aravamudan wrote:
> > > Currently, when the nx-842-pseries driver loads, the following message
> > > is emitted:
> > > 
> > > alg: No test for 842 (842-nx)
> > > 
> > > It seems like the simplest way to fix this message (other than adding a
> > > proper test) is to just insert the null test into the list in the
> > > testmgr.
> > > 
> > > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> > 
> > Please add some real test vectors instead.

Apologies, hit send too fast. I'll work with Dan on this when he gets
back from vacation.

-Nish
