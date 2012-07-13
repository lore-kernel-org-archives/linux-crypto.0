From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 13/14] crypto: drivers - remove cra_list initialization
Date: Fri, 13 Jul 2012 12:00:57 -0500
Message-ID: <20120713170057.GA30312@linux.vnet.ibm.com>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
 <20120711112056.6875.58905.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	Michal Ludvig <michal@logix.cz>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-geode@lists.infradead.org,
	Varun Wadekar <vwadekar@nvidia.com>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52393 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2GMRB2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jul 2012 13:01:28 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Fri, 13 Jul 2012 11:01:28 -0600
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3650CC90080
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jul 2012 13:01:23 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6DH1Mge392846
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jul 2012 13:01:22 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6DH1ASs004526
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jul 2012 11:01:15 -0600
Content-Disposition: inline
In-Reply-To: <20120711112056.6875.58905.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 11, 2012 at 02:20:56PM +0300, Jussi Kivilinna wrote:
> Initialization of cra_list is currently mixed, most ciphers initialize this
> field and most shashes do not. Initialization however is not needed at all
> since cra_list is initialized/overwritten in __crypto_register_alg() with
> list_add(). Therefore perform cleanup to remove all unneeded initializations
> of this field in 'crypto/drivers/'.

Acked-by: Kent Yoder <key@linux.vnet.ibm.com>

Thanks,
Kent
