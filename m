From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] [RFC] crypto/testmgr: add null test for 842 algorithm
Date: Mon, 13 Jul 2015 17:05:36 -0700
Message-ID: <20150714000536.GA38815@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224119.GF1712@linux.vnet.ibm.com>
 <20150704072453.GC6153@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:50729 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbGNAFm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 20:05:42 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Mon, 13 Jul 2015 20:05:41 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D61FDC90052
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2015 19:56:45 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6E05dtD64356590
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2015 00:05:39 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6E05bqJ019893
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2015 20:05:38 -0400
Content-Disposition: inline
In-Reply-To: <20150704072453.GC6153@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04.07.2015 [15:24:53 +0800], Herbert Xu wrote:
> On Thu, Jul 02, 2015 at 03:41:19PM -0700, Nishanth Aravamudan wrote:
> > Currently, when the nx-842-pseries driver loads, the following message
> > is emitted:
> > 
> > alg: No test for 842 (842-nx)
> > 
> > It seems like the simplest way to fix this message (other than adding a
> > proper test) is to just insert the null test into the list in the
> > testmgr.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> 
> Please add some real test vectors instead.
